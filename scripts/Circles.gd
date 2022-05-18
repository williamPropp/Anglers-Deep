extends Control

onready var fishy = get_node("../fish")
onready var line = get_node("../line")
onready var circle_large = get_node("circle_large")
onready var circle_small = get_node("circle_small")

var circle_center_position
var circle_large_radius
var circle_small_radius
var circle_large_multiplier
var circle_small_multiplier

# Called when the node enters the scene tree for the first time.
func _ready():
	#get the circle center
	circle_center_position = line.points[0]
	
	#get the size of circle sprites
	var circle_large_rect = circle_large.get_rect().abs()
	circle_large_radius = (circle_large_rect.end.x - circle_large_rect.position.x)/2 * get_parent().scale.x
	
	var circle_small_rect = circle_large.get_rect().abs()
	circle_small_radius = (circle_large_rect.end.x - circle_large_rect.position.x)/2 * get_parent().scale.x
	
	#get the size multiplier for the circles
	circle_large_multiplier = (fishy.get_loss_distance()/circle_large_radius)
	circle_small_multiplier = (fishy.get_win_distance()/circle_small_radius)
	#circle_large_multiple = fishy.LOSS_DISTANCE/circle_large_radius
	#circle_small_multiple = fishy.WIN_DISTANCE/circle_small_radius
	
	#resize the circles
	print(circle_large_multiplier)
	circle_large.set_scale(circle_large_multiplier * circle_large.get_scale())
	circle_small.set_scale(circle_small_multiplier * circle_small.get_scale()*4) #why?! whyyyy?!! why do i need to multiply by 4? what is this?????????
	
	#center the circles
	circle_large.set_position(circle_center_position)
	circle_small.set_position(circle_center_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	circle_large.rotate(0.2 * delta)
	circle_small.rotate(0.2 * delta)
	#print(circle_small.get_scale()*circle_small_radius / get_parent().scale.x)
