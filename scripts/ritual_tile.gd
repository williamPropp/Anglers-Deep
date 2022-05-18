extends TextureButton

onready var ritual_manager = get_parent()
onready var quantity_label = get_node("item_quantity")
onready var item_sprite = get_node("item_sprite")
var inventory_array = Global.inventory

export(bool) var start_focused = false
export(bool) var product_tile = false
export(bool) var component_tile = false
var item_name
var item_quantity
var item_sprite_path
#var item1key = Global.inventory.get("items").keys()[0]
#var item_name = Global.inventory.get("items").get(item1key).get("name")
#var item_quantity = Global.inventory.get("items").get(item1key).get("quantity")
#var item_sprite_path = Global.inventory.get("items").get(item1key).get("sprite_path")

func _ready():
	if(product_tile || component_tile):
		make_empty()
		item_name = ""
		item_quantity = 0
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"_select_button")

func _shift_focus():
	grab_focus()

func _select_button():
	if(!component_tile && !product_tile && item_quantity > 0):
		ritual_manager.add_item_to_crafting(self)
	elif(component_tile && item_quantity > 0):
		ritual_manager.remove_item_from_crafting(self)
	elif(product_tile && item_quantity > 0):
		ritual_manager.craft_item()
	else:
		print("select_button else")
		#play error/deny sound effect
	
	
func make_empty():
	item_name = ""
	item_quantity = 0
	item_sprite_path = ""
	item_sprite.visible = false
	quantity_label.visible = false

func fill_tile(quantity, img_path, name = ""):
	change_quantity(quantity)
	change_sprite(img_path)
	change_name(name)
	quantity_label.visible = true
	item_sprite.visible = true

func change_quantity(new_quantity):
	item_quantity = new_quantity
	item_sprite.visible = true
	quantity_label.text = str(new_quantity)

func change_sprite(img_path):
	item_sprite_path = img_path
	quantity_label.visible = true
	item_sprite.texture = load(img_path)

func add_quantity(amount_to_add):
	item_quantity += amount_to_add
	item_sprite.visible = true
	quantity_label.text = str(item_quantity)

func change_name(new_name):
	item_name = new_name
