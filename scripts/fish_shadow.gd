extends KinematicBody2D

var COLLISION_RADIUS = 10
var SWIM_DIRECTION_CHANGE_TIME = 3
var FISH_TURN_SLOWNESS = 100

var fish_type = "placeholder" #might want to change this to like an index or something, could use enums even idk, use 
var fish_direction
var fish_target_direction
var fish_speed

var fish_collision_shape
var fish_sprite

var swim_timer

var unique_weight = 0

# Called when the node enters the scene tree for the first time.
func _ready(): #may need to do some freeing
	random_speed_and_target_direction()
	fish_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	
	set_fish_sprite_from_weight() #used twice to prevent attempting to access unitialized variables, possibly a bad idea
	
	z_index = -1
	
	fish_collision_shape = CollisionShape2D.new()
	fish_collision_shape.shape = CircleShape2D.new()
	fish_collision_shape.shape.set_radius(COLLISION_RADIUS)
	
	var fish_sprite_rect = fish_sprite.get_rect().abs()
	fish_collision_shape.position.y = fish_collision_shape.position.y + (fish_sprite_rect.position.y - fish_sprite_rect.end.y)/2
	
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(1, true)
	
	add_child(fish_collision_shape)
	
	swim_timer = Timer.new()
	swim_timer.set_wait_time(SWIM_DIRECTION_CHANGE_TIME)
	add_child(swim_timer) #to process
	swim_timer.start()
	swim_timer.connect("timeout",self,"randomize_fish_movement")

func draw():
	fish_collision_shape.draw()

func _physics_process(delta):
	swim()

func initialize_unique_variables(given_fish_type_string):
	if given_fish_type_string != null:
		set_fish_type(given_fish_type_string)
#		print(given_fish_type_string)
		#print(Global._get_fish_data(given_fish_type_string))
		unique_weight = rand_range(Global._get_fish_data(given_fish_type_string).get("Min Weight"), Global._get_fish_data(given_fish_type_string).get("Max Weight"))
		set_fish_sprite_from_weight()
	else:
		set_fish_type("Beta Fish") #lol
		unique_weight = rand_range(0, 105)
		set_fish_sprite_from_weight()
#		print("fish_shadow: initialize_unique_variables: given null string")

func set_fish_type(given_string): #this function could call another function that gets info from a json and sets it
	set_meta("shadowfish", "given_string") #makes a metadata category called fish and sets its value to "given_string"
	fish_type = given_string #should probably be made redundant

func get_fish_type():
	return fish_type
	
func get_fish_weight():
	return unique_weight

func set_fish_sprite_from_weight(fish_weight:int = unique_weight):
	fish_sprite = Sprite.new()
	if fish_weight >= 100:
		fish_sprite.set_texture(load("res://textures/fish_shadows/big_fish.png"))
	elif fish_weight >= 50:
		fish_sprite.set_texture(load("res://textures/fish_shadows/med_fish.png"))
	else:
		fish_sprite.set_texture(load("res://textures/fish_shadows/small_fish.png"))
	add_child(fish_sprite)
	
func swim():
	fish_direction = fish_direction + (fish_target_direction - fish_direction)/FISH_TURN_SLOWNESS
	move_and_slide(fish_speed*fish_direction)
	rotation = fish_direction.angle() + Vector2(0, 1).angle()
	
func random_speed_and_target_direction():
	change_direction_random()
	change_speed_random()

func change_direction_random():
	fish_target_direction = Vector2(rand_range(-1, 1),rand_range(-1,1)).normalized()
	
func change_direction(given_direction): #please give a Vector2
	fish_target_direction = given_direction

func change_speed_random():
	fish_speed = rand_range(0, 25)
	
func change_speed(given_speed):
	fish_speed = given_speed

func is_in_distance(center, x_distance, y_distance):
	return position.x > center.x - x_distance && position.x < center.x + x_distance && position.y > center.y - y_distance && position.y < center.y + y_distance

func randomize_fish_movement():
	change_direction_random()
	change_speed_random()

func despawn():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
