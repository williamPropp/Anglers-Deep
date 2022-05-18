extends CanvasLayer

var active_tab

func _ready():
	open_tab("res://scenes/Inventory.tscn")
	
func _unhandled_input(event):
	if(Input.is_action_just_pressed("move_rotate_left")):
		open_tab("res://scenes/Equipment.tscn")
	elif(Input.is_action_just_pressed("move_rotate_right")):
		open_tab("res://scenes/Inventory.tscn")
	
func open_tab(path_of_scene):
	if(active_tab):
		active_tab.queue_free()
	if(path_of_scene != ""):
		var selected_tab = load(path_of_scene)
		var new_scene_instance = selected_tab.instance()
#		new_scene_instance.scale = Vector2(0.8, 0.8)
#		new_scene_instance.position = Vector2(220, 130)
		add_child(new_scene_instance)
		active_tab = new_scene_instance
#		Global.instance_child_scene(active_tab, false)
#		Global.instance_child_scene(path_of_scene, true)
#		active_tab = Global.child_scene_instance

#func open_tab(path_of_scene):
#	if(active_tab != null):
#		active_tab.queue_free()
#	if(path_of_scene != ""):
##		Global._change_scene(Global._get_current_scene_path(),path_of_scene)
#		var selected_tab = load(path_of_scene)
#		var new_scene_instance = selected_tab.instance()
#		new_scene_instance.scale = Vector2(0.8, 0.8)
#		new_scene_instance.position = Vector2(220, 130)
#		add_child(new_scene_instance)
#		active_tab = new_scene_instance


