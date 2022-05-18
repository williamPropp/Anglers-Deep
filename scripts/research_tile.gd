extends TextureButton

onready var name_label = get_node("item_name_label")
onready var item_sprite = get_node("item_sprite")

onready var item_desc_node = get_parent().get_parent().get_parent().get_node("item_desc_bg")
onready var display_name_label = item_desc_node.get_node("item_name")
onready var display_sprite = item_desc_node.get_node("item_sprite")
onready var display_description_text = item_desc_node.get_node("flavor_text")

var unknown_fish_name = "???"
var unknown_fish_sprite_path = "res://textures/unknown_fish.png"
var unknown_fish_description = "This fish has yet to be discovered"

var fish_name = ""
var fish_sprite_path = ""
var fish_description = ""

export(bool) var start_focused = false

func _ready():		
	if(start_focused):
		var fish_key = Global.fish_dictionary.keys()[0]
		if(Global.fish_dictionary[fish_key]["Have Caught"] == false):
			make_empty()
		else:
			fill_tile(Global.fish_dictionary[fish_key]["Name"], Global.fish_dictionary[fish_key]["Location"],Global.fish_dictionary[fish_key]["Metaphysical Notes"])
		update_item_display()
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"update_item_display")

func _shift_focus():
	grab_focus()

func update_item_display():
	display_name_label.bbcode_text = "[center]" + fish_name
	display_sprite.texture = load(fish_sprite_path)
	display_description_text.text = fish_description
	
func make_empty():
	fish_name = unknown_fish_name
	fish_sprite_path = unknown_fish_sprite_path
	fish_description = unknown_fish_description
	
	name_label.text = fish_name
	item_sprite.texture = load(fish_sprite_path)

func fill_tile(name, img_path, description):
	change_name(name)
	change_sprite(img_path)
	change_description(description)

func change_name(new_name):
	name_label.text = new_name
	fish_name = new_name

func change_sprite(img_path):
	item_sprite.texture = load(img_path)
	fish_sprite_path = img_path
	
func change_description(new_description):
	fish_description = new_description
