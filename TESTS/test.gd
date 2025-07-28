#@tool
extends Control

var GAME_SETTINGS: Resource = preload("res://Resources/GameSettings.tres")

@onready var dot_hub: Node2D = $MiddlePart/WordCircleTextureRect/DotHub
@onready var word_circle_texture_rect: TextureRect = $MiddlePart/WordCircleTextureRect
@onready var dot_line_2d: Line2D = $MiddlePart/WordCircleTextureRect/DotHub/DotLine2D

const DOT = preload("res://dot/dot.tscn")

@export var number_of_dots: int = 6
var min_word_circle_pos: float

var dot_wall_offset: int = 20

func _ready() -> void:
	centering_dot_hub()
	place_dots()


#func _process(_delta):
	#info_label.text = "Touch %s\nCurr Dot: %s\nPrev Dot: %s\nFormed Word: %s\nTries: %s\nSelected Dots: %s" % [
		#count, 
		#GAME_SETTINGS.current_dot, 
		#GAME_SETTINGS.previous_dot,
		#GAME_SETTINGS.formed_word,
		#GAME_SETTINGS.tries,
		#GAME_SETTINGS.selected_dots.size(),
		#]
	#info_label_2.text = "dothub Gpos: %s\ndothub pos: %s\n" % [
		#dot_hub.global_position,
		#dot_hub.position,
	#]


func _unhandled_input(event: InputEvent) -> void:
	var screen_touch = event as InputEventScreenTouch
	if screen_touch:
		touch_process(event)
	
	var screen_drag = event as InputEventScreenDrag
	if screen_drag:
		drag_process(event)


var count: int
func touch_process(screen_touch: InputEventScreenTouch):
	count += 1
	
	# when we let go of the screen we process the formed word
	if not screen_touch.pressed:
		GAME_SETTINGS.process_formed_word()
		
		dot_line_2d.clear_points()


func drag_process(_screen_touch: InputEventScreenDrag):
	#info_label_2.text = "GPos: %s\nPos: %s" % [get_global_mouse_position(), get_local_mouse_position()]
	if not GAME_SETTINGS.selected_dots.is_empty():
		add_line()


func add_line():
	dot_line_2d.clear_points()
	
	for dot in GAME_SETTINGS.selected_dots:
		dot_line_2d.add_point(dot.global_position - dot_hub.global_position)
	
	dot_line_2d.add_point(get_global_mouse_position() - dot_hub.global_position)



func centering_dot_hub():
	if word_circle_texture_rect.size.x > word_circle_texture_rect.size.y:
		min_word_circle_pos = word_circle_texture_rect.size.y
	else:
		min_word_circle_pos = word_circle_texture_rect.size.x
	dot_hub.position = Vector2.ONE * min_word_circle_pos * 0.5


func place_dots():
	for index in number_of_dots:
		var new_node = Node2D.new()
		dot_hub.add_child(new_node)
		new_node.name = "dot_node_%s" % [index]
		
		var dot = DOT.instantiate()
		new_node.add_child(dot)
		
		dot.position = Vector2.UP * Vector2.ONE * min_word_circle_pos * 0.5 - (Vector2.UP * dot.dot_size + Vector2.UP * dot_wall_offset)
		
		var dot_rotation = index * TAU / number_of_dots
		new_node.rotation = dot_rotation
		dot.rotation = -dot_rotation
		
