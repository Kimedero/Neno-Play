extends Node2D

@onready var dot_1: Area2D = $Dot1
@onready var dot_2: Area2D = $Dot2
@onready var dot_3: Area2D = $Dot3
@onready var dot_4: Area2D = $Dot4
@onready var dot_5: Area2D = $Dot5

@onready var dots_array: Array = [dot_1, dot_2, dot_3, dot_4, dot_5]

@onready var word_label: Label = $WordLabel
@onready var info_label: Label = $InfoLabel

var dot_touch_started: bool
var dot_drag_started: bool
signal dot_selected

var selected_dots_array: Array

func _ready() -> void:
	for _dot: Area2D in dots_array:
		_dot.input_event.connect(on_dot_input_event.bind(_dot))
	dot_selected.connect(on_dot_selected)


func _process(_delta: float) -> void:
	info_label.text = "Dot Touch Started: %s" % [dot_touch_started]


func _input(event: InputEvent) -> void:
	var screen_touch = event as InputEventScreenTouch
	if screen_touch:
		if not screen_touch.pressed:
			dot_touch_started = false
			selected_dots_array.clear()
		#word_label.text = "Screen Touch: %s" % [screen_touch.pressed]


func on_dot_input_event(_viewport: Node, event: InputEvent, _shape_idx: int, dot: Area2D):
	if event is InputEventScreenTouch:
		print("Dot: %s - Event: %s" % [dot.name, event])
		if event.pressed:
			dot_touch_started = true
			emit_signal("dot_selected", dot)
		elif not event.pressed:
			dot_touch_started = false
		 
	if event is InputEventScreenDrag:
		emit_signal("dot_selected", dot)
		#print("Screen not touched, anymore! We dragging")


func on_dot_selected(dot: Area2D):
	if not dot in selected_dots_array:
		selected_dots_array.append(dot)
		print("%s selected!" % [dot.name])
		display_selected_word()


func display_selected_word():
	word_label.text = ""
	for _dot in selected_dots_array:
		word_label.text += _dot.get_node("Label").text
