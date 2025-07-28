extends Control

@onready var formed_word_label: Label = $MiddlePart/FormedWordControl/FormedWordLabel

@onready var word_circle_texture_rect: TextureRect = $MiddlePart/WordCircleTextureRect
@onready var dot_hub: Node2D = $MiddlePart/WordCircleTextureRect/DotHub

@onready var dot_line_2d: Line2D = $MiddlePart/WordCircleTextureRect/DotHub/DotLine2D

@onready var found_words_grid_container: GridContainer = $TopPart/FoundWordsGridContainer

const DOT = preload("res://dot/dot.tscn")
var selected_dot_array: Array[Dot]

# We'll figure out a way to load this main scene with the actual letters to form words from already set
# we also need a way to save progress

var actual_letters = "NLASEP"
@export var number_of_dots: int = 6

var min_word_circle_position: float

var dot_wall_offset: int = 20 ## dot's distance in pixels from the Word Circle wall

var touch_started: bool ## if action to select dot has started
var drag_started: bool ## to help display the line_2d


func _ready() -> void:
	centering_dot_hub()
	place_dots()


func _input(event: InputEvent) -> void:
	var screen_touch := event as InputEventScreenTouch
	if screen_touch:
		if screen_touch.pressed:
			touch_started = true
		elif not screen_touch.pressed:
			touch_started = false
			
			for _dot: Dot in selected_dot_array:
				_dot.dehighlight_dot()
			selected_dot_array.clear()
			dot_line_2d.clear_points()
			
	
	var screen_drag := event as InputEventScreenDrag
	if screen_drag:
		display_dot_line()


func centering_dot_hub():
	if word_circle_texture_rect.size.x > word_circle_texture_rect.size.y:
		min_word_circle_position = word_circle_texture_rect.size.y
	else:
		min_word_circle_position = word_circle_texture_rect.size.x
	dot_hub.position = Vector2.ONE * min_word_circle_position * 0.5


func place_dots():
	for index in number_of_dots:
		var new_node = Node2D.new()
		dot_hub.add_child(new_node)
		new_node.name = "dot_node_%s" % [index]
		
		var dot: Dot = DOT.instantiate()
		dot.name = "DOT_%s" % [index]
		dot.dot_value = actual_letters[index]
		new_node.add_child(dot)
		
		dot.input_event.connect(on_dot_input_event.bind(dot))
		
		dot.position = Vector2.UP * Vector2.ONE * min_word_circle_position * 0.5 - (Vector2.UP * dot.dot_size + Vector2.UP * dot_wall_offset)
		
		var dot_rotation = index * TAU / number_of_dots
		new_node.rotation = dot_rotation
		dot.rotation = -dot_rotation


func on_dot_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int, dot: Dot):
	if dot not in selected_dot_array and touch_started:
		selected_dot_array.append(dot)
		#print("Selected dots: %s - %s" % [selected_dot_array.size(), selected_dot_array])
		
		display_word()


func display_word():
	formed_word_label.text = ""
	for dot in selected_dot_array:
		dot.highlight_dot()
		formed_word_label.text += dot.dot_label.text


func display_dot_line():
	dot_line_2d.clear_points()
	
	if not selected_dot_array.is_empty():
		for dot: Dot in selected_dot_array:
			dot_line_2d.add_point(dot.global_position - dot_hub.global_position)
		dot_line_2d.add_point(get_global_mouse_position() - dot_hub.global_position)
