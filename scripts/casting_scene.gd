extends Node

var slingshot_scene = preload("res://scenes/slingshot_scene.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	slingshot_scene.scale = Vector2(0.3, 0.3) #scale should be set before slingshot_scene runs _ready() so projectile is scale properly
	add_child(slingshot_scene)
	
	slingshot_scene.position = slingshot_scene.position + slingshot_scene.get_node("slingshot").position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#slingshot.global_position = boat.position
