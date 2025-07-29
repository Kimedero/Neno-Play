@tool
extends Control

@onready var formed_word_label: Label = $BottomPart/FormedWordControl/FormedWordLabel

@onready var word_circle_texture_rect: TextureRect = $BottomPart/WordCircleTextureRect
@onready var dot_hub: Node2D = $BottomPart/WordCircleTextureRect/DotHub

@onready var dot_line_2d: Line2D = $BottomPart/WordCircleTextureRect/DotHub/DotLine2D

@onready var found_words_grid_container: GridContainer = $MiddlePart/FoundWordsGridContainer
@onready var word_grid_container: GridContainer = $MiddlePart/WordGridContainer

const DOT = preload("res://dot/dot.tscn")
var selected_dot_array: Array[Dot]

# We'll figure out a way to load this main scene with the actual letters to form words from already set
# we also need a way to save progress

# THE GAME MAKERS
var actual_letters = "NLASEP"
@export var number_of_dots: int = 6
var word_columns: int = 2
var words_to_find_array: Array = ['PLAN', 'LANE', 'PLEA', 'LANES', 'LEAPS', 'PLANE', 'PLANES',  'PLEAS']
var found_words_array: Array
var found_bonus_words_array: Array

## an array full of words
var all_words: Array

const WORD_PANEL = preload("res://word/word_panel.tscn")
var word_panel_dict: Dictionary

@onready var bonus_word_rich_text_label: RichTextLabel = $BonusWordRichTextLabel

var min_word_circle_position: float

var dot_wall_offset: int = 20 ## dot's distance in pixels from the Word Circle wall

var touch_started: bool ## if action to select dot has started
var drag_started: bool ## to help display the line_2d

var dictionary_file = "res://Assets/dictionary.txt"
var kamusi_file = "res://Assets/Kamusi/kamusi_words.txt"

func _ready() -> void:
	formed_word_label.resized.connect(show_formed_word_label_contents)
	show_formed_word_label_contents()
	
	all_words = parse_dictionary()
	
	format_word_grid()
	
	handling_notches()
	
	centering_dot_hub()
	place_dots()
	
	bonus_word_rich_text_label.scale = Vector2.ZERO


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
			
			certify_formed_word()
	
	var screen_drag := event as InputEventScreenDrag
	if screen_drag:
		display_dot_line()


func centering_dot_hub():
	min_word_circle_position = min(word_circle_texture_rect.size.x, word_circle_texture_rect.size.y)
	#dot_hub.position = Vector2.ONE * min_word_circle_position * 0.5
	dot_hub.position = word_circle_texture_rect.size * 0.5


func place_dots():
	for index in number_of_dots:
		var new_node = Node2D.new()
		dot_hub.add_child(new_node)
		new_node.name = "dot_node_%s" % [index]
		
		var dot: Dot = DOT.instantiate()
		dot.name = "DOT_%s" % [index]
		dot.dot_value = actual_letters[index].to_upper()
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


func certify_formed_word():
	var formed_word = formed_word_label.text
	if formed_word.length() > 1:
		#for _word: Control in word_grid_container.get_children():
			if formed_word in word_panel_dict.keys():
			#if formed_word == _word.word_to_display:
				word_panel_dict[formed_word].animate_found_word()
				#_word.animate_found_word()
				found_words_array.append(formed_word)
				
				if found_words_array.size() == words_to_find_array.size():
					print("Congratulations! You finished the game!")
			else:
				look_up_word_in_dictionary(formed_word)
		
		#print("You formed: %s" % [formed_word])
	formed_word_label.text = ""


func show_formed_word_label_contents():
	if formed_word_label.text.length() == 0:
		formed_word_label.modulate.a = 0
	else:
		formed_word_label.modulate.a = 1


func handling_notches():
	var os_name := OS.get_name()
	print("OS Name: %s - Model Name: %s" % [os_name, OS.get_model_name()])
	if os_name == "Android" || os_name ==  "iOS":
		# this indicates the area below the notch's dimensions
		var safe_area: Rect2i  = DisplayServer.get_display_safe_area()
		#print("Display Safe Area: %s" % [safe_area])
		# this basically indicates where the notch is, for Android phones
		#var display_cutouts: Array[Rect2] = DisplayServer.get_display_cutouts()
		#print("Display cutouts: %s - End: %s" % [display_cutouts, display_cutouts[0].end])
		#var window_size = get_window().size
		#print("Window Size: ", window_size)
		
		set_anchors_preset(Control.PRESET_FULL_RECT)
		#anchor_left = 0
		#anchor_top = 0
		#anchor_right = 1
		#anchor_bottom = 1
		
		offset_left = 0
		offset_top = safe_area.position.y * 0.5
		offset_right = 0
		offset_bottom = 0 # -safe_area.position.y * 0.5


func format_word_grid():
	# clearing everything
	for _control: Control in word_grid_container.get_children():
		_control.queue_free()
	
	word_grid_container.columns = word_columns
	for word_to_find: String in words_to_find_array:
		#print("Word: %s" % [_word])
		var new_word_panel = WORD_PANEL.instantiate()
		new_word_panel.word_to_display = word_to_find
		word_grid_container.add_child(new_word_panel)
		
		word_panel_dict[word_to_find] = new_word_panel


func look_up_word_in_dictionary(formed_word: String):
	if all_words.has(formed_word.to_upper()):
		if not found_bonus_words_array.has(formed_word):
			display_bonus_word_find(formed_word)
			print("FOUND WORD: %s" % [formed_word])
		else:
			print("ALREADY FOUND WORD: %s" % [formed_word])
			
		found_bonus_words_array.append(formed_word.to_upper())
		


func parse_dictionary() -> Array:
	var word_arr: Array = []
	var dict_file := FileAccess.open(dictionary_file, FileAccess.READ)
	while not dict_file.eof_reached():
		var line: String = dict_file.get_line()
		if "'" not in line and line.length() > 1:
			#print("Current word: %s" % [line])
			word_arr.append(line.to_upper())
	#print("FINAL WORD: ", word_arr[word_arr.size() - 1])
	#print("FINAL WORD: %s - %s" % [word_arr[word_arr.size() - 1], word_arr.size()])
	return word_arr


func display_bonus_word_find(bonus_word: String):
	bonus_word_rich_text_label.text = "[center][u]Bonus Word Found![/u]\n[font_size=40][color=green]%s[/color][/font_size][/center]" % [bonus_word]
	
	bonus_word_rich_text_label.pivot_offset = bonus_word_rich_text_label.size * 0.5
	
	var bonus_tween := create_tween()
	bonus_tween.tween_property(bonus_word_rich_text_label, "scale", Vector2.ONE, 0.4)
	bonus_tween.tween_property(bonus_word_rich_text_label, "scale", Vector2.ONE, 2.5)
	bonus_tween.tween_property(bonus_word_rich_text_label, "scale", Vector2.ZERO, 0.1)
	bonus_tween.set_ease(Tween.EASE_IN_OUT)
	bonus_tween.set_trans(Tween.TRANS_SPRING)
	
