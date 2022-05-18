#https://www.davidepesce.com/2019/10/14/godot-tutorial-5-1-dragging-player-with-mouse/

extends KinematicBody2D

signal shadow_fish_collision(collider)

var DRAG_SPEED = 20
var RETURN_SPEED = 18
var CORD_DISTANCE = 200
var MOMENTUM_MULT = 1.5
var PROJECTILE_SPEED_DIVISOR = 0.5
var PROJECTILE_WEIGHT = 0.1 #how quickly the projectile slows down after launch

var being_dragged = false
var movement = Vector2(0,0)
#var projectile_movement = Vector2(0,0)
var projectile_target_position = Vector2(0,0)
var projectile_target_last_visible_position = Vector2(0,0)
var base_position #initial position of the projectile, target, and slingshot sprite
var last_vector = Vector2(0,0)

onready var cord = get_node("cord")
onready var target = get_node("target")
onready var projectile = get_parent().get_node("projectile")

onready var boat = get_node_or_null("../../../") #THIS IS BAD CODE THAT WILL BREAK IF THINGS GET MOVED AROUND
var warning_printed = false #for warning when the above node path is not reached

# fish collision and exclamation mark spawning
var fish_collision_sprite_timer
var FISH_COLLISION_SPRITE_WAIT_TIME = 0.5
var exclamation_mark_texture = load("res://textures/exclamation_mark.png")
var exclamation_mark_sprite

# fisher sprite management
onready var fisher = get_node("../fisher")
var fisher_pole_back_tex = load("res://textures/fisher/FisherPoleBack.png")
var fisher_pole_standing_tex = load("res://textures/fisher/FisherPoleStanding.png")
var fisher_standing_tex = load("res://textures/fisher/FisherStanding.png")
var FISHER_POLE_BACK_Y_OFFSET = 30
var FISHER_POLE_STANDING_Y_OFFSET = -35
var fisher_pole_out = false

var played_splash = false

## Called when the node enters the scene tree for the first time.
func _ready():
	set_pickable(true) #allows object to detect mouse entering and exiting, should be true by default, this is here for clarity
	base_position = position
	target.visible = false
	
	projectile.visible = false
	projectile.set_as_toplevel(true)
	projectile.scale *= get_parent().scale #doesn't work
	
	fish_collision_sprite_timer = Timer.new()
	add_child(fish_collision_sprite_timer)
	fish_collision_sprite_timer.connect("timeout",self,"on_fish_collision_sprite_timer_end")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && !event.pressed:
			being_dragged = false
			projectile_target_position = target.global_position
			projectile_target_last_visible_position = target.global_position

func _input_event(_viewport, event, _shape_idx): #for mouse events that specifically involve this object
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			being_dragged = event.pressed
			projectile_target_position = target.global_position
			projectile_target_last_visible_position = target.global_position
			
			if (event.pressed):
				fisher.set_texture(fisher_pole_back_tex)
				fisher.set_offset(Vector2(0, FISHER_POLE_BACK_Y_OFFSET))
				fisher_pole_out = true

func _physics_process(_delta):
	if being_dragged:
		#move slingshot to cursor
		var new_position = get_global_mouse_position() #was get_viewport().get_mouse_position()
		movement = DRAG_SPEED*(new_position - global_position) #movement = DRAG_SPEED*(new_position - position)

		#maybe delete later, resets projectile on drag
		reset_projectile()
		
		fisher.rotation = (position-base_position).angle() - PI/2

	else:
		var momentum = MOMENTUM_MULT*last_vector
		var direction
		
		if (boat != null):
			direction = base_position - position.rotated(boat.rotation)*get_parent().scale  #not normalized, this is intentional
		else: #this breaks when rotated, but it's here as a failsafe for running this scene on its own outside the overworld
			direction = base_position - position*get_parent().scale
			if(!warning_printed):
				print("spinny bug will occur if slingshot is rotated, check if scenes have moved, ignore if you are running the slingshot separately from overworld")
				warning_printed = true
			
		#if (direction.length() < 0.01): #rounding down to prevent horrible bugs, not sure if necessary
		#	direction = Vector2(0,0)
		#	momentum = Vector2(0,0)

		var changed_direction = (last_vector + direction).length() < last_vector.length() + direction.length()
		if (changed_direction && !projectile.visible):
			projectile.visible = true
			#projectile_target_position = target.global_position
			#projectile_movement = (target.position - base_position)/PROJECTILE_SPEED_DIVISOR
			print("butt") #DO NOT DELETE, or do, IDC
		last_vector = direction
		movement = RETURN_SPEED*(direction + momentum)
		
		if !target.visible && Input.is_mouse_button_pressed(BUTTON_LEFT): #this is for bringing the bobber in when no fish is caught
			projectile_target_position = projectile_target_position + (target.global_position - projectile_target_position)/20
			

