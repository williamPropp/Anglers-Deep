extends Node

# The path of our saved data.
var path = "res://data/save.json"
var data = { }
#var default_inventory = {
#	"Fish" : {},
#	"Items" : {},
#	"Equipment" : {
#		"Normal Hook" : {
#			"Name": "Normal Hook",
#			"Item Components": ["N/A", "N/A"],
#			"Item Description": "Allows the Fishing of lower-tier fish",
#			"Equipped" : true
#		}
#	}
#}
var default_inventory = {
	"Fish" : {},
	"Items" : {},
	"Equipment" : {
		"Normal Hook" : {
			"Name": "Normal Hook",
			"Item Components": ["N/A", "N/A"],
			"Item Description": "Allows the Fishing of lower-tier fish",
			"Equipped" : true
		}
	}
}

const GlobalManager = preload("global.gd") # Relative path
onready var global = GlobalManager.new()

#func resetData():
#	# Reset to defaults if path doesn't exist
#	data = Global.inventory.duplicate(true)
#
#	Global.edit_JSON(Global.FISH_JSON_PATH, "all", "Have Caught", false)
#	print("reset game data")

# load game function
func loadGame():
	pass
#	var file = File.new()
#
#	if not file.file_exists(path):
#		resetData()
#		return
#
#	file.open(path, file.READ)
#	var text = file.get_as_text()
#	data = parse_json(text)
#
#	file.close()

# save game function
func saveGame():
	pass
#	var file
#
#	file = File.new()
#	file.open(path, File.WRITE)
#	file.store_line(to_json(global.inventory))
#
#	file.close()


# OPTIONAL: for buttons for save/load
func updateText():
	find_node("DataText").text = JSON.print(global.inventory)
	
func _on_SaveButton_pressed():
	saveGame()


func _on_LoadButton_pressed():
	loadGame()
	updateText()
