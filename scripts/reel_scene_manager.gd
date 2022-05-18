extends Node2D

signal reel_game_over(game_lost, fish_type)

#var DRAG_SPEED = 65
#var DRAG_SPEED_SWIM = 45

var FISH_TENSION_MAX = 100
var line_width_max

#var screen_size = Vector2(0,0)

onready var fishy = get_node("fish")
onready var line = get_node("line")
#onready var fish_tension_bar = get_node("fish_tension_bar")
onready var fish_force_bar = get_node("fish_force_bar")
#onready var fish_distance_bar = get_node("fish_distance_bar")

#fish variables from fish data

#to make fish swim in the direction it was swimming before reeling in during swim mode
var fish_prev_direction = Vector2(0,0)
var fish_prev_speed = 0

#var continuous_line_timer
var continuous_line_sound_playing = false
#var CONTINUOUS_LINE_SOUND_LENGTH = 5

#var fishy_angry = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#screen_size.x = get_viewport().get_visible_rect().size.x * get_parent().scale.x # Get width
	#screen_size.y = get_viewport().get_visible_rect().size.y * get_parent().scale.y # Get height
	
	#fish_distance_bar.min_value = fishy.get_win_distance()
	#fish_distance_bar.max_value = fishy.get_loss_distance()
	
	fish_force_bar.min_value = fishy.FISH_FORCE_MIN
	fish_force_bar.max_value = fishy.FISH_FORCE_MAX
	
	line_width_max = line.width
	
	var overworld_cam_node = get_parent().get_parent().get_parent()
#	self.connect("display_fish", overworld_cam_node, "_display_fish")
	
	#continuous_line_timer = Timer.new()
	#add_child(continuous_line_timer)
	#continuous_line_timer.connect("timeout",self,"on_continuous_line_sound_end")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_line()
	
	#fish_distance_bar.set_value(fishy.get_fish_distance())
	fish_force_bar.set_value(fishy.fish_force)
	#print(fish_distance_bar.max_value)
	#fish_tension_bar.set_value(fishy.fish_tension)
	
	if fishy.reel_state:
		fishy.fish_tension += fishy.fish_force * delta
		#fish_tension_bar.set_value(fishy.fish_tension)
		#print(fishy.fish_tension)
	if fishy.fish_tension >= FISH_TENSION_MAX || fishy.fish_escaped:
		lose_fish_game()
	elif fishy.fish_caught:
		win_fish_game()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("reel_in"):
		fish_prev_direction = fishy.fish_direction
		fish_prev_speed = fishy.fish_speed
	
	if Input.is_action_pressed("reel_in"):
		#if fishy.reel_state:
		#	fishy.fish_direction = (fishy.position.direction_to(line.points[0] + line.position)).normalized()
		#	fishy.fish_speed = DRAG_SPEED
		#	#print(line.points[0] + line.global_position)
		#	#print("reeling in")
		#else:
		#	fish_prev_direction = fishy.fish_direction
		#	fish_prev_speed = fishy.fish_speed
		#	fishy.fish_direction = (fishy.position.direction_to(line.points[0] + line.position)).normalized()
		#	fishy.fish_speed = DRAG_SPEED_SWIM
		#	fishy_angry = true
		fishy.fish_direction_target = (fishy.position.direction_to(line.points[0] + line.position)).normalized()
		fishy.fish_speed = fishy.DRAG_SPEED_MULT * (fishy.fish_force/fishy.FISH_FORCE_BASE) / fishy.fish_difficulty
		fishy.reel_state = true
		
		if !continuous_line_sound_playing:
			continuous_line_sound_playing = true
			SoundFx.play_sound("line_continuous")
			#continuous_line_timer.set_wait_time(CONTINUOUS_LINE_SOUND_LENGTH)
			#continuous_line_timer.start()
			
	if Input.is_action_just_released("reel_in"):
		fishy.reel_state = false
		#if fishy.reel_state:
		#	fishy.fish_speed = 0
		#	#print("stop reeling in")
		#else:
		#	fishy.fish_direction = fish_prev_direction
		#	fishy.fish_speed = fish_prev_speed
		fishy.fish_direction = fish_prev_direction
		fishy.fish_speed = fish_prev_speed
		
		continuous_line_sound_playing = false
		SoundFx.stop_sound("line_continuous")

#func on_continuous_line_sound_end():
#	continuous_line_sound_playing = false

func set_reel_scene_data(fish_type, fish_weight):
	fishy.set_fish_data(fish_type, fish_weight)
	
func update_line():
	line.points[1] = fishy.position + fishy.hook_offset.rotated(fishy.fish_direction.angle()) - line.position
	
	line.width = (FISH_TENSION_MAX-fishy.fish_tension)/FISH_TENSION_MAX * line_width_max
	line.default_color = Color(0.5+fishy.fish_tension/FISH_TENSION_MAX, 0.5, 0.5)

func lose_fish_game():
	print("REEL GAME LOST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	
	if (continuous_line_sound_playing):
		continuous_line_sound_playing = false
		SoundFx.stop_sound("line_continuous")
	
#	emit_signal("display_fish")
	#self.connect("reel_game_over", get_parent().get_parent().get_parent(), "_display_fish") #commented this out, was this supposed to be here?
	emit_signal("reel_game_over", false, fishy.get_fish_type(), fishy.get_fish_weight())
	
func win_fish_game():
	print("REEL GAME WON!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	
	if (continuous_line_sound_playing):
		continuous_line_sound_playing = false
		SoundFx.stop_sound("line_continuous")
	
#	emit_signal("display_fish")
	emit_signal("reel_game_over", true, fishy.get_fish_type(), fishy.get_fish_weight())