# warning-ignore:return_value_discarded
	move_and_slide(movement)

	manage_cord()

	target.position = 4*(base_position - position)
	if (boat != null):
		target.set_rotation(-boat.rotation) #makes target not rotate with boat
	target.visible = being_dragged

	#Move the projectile when it's visible
	if projectile.visible:
		#projectile.position =  lerp(projectile.position, base_position + projectile_target_position, PROJECTILE_WEIGHT)
		#projectile.move_and_slide(Vector2(0,0)) #copout choice, for cowards
		
		if projectile.position.distance_to(projectile_target_position) > 0.5: #just ensures the projectile stops when it reaches its target
			projectile.move_and_slide((projectile_target_position - projectile.position)/PROJECTILE_WEIGHT)
			#projectile.position =  lerp(projectile.position, base_position + projectile_target_position, PROJECTILE_WEIGHT)
			#projectile.move_and_slide(Vector2(0,0))
		elif projectile.position.distance_to(projectile_target_last_visible_position) < 0.5 && !played_splash:
			var random_sound_number = randi() % 4
			match random_sound_number:
				0:
					SoundFx.play_sound("splash1")
				1:
					SoundFx.play_sound("splash2")
				2:
					SoundFx.play_sound("splash3")
				3:
					SoundFx.play_sound("splash_bobber_bad")
			played_splash = true
		elif (boat != null) && boat.get_node("boat_area2d").overlaps_body(projectile):#(projectile_target_position.distance_to(base_position + boat.global_position) < 0.5):
			reset_projectile()
		elif (boat == null) && (projectile_target_last_visible_position.distance_to(base_position) < 25):
			reset_projectile()
		else:
			projectile.move_and_slide(Vector2(0,0)) #this is super hacky, but it should let fish swim into the projectile as opposed to just getting hit by it to trigger the reel scene
		
		#projectile_movement = lerp(projectile_movement, Vector2.ZERO, PROJECTILE_DRAG) #slow down projectile over time
		
		#projectile.move_and_slide(projectile_movement)
		var last_collision = projectile.get_last_slide_collision()
		if last_collision != null && last_collision.get_collider() != null:
			if last_collision.get_collider().has_meta("shadowfish"):
				
				#spawn an exclamation mark
				var exclamation_mark_texture = load("res://textures/exclamation_mark.png")
				exclamation_mark_sprite = Sprite.new()
				exclamation_mark_sprite.set_as_toplevel(true)
				add_child(exclamation_mark_sprite)
				exclamation_mark_sprite.set_texture(exclamation_mark_texture)
				exclamation_mark_sprite.set_position(projectile.position)
				exclamation_mark_sprite.set_scale( Vector2(0.5,0.5) )
				
				fish_collision_sprite_timer.set_wait_time(FISH_COLLISION_SPRITE_WAIT_TIME)
				fish_collision_sprite_timer.start()
				
				reset_projectile()
				
				emit_signal("shadow_fish_collision", last_collision.get_collider())
			else:
				projectile_target_position = projectile.position
	
	if !projectile.visible && !being_dragged && fisher_pole_out: #reset fisher to standing position
		fisher.set_texture(fisher_standing_tex)
		fisher.set_offset(Vector2(0, 0))
		fisher_pole_out = false
	elif projectile.visible && !being_dragged && !fisher_pole_out:
		fisher.set_texture(fisher_pole_standing_tex)
		fisher.set_offset(Vector2(0, FISHER_POLE_STANDING_Y_OFFSET))
		fisher_pole_out = true
	
	# debug
	#print(cord.points)
	#print(target.position)
	#print(direction)
	manage_cord()

func on_fish_collision_sprite_timer_end():
	if(is_instance_valid(exclamation_mark_sprite)):
		exclamation_mark_sprite.queue_free()

func manage_cord(): #yeah, this could be done a lot better
	cord.points[0] = base_position-position-Vector2(CORD_DISTANCE,0)
	#cord.points[1] = position
	cord.points[2] = base_position-position+Vector2(CORD_DISTANCE,0)

func reset_projectile():
	projectile.visible = false
	played_splash = false
	if (boat != null):
		#projectile.set_as_toplevel(false)
		projectile.position = boat.global_position + base_position
		projectile_target_position = boat.global_position + base_position
	else:
		projectile.position = base_position
		projectile_target_position = base_position
	
### og code below ###

## Called when the node enters the scene tree for the first time.
#func _ready():
#	set_pickable(true) #allows object to detect mouse entering and exiting, should be true by default, this is here for clarity
#	base_position = global_position
#	target.visible = false
#	projectile.visible = false

#func _input_event(_viewport, event, _shape_idx): #for mouse events that specifically involve this object
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT:
#			being_dragged = event.pressed
#
#func _input(event):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT and not event.pressed:
#			being_dragged = false
#
#func _physics_process(_delta):
#	if being_dragged:
#		var new_position = get_viewport().get_mouse_position()
#		movement = DRAG_SPEED*(new_position - position)
#	else:
#		var momentum = MOMENTUM_MULT*last_vector
#		var direction = (base_position-position)  #not normalized, this is intentional
#		if (direction.length() < 0.1): #rounding down to prevent horrible bugs, not sure if necessary
#			direction = Vector2(0,0)
#			momentum = Vector2(0,0)
#
#		var changed_direction = (last_vector + direction).length() < last_vector.length() + direction.length()
#		if (changed_direction && !projectile.visible):
#			projectile.visible = true
#			projectile_target_position = target.position
#			projectile_movement = (target.position - base_position)/PROJECTILE_SPEED_DIVISOR
#			print("butt")
#		last_vector = direction
#		movement = RETURN_SPEED*(direction + momentum)
#
#	move_and_slide(movement)
#
#	manage_cord()
#
#	target.position = 4*(base_position - position)
#	target.visible = being_dragged
#
#	if projectile.visible:
#		projectile.move_and_slide(projectile_movement)
#		if (projectile_movement.x > 0 && projectile_movement.x > projectile_target_position.x) || (projectile_movement.y > 0 && projectile_movement.y > projectile_target_position.y) || (projectile_movement.x < 0 && projectile_movement.x < projectile_target_position.x) || (projectile_movement.y < 0 && projectile_movement.y < projectile_target_position.y) || (projectile_movement.x == 0 && projectile_movement.y):
#			print("ass")
#			projectile.visible = false
#			projectile.position = base_position
#
#func manage_cord(): #yeah, this could be done a lot better
#	cord.points[0] = base_position-position-Vector2(CORD_DISTANCE,0)
#	#cord.points[1] = position
#	cord.points[2] = base_position-position+Vector2(CORD_DISTANCE,0)
