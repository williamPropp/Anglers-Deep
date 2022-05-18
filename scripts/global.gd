extends Node

#scenes
var main_menu_path = "res://scenes/main_menu.tscn"
var pause_menu_path = "res://scenes/pause_menu.tscn"
var settings_menu_path = "res://scenes/settings_menu.tscn"
var in_game_settings_menu_path = "res://scenes/settings_menu_in_game.tscn"
var overworld_path = "res://scenes/overworld.tscn"
var journal_path = "res://scenes/Journal.tscn"
var inventory_path = "res://scenes/Inventory.tscn"
var equipment_path = "res://scenes/Equipment.tscn"
var research_path = "res://scenes/Research.tscn"
var ritual_path = "res://scenes/Rituals.tscn"
var fish_display_path = "res://scenes/fish_display.tscn"
var current_scene_path = "res://scenes/main_menu.tscn"
var prev_scene_path
var child_scene
var journal_instance

#scene states
enum scene_state{
	main_menu_state = 0,
	overworld_state = 1,
	reel_state = 2,
	pause_menu_state = 3,
	settings_menu_state = 4,
	in_game_settings_menu_state = 5,
	journal_state = 6
}
var current_scene_state = scene_state.main_menu_state
var child_scene_instance

#settings
var master_volume
var music_volume
var sound_fx_volume
var window_width
var window_height
var isFullscreen

#data structures
var inventory = Autosave.default_inventory
var fish_dictionary
var item_dictionary
var equipment_dictionary
var region_arrays

#var FISH_JSON_PATH = "res://data/fish data.json"
var FISH_JSON_PATH = "res://data/fish_data.json"
var ITEM_JSON_PATH = "res://data/item_data.json"
var EQUIPMENT_JSON_PATH = "res://data/equipment_data.json"
var REGION_JSON_PATH = "res://data/FishRegions.json"

func _ready():
#	Autosave.loadGame()
	fish_dictionary = make_dictionary(FISH_JSON_PATH)
	item_dictionary = make_dictionary(ITEM_JSON_PATH)
	equipment_dictionary = make_dictionary(EQUIPMENT_JSON_PATH)
#	fish_dictionary = _make_fish_dictionary()
	region_arrays = _make_region_arrays()

func _unhandled_input(_event):
	match current_scene_state:
		(scene_state.main_menu_state):
#			print("main menu input")
			pass

		(scene_state.overworld_state):
			if Input.is_action_just_pressed("ui_cancel"):
				#open pause menu
				current_scene_state = scene_state.pause_menu_state
				instance_child_scene(pause_menu_path, true)

			elif Input.is_action_just_pressed("open_journal"):
				#open journal scene
				current_scene_state = scene_state.journal_state
				instance_child_scene(journal_path, true)

		(scene_state.reel_state):
			if Input.is_action_just_pressed("ui_cancel"):
				#quit out of reel minigame
				current_scene_state = scene_state.overworld_state

		(scene_state.journal_state):
			#close journal, return to overworld
			if Input.is_action_just_pressed("ui_cancel"):
				current_scene_state = scene_state.overworld_state
				instance_child_scene(journal_path, false)
			elif Input.is_action_just_pressed("open_journal"):
				current_scene_state = scene_state.overworld_state
				instance_child_scene(journal_path, false)

		(scene_state.pause_menu_state):
			if Input.is_action_pressed("ui_cancel"):
				current_scene_state = scene_state.overworld_state
				instance_child_scene(pause_menu_path, false)

		(scene_state.settings_menu_state):
			if Input.is_action_pressed("ui_cancel"):
				current_scene_state = scene_state.main_menu_state
				instance_child_scene(pause_menu_path, false)
				#unpause overworld scene
		#new
		(scene_state.in_game_settings_menu_state):
			if Input.is_action_pressed("ui_cancel"):
				current_scene_state = scene_state.pause_menu_state
				instance_child_scene(in_game_settings_menu_path, false)

func change_scene(new_scene_path):
	Autosave.saveGame()
	if(child_scene_instance): 
		child_scene_instance.queue_free()
		child_scene_instance = null
		pause_toggle_overworld("unpause")
	get_tree().change_scene(new_scene_path)
	
	match new_scene_path:
		main_menu_path:
			current_scene_state = scene_state.main_menu_state
		overworld_path:
			current_scene_state = scene_state.overworld_state
		pause_menu_path:
			current_scene_state = scene_state.pause_menu_state
		journal_path:
			current_scene_state = scene_state.journal_state

