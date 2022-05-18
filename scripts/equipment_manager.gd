extends CanvasLayer

var inventory_array = Global.inventory

var inventory_tiles_array = []
var num_tiles = 6
var equipped_item = "Normal Hook"

# Called when the node enters the scene tree for the first time.
func _ready():
	#add all inv_tile_button nodes to the inventory_tiles_array
	for i in num_tiles:
		var tile_name = "inv_tile_button" + str(i+1)
		var tile_to_add = get_node(tile_name)
		inventory_tiles_array.append(tile_to_add)
	
	find_equipped_item()
	update_equipment_tiles()
	update_equipped_item_display()
	get_node("inv_tile_button1").update_item_display()

func update_equipment_tiles():
	for i in len(inventory_tiles_array):
		#get array of items respective to the inv_type
		var item_array = Global.inventory.get("Equipment").keys()
		
		#for each inventory element, get the name, sprite, description, and quantity
		if(i < len(item_array)):
			#get name, sprite + item_description data from inventory
			var item_key = item_array[i]
			var equipment_data = Global.get_equipment_data(item_key)
			var item_name = equipment_data["Name"]
			var item_sprite_path = equipment_data["Location"]
			var item_description = equipment_data["Item Description"]
			
			#update tile's display
			inventory_tiles_array[i].fill_tile(item_sprite_path)
			
			#update tile's data
			inventory_tiles_array[i].item_name = item_name
			inventory_tiles_array[i].item_sprite_path = item_sprite_path
			inventory_tiles_array[i].item_description = item_description
		
		#once there's no more inventory elements, make the rest of the tiles empty
		else:
			inventory_tiles_array[i].make_empty()

func equip_item(item_to_equip):
	Global.inventory["Equipment"].get(equipped_item)["Equipped"] = false
	Global.inventory["Equipment"].get(item_to_equip)["Equipped"] = true
	equipped_item = item_to_equip
	update_equipped_item_display()

func update_equipped_item_display():
	get_node("inv_tile_button7/item_sprite").texture = load(Global.get_equipment_data(equipped_item).get("Location"))

func find_equipped_item():
	var equipment_keys = Global.inventory["Equipment"].keys()
	for i in len(equipment_keys):
		if(Global.inventory["Equipment"][equipment_keys[i]]["Equipped"]):
			equipped_item = Global.inventory["Equipment"][equipment_keys[i]]["Name"]
