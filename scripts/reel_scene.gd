extends Node2D

onready var slingshot = get_node("../../../boat/cast_scene/Node2D/slingshot") #ticking time bomb
onready var boat = get_node("../../../boat")
onready var map = get_node("../../../map_node")

#var slingshot = load("res://scripts/slingshot_handle.gd")
var reel_scene = preload("res://scenes/reel_scene.tscn")
var reel_scene_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	#slingshot.connect("shadow_fish_collision", self, "_on_shadow_fish_collision")
	map.connect("shadow_fish_deleted", self, "_on_shadow_fish_collision")
	#reel_scene.connect("reel_game_over", self, "_on_reel_game_end")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var parent_rotation = get_parent().rotation
#	set_rotation(-parent_rotation)

func _on_shadow_fish_collision(fish_type, fish_weight, fish_position):
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
	
	#code to wait 1 second
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	var new_reel_scene = reel_scene.instance()
	new_reel_scene.scale = Vector2(0.4, 0.4)
	add_child(new_reel_scene)
	
	new_reel_scene.set_reel_scene_data(fish_type, fish_weight)
	
	new_reel_scene.pause_mode = PAUSE_MODE_PROCESS
	map.pause_mode = PAUSE_MODE_STOP
	get_tree().set_pause(true)
	
	reel_scene_manager = get_node("reel_scene_manager")
	reel_scene_manager.connect("reel_game_over", self, "_on_reel_game_end")

func _on_reel_game_end(game_won: bool, fish_type: String, fish_weight: int):
	reel_scene_manager.queue_free()
	
	print("is this working??")
	if game_won:
		#Display fish
		var fish_display = load(Global.fish_display_path)
		var fish_display_instance = fish_display.instance()
		fish_display_instance.scale = Vector2(0.4, 0.4)
		add_child(fish_display_instance)
		fish_display_instance.set_fish_caught_image(fish_type)
		fish_display_instance.set_fish_caught_text(fish_type)
		
		#Add fish to inventory
		var fish_inventory = Global.inventory.get("Fish")
		if(fish_inventory.has(fish_type)):
			fish_inventory[fish_type]["Quantity"] += 1
		else:
			fish_inventory[fish_type] = {}
			fish_inventory[fish_type]["Name"] = fish_type
			fish_inventory[fish_type]["Quantity"] = 1
		
		#update Has Caught bool in fish_json
		Global.edit_JSON(Global.FISH_JSON_PATH, fish_type, "Have Caught", true)
		print(Global.fish_dictionary[fish_type])
		
	map.pause_mode = PAUSE_MODE_INHERIT
	get_tree().set_pause(false)
