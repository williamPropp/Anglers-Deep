extends TextureButton

onready var quantity_label = get_node("item_quantity")
onready var item_sprite = get_node("item_sprite")
var inventory_array = Global.inventory
var empty = true

export(bool) var start_focused = false
var item_name = "Empty"
var item_sprite_path = "res://textures/unknown_fish.png"
var item_description = "Alas, you have not a single fish"
var item_biological_notes = "A lack of fish, does not a biological description make"

func _ready():		
	if(start_focused && empty):
		empty = false
		update_item_display()
		empty = true
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"update_item_display")

func _shift_focus():
	grab_focus()

func update_item_display():
	#change the current item_display to the corresponding name, texture, and description text
	if(!empty):
		get_node("../item_desc_bg/item_name").bbcode_text = "[center]" + item_name
		get_node("../item_desc_bg/item_sprite").texture = load(item_sprite_path)
		get_node("../item_desc_bg/flavor_text").text = item_description
		grab_focus()

func make_empty():
	item_sprite.visible = false
	quantity_label.visible = false
	empty = true

func fill_tile(quantity, img_path):
	change_quantity(quantity)
	change_sprite(img_path)
	item_sprite.visible = true
	quantity_label.visible = true
	empty = false

func change_quantity(new_quantity):
	quantity_label.text = str(new_quantity)
	item_sprite.visible = true
	quantity_label.visible = true
	empty = false

func change_sprite(img_path):
	item_sprite.texture = load(img_path)
	item_sprite.visible = true
	quantity_label.visible = true
	empty = false
