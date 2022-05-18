extends TextureButton

export var ref_path = ""
export(bool) var start_focused = false
var prev_scene = "prev_scene"

# for debug
const SaveManager = preload("autosave.gd") # Relative path
onready var autosave = SaveManager.new()

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"_select_button")

func _shift_focus():
	grab_focus()

func _select_button():
	if(ref_path == Global.overworld_path):
		Global.current_scene_state = Global.scene_state.overworld_state
		Global.instance_child_scene(Global.pause_menu_path, false)
	
	elif(ref_path == Global.main_menu_path):
		get_parent().queue_free()
#		Global.pause_toggle_overworld("unpause")
		print(get_tree().paused)
		Global.change_scene(Global.main_menu_path)
	
	else:
		Global.instance_child_scene(Global.pause_menu_path, false)
		Global.current_scene_state = Global.scene_state.in_game_settings_menu_state
		Global.instance_child_scene(Global.in_game_settings_menu_path, true)
#	delete this debug later!!!
#	saveGame()	
#	if(ref_path == prev_scene):
#		Global._change_scene(Global._get_current_scene_path(),Global.prev_scene_path)
#	elif(ref_path != ""):
#		Global.change_scene(ref_path)
#	else:
#		get_tree().quit()