#open_or_close == true -> open pause menu, open_or_close == false -> close pause menu
func instance_child_scene(child_scene_path, open_or_close):
	if(open_or_close):
		#pause overworld
		pause_toggle_overworld("pause")
		
		#add child scene
		var child_scene = load(child_scene_path)
		child_scene_instance = child_scene.instance()
		add_child(child_scene_instance)
	else:
		#unpause overworld
		pause_toggle_overworld("unpause")
		
		#free child scene
		child_scene_instance.queue_free()
		child_scene_instance = null

func pause_toggle_overworld(mode = "toggle"):
	match mode:
		"toggle":
			get_tree().paused = !get_tree().paused
			if get_tree().paused:
				Engine.time_scale = 0.0
			else:
				Engine.time_scale = 1.0
		"pause":
			get_tree().paused = true
			Engine.time_scale = 0.0
		"unpause":
			get_tree().paused = false
			Engine.time_scale = 1.0
	
func _get_current_scene_path():
	return get_tree().current_scene.filename

#func get_item_data(inv_type, item_name, data_type):
#	if(item_name == "all"):
#		#change to use full items JSON later, rn it just uses inventory
#		return inventory.get(inv_type).keys()
#	else:
#		return inventory.get(inv_type).get(item_name).get(data_type)

#func _make_fish_dictionary():
#	var fish_json = File.new() #create a new file variable to read the fish json
#	fish_json.open(FISH_JSON_PATH, File.READ) #open the fish json set ro read mode
#	var fish_text = fish_json.get_as_text() #read the fish json as text
#	var parsed_json_dictionary = parse_json(fish_text) #parse the fish json text 
#	return parsed_json_dictionary

func make_dictionary(JSON_PATH):
	var json_file = File.new() #create a new file variable to read the json
	var json_err = json_file.open(JSON_PATH, File.READ) #open the json set to read mode
	if json_err == OK:
		var parsed_json_dictionary = parse_json(json_file.get_as_text())
		json_file.close()
		return parsed_json_dictionary
	else:
		print("parsing error")
		json_file.close()

func edit_JSON(JSON_PATH, item_key, data_type, new_data):
	#transform json to editable dictionary
	var new_dictionary = make_dictionary(JSON_PATH)
	
	#when the all option is selected, every item in the dictionary is updated to have new_data in their data_type
	if(item_key == "all"):
		for item_name in new_dictionary:
			new_dictionary[item_name][data_type] = new_data
	else:
		new_dictionary[item_key][data_type] = new_data
	
	#overwrite json with edited version
	var edited_json_file = File.new()
	edited_json_file.open(JSON_PATH, File.WRITE) #open the json set to write mode
	edited_json_file.store_string(JSON.print(new_dictionary, "	"))
	edited_json_file.close()
	
	#update respective dictionary
	match JSON_PATH:
		FISH_JSON_PATH:
			fish_dictionary = make_dictionary(JSON_PATH)
		ITEM_JSON_PATH:
			item_dictionary = make_dictionary(JSON_PATH)
		EQUIPMENT_JSON_PATH:
			equipment_dictionary = make_dictionary(JSON_PATH)
	
func _make_region_arrays():
	pass
	var region_json = File.new() #create a new file variable to read the json
	var json_err = region_json.open(REGION_JSON_PATH, File.READ) #open the json set to read mode
	if json_err == OK:
		var parsed_json_dictionary = parse_json(region_json.get_as_text())
		region_json.close()
		return parsed_json_dictionary.get("Regions")
	else:
		print("parsing error")
		region_json.close()

func _get_fish_data(fish_key):
#	return fish_dictionary.get(fish_key)
#	print(fish_dictionary)
	return fish_dictionary[fish_key]

func get_item_data(item_key):
	return item_dictionary.get(item_key)

func get_equipment_data(equipment_key):
	return equipment_dictionary.get(equipment_key)
	
func _get_region_array(region_key):
	if region_arrays != null:
		return region_arrays.get(region_key)
	else:
		return null

func _get_random_fish_from_region(region_key):
	var region_array = _get_region_array(region_key)
	if region_array != null:
		var random_index = rand_range(0, region_array.size())
		return region_array[random_index]
	return null
