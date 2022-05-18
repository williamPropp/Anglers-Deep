extends Button

export var inventory_type = ""
export(bool) var start_focused = false
var inventory_array = Global.inventory

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"_select_button")

func _shift_focus():
	grab_focus()

func _select_button():
	grab_focus()
	#update inventory_tiles and update item_display
	get_parent().update_inventory_tiles(inventory_type)
	get_node("../inv_tile_button1").update_item_display()
