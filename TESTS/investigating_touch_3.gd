extends Node2D

@onready var dot_1: Area2D = $Dot1
@onready var dot_2: Area2D = $Dot2
@onready var dot_3: Area2D = $Dot3
@onready var dot_4: Area2D = $Dot4
@onready var dot_5: Area2D = $Dot5

@onready var dots_array = [dot_1, dot_2, dot_3, dot_4, dot_5]

var selected_dot_array: Array

@onready var word_label: Label = $WordLabel
@onready var info_label: Label = $InfoLabel

@onready var dot_line_2d: Line2D = $DotLine2D

var touch_started: bool ## if action to select dot has started
var drag_started: bool ## to help display the line_2d

func _ready() -> void:
	for _dot: Area2D in dots_array:
		_dot.input_event.connect(on_dot_input_event.bind(_dot))


func _process(_delta: float) -> void:
	info_label.text = "Touch Started: %s" % [touch_started]


func _input(event: InputEvent) -> void:
	var screen_touch := event as InputEventScreenTouch
	if screen_touch:
		if screen_touch.pressed:
			touch_started = true
		elif not screen_touch.pressed:
			touch_started = false
			
			selected_dot_array.clear()
			dot_line_2d.clear_points()
	
	var screen_drag := event as InputEventScreenDrag
	if screen_drag:
		display_dot_line()


func on_dot_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int, dot: Area2D):
	if dot not in selected_dot_array and touch_started:
		selected_dot_array.append(dot)
		
		display_word()


func display_word():
	word_label.text = ""
	for dot in selected_dot_array:
		word_label.text += dot.get_node('Label').text
	

func display_dot_line():
	dot_line_2d.clear_points()
	
	if not selected_dot_array.is_empty():
		for dot: Area2D in selected_dot_array:
			dot_line_2d.add_point(dot.position)
		dot_line_2d.add_point(get_global_mouse_position())
