extends Node2D

onready var fish_caught_sprite = get_node("fish_sprite")
onready var fish_caught_text = get_node("you_caught_fish_text")

func _ready():

	var timer = get_node("Timer")
	timer.set_wait_time( 1.75 )
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start()

func _on_Timer_timeout():
	self.queue_free()
	
func set_fish_caught_image(fish_type):
	var fish_image_path = Global._get_fish_data(fish_type).get("Location")
	fish_caught_sprite.texture = load(fish_image_path)
#	var new_texture = ImageTexture.new()
#	var new_image = Image.new()
#	new_image.load(fish_image_path)
#	new_texture.create_from_image(new_image)
#	print(fish_caught_sprite)
#	fish_caught_sprite.set_texture(new_texture)

func set_fish_caught_text(fish_type):
	var fish_name = Global._get_fish_data(fish_type).get("Name")
	fish_caught_text.bbcode_text = ("[center]You caught a " + fish_name + " !")
