extends Button

export(bool) var start_focused = false
var inventory_array = Global.inventory
onready var equipment_manager = get_parent().get_parent()
onready var item_name_label = get_parent().get_node("item_name")

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"_select_button")

func _shift_focus():
	grab_focus()
#	print(selected_tile_item_name)
#	self.visible = false
#	self.disabled = true
#	if(normal == theme.normal)
#	grab_focus()

func _select_button():
	grab_focus()
	equipment_manager.equip_item(item_name_label.text)
	
