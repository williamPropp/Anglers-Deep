extends Button

export var ref_path = ""
export(bool) var start_focused = false
#var selected_tab
var journal_manager

func _ready():
	journal_manager = get_parent().get_parent()
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"_select_button")

func _shift_focus():
	grab_focus()

func _select_button():
#	if(ref_path == "prev_scene"):
#		Global._change_scene(Global._get_current_scene_path(),Global.prev_scene_path)
	if(ref_path != ""):
		journal_manager.open_tab(ref_path)
