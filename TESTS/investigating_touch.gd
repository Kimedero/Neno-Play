extends Node2D

@onready var dot_1: Area2D = $Dot1
@onready var dot_2: Area2D = $Dot2
@onready var dot_3: Area2D = $Dot3
@onready var dot_4: Area2D = $Dot4
@onready var dot_5: Area2D = $Dot5

@onready var dots_array = [dot_1, dot_2, dot_3, dot_4, dot_5]

@onready var dot_line_2d: Line2D = $DotLine2D

@onready var word_label: Label = $WordLabel
@onready var word_label_2: Label = $WordLabel2


var current_dot: Area2D
var last_dot: Area2D

var selected_dots_array: Array

var drag_started: bool
var line_start_point: Vector2
var line_coordinates_array: Array

func _ready() -> void:
	for dt in dots_array:
		dt.input_event.connect(on_input_event.bind(dt))


func _process(delta: float) -> void:
	word_label_2.text = "Selected Dot Array Size: %s\nLine Coords Array: %s" % [selected_dots_array.size(), line_coordinates_array.size()]



func _input(event: InputEvent) -> void:
	var screen_touch = event as InputEventScreenTouch
	if screen_touch:
		process_touch(screen_touch)
		
	#var screen_drag = event as InputEventScreenDrag
	#if screen_drag:
		#process_drag(screen_drag)


#func process_drag(screen_drag: InputEventScreenDrag):
	##word_label.text = "Screen Drag Pos\n%s" % [screen_drag.position]
	##print(screen_drag)
	#if screen_drag:
		#drag_started = true
	##if drag_started:
		#dot_line_2d.clear_points()
		#
		##if not line_start_point == Vector2.ZERO:
		#dot_line_2d.add_point(line_start_point)
		#for point in line_coordinates_array:
			#dot_line_2d.add_point(point)
		#dot_line_2d.add_point(screen_drag.position)


func process_touch(screen_touch: InputEventScreenTouch):
	# when we release the screen we revert all sprites to default
	if screen_touch.pressed == false:
		for dt in dots_array:
			dot_deactivate(dt)
		selected_dots_array.clear()
		#print("Seleted dots array cleared!")
		line_coordinates_array.clear()
		dot_line_2d.clear_points()
		#line_start_point = Vector2.ZERO
		drag_started = false
		#print('All deactivated!')


func on_input_event(viewport: Node, event: InputEvent, shape_idx: int, dot: Area2D):
	if event is InputEventScreenTouch and event.index == 0:
		#print("Input Event -> Viewport: %s - Event: %s - Shape Index: %s - Dot: %s" % [viewport, event, shape_idx, dot])
		if event.pressed:
			if dot not in selected_dots_array:
				selected_dots_array.append(dot)
				
			dot_activate(dot)
			
			display_formed_word()
			
			line_start_point = dot.position
			drag_started = true
		elif not event.pressed:
			dot_deactivate(dot)
			
			
	elif event is InputEventScreenDrag and event.index == 0:
		if dot != last_dot and dot not in selected_dots_array:
			selected_dots_array.append(dot)
			
			display_formed_word()
			
			line_coordinates_array.append(dot.position)
			
			dot_activate(dot)
			print("Drag Event: %s" % [event])
		last_dot = dot


func dot_activate(dot: Area2D):
	dot.get_node('Sprite2D').modulate = Color.ORANGE_RED
	#word_label.text = "Activated Dot: %s" % [dot.name]


func dot_deactivate(dot: Area2D):
	dot.get_node('Sprite2D').modulate = Color.DEEP_SKY_BLUE
	#word_label.text = "Deactivated Dot: %s" % [dot.name]


func display_formed_word():
	word_label.text = ""
	for dt in selected_dots_array:
		var letter = dt.get_node('Label').text
		word_label.text += letter
		
