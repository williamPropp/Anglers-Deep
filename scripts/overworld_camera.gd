extends Camera2D

onready var boat = get_node("../boat")

var projectile_speed

var projectile_last_position
var boat_last_position
var camera_last_position

# Called when the node enters the scene tree for the first time.
func _ready():
	position = boat.position
	
	camera_last_position = position
	boat_last_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta): #moved this code from process to physics process to prevent jitter, should be less noticeable on higher-res textures anyway
	position = camera_last_position + delta*(boat.position - camera_last_position)*3
	
	camera_last_position = position
	boat_last_position = boat.position
