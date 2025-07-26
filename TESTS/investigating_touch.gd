extends Node2D

@onready var dot_1: Area2D = $Dot1
@onready var dot_2: Area2D = $Dot2
@onready var dot_3: Area2D = $Dot3
@onready var dot_4: Area2D = $Dot4
@onready var dot_5: Area2D = $Dot5

@onready var dots_array = [dot_1, dot_2, dot_3, dot_4, dot_5]

@onready var dot_line_2d: Line2D = $DotLine2D

@onready var word_label: Label = $WordLabel

var current_dot: Area2D
var last_dot: Area2D

func _ready() -> void:
	for dt in dots_array:
		dt.input_event.connect(on_input_event.bind(dt))


func _process(delta: float) -> void:
	#word_label.text = "Screen Touch: %s" % [screen_touch.pressed]
	pass


func _input(event: InputEvent) -> void:
	var screen_touch = event as InputEventScreenTouch
	if screen_touch:
		process_touch(screen_touch)
		
	#var screen_drag = event as InputEventScreenDrag
	#if screen_drag:
		#process_drag(screen_drag)


#func process_drag(screen_drag: InputEventScreenDrag):
	#word_label.text = "Screen Drag Pos\n%s" % [screen_drag.position]
	#print(screen_drag)


func process_touch(screen_touch: InputEventScreenTouch):
	# when we release the screen we also invoke the mouse exit
	if screen_touch.pressed == false:
		for dt in dots_array:
			dot_deactivate(dt)
		print('All deactivated!')


func on_input_event(viewport: Node, event: InputEvent, shape_idx: int, dot: Area2D):
	if event is InputEventScreenTouch:
		print("Input Event -> Viewport: %s - Event: %s - Shape Index: %s - Dot: %s" % [viewport, event, shape_idx, dot])
		if event.pressed:
			dot_activate(dot)
		elif not event.pressed:
			dot_deactivate(dot)

func dot_activate(dot: Area2D):
	dot.get_node('Sprite2D').modulate = Color.ORANGE_RED


func dot_deactivate(dot: Area2D):
	dot.get_node('Sprite2D').modulate = Color.DEEP_SKY_BLUE
	dot = null
