extends Control

const GAME_MAKER = preload("res://resources/game_maker.tres")

var current_game: int = 0 # 31 # 0
enum LANGUAGE {ENGLISH, SWAHILI}
@export var current_language := LANGUAGE.ENGLISH

# every time we figure out a bonus word we get a reward according to how long the word is
var current_score: int = 0
enum GAME_STATE {IN_PROGRESS, LEVEL_COMPLETED}
var game_state: GAME_STATE = GAME_STATE.IN_PROGRESS

@onready var formed_word_label: Label = $BottomPart/FormedWordControl/FormedWordLabel

@onready var word_circle_texture_rect: TextureRect = $BottomPart/WordCircleTextureRect
@onready var dot_hub: Node2D = $BottomPart/WordCircleTextureRect/DotHub

@onready var dot_line_2d: Line2D = $BottomPart/WordCircleTextureRect/DotHub/DotLine2D

@onready var found_words_grid_container: GridContainer = $MiddlePart/FoundWordsGridContainer
@onready var word_grid_container: GridContainer = $MiddlePart/WordGridContainer

const DOT = preload("res://dot/dot.tscn")
var selected_dot_array: Array[Dot]
var dot_transform_dict: Dictionary

# We'll figure out a way to load this main scene with the actual letters to form words from already set
# we also need a way to save progress

# THE GAME MAKERS
var actual_letters := "PANELS"
var number_of_dots: int = actual_letters.length()
var word_columns: int = 2
var words_to_find_array: Array = ['PLAN', 'LANE', 'PLEA', 'LANES', 'LEAPS', 'PLANE', 'PLANES',  'PLEAS']
var found_words_array: Array
var found_bonus_words_array: Array
var temp_found_words_array: Array # after loading the game we hold the values here before
var temp_found_bonus_words_array: Array

## an array full of words
var all_english_words: Array
var all_swahili_words: Array
var all_words: Array

const WORD_PANEL = preload("res://word/word_panel.tscn")
var word_panel_dict: Dictionary

@onready var bonus_word_rich_text_label: RichTextLabel = $BonusWordRichTextLabel
@onready var already_found_bonus_word_rich_text_label: RichTextLabel = $AlreadyFoundBonusWordRichTextLabel

var min_word_circle_position: float

var dot_wall_offset: int = 20 ## dot's distance in pixels from the Word Circle wall

var touch_started: bool ## if action to select dot has started
#var drag_started: bool ## to help display the line_2d

var dictionary_file = "res://assets/dictionary.txt"
var kamusi_file = "res://assets/Kamusi/kamusi_words.txt"

var current_progress_dict: Dictionary

@onready var shuffle_texture_button: TextureButton = $BottomPart/ShuffleTextureButton

@onready var current_game_label: Label = $UpperPart/CurrentGameLabel

@onready var screen_transition_color_rect: ColorRect = $ScreenTransitionColorRect
@onready var game_over_screen_color_rect: ColorRect = $GameOverScreenColorRect

var save_file_path = "user://progress.sav" # progress/

func _ready() -> void:
	randomize()
	
	initialize_game()
	
	load_progress()
	
	screen_transition()


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


func initialize_game():
	shuffle_texture_button.button_down.connect(shuffle_dots)
	shuffle_texture_button.pivot_offset = shuffle_texture_button.size * 0.5
	
	formed_word_label.resized.connect(show_formed_word_label_contents)
	show_formed_word_label_contents()
	
	all_english_words = parse_dictionary(dictionary_file)
	all_swahili_words = parse_dictionary(kamusi_file)
	choose_dictionary()
	
	handling_notches()
	
	game_over_screen_color_rect.visible = false


func load_next_game():
	# loading a new game
	initialize_new_game_settings()
	format_word_grid()
	
	centering_dot_hub()
	place_dots()
	
	bonus_word_rich_text_label.scale = Vector2.ZERO
	already_found_bonus_word_rich_text_label.scale = Vector2.ZERO
	
	shuffle_dots()
	
	# making sure we are loading the right dictionary
	choose_dictionary()


func initialize_new_game_settings():
	# settings to reset
	found_words_array.clear()
	found_bonus_words_array.clear()
	words_to_find_array.clear()
	
	#selected_dot_array.clear()
	dot_transform_dict.clear()
	
	word_panel_dict.clear()
	
	# fetching new game settings
	var game_dict: Dictionary = GAME_MAKER.games[current_language]
	if game_dict.has(current_game):
		var curr_game_settings: Dictionary = game_dict[current_game]
		print("Current game settings: %s" % [curr_game_settings])
		current_game_label.text = "Game %s - Game State: %s" % [current_game, game_state]
		actual_letters = curr_game_settings.letters
		number_of_dots = actual_letters.length()
		word_columns = curr_game_settings.columns
		words_to_find_array = curr_game_settings.words_to_find
	else:
		game_over_transition()
		print("Congrats! You kwinished the game! You're done!")


func centering_dot_hub():
	min_word_circle_position = min(word_circle_texture_rect.size.x, word_circle_texture_rect.size.y)
	#dot_hub.position = Vector2.ONE * min_word_circle_position * 0.5
	dot_hub.position = word_circle_texture_rect.size * 0.5


func place_dots():
	# clearing anything that's not a line 2D
	for child in dot_hub.get_children():
		if child is not Line2D:
			child.queue_free()
			
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
		dot_transform_dict[index] = {'dot':dot, 'parent_rotation':new_node.rotation}


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
		# checking if the formed word appears in the word panel
		if formed_word in word_panel_dict.keys():
			if formed_word not in found_words_array:
				word_panel_dict[formed_word].animate_found_word()
				found_words_array.append(formed_word)
				save_progress()
				print("Appended and saved formed word!")
				
				# when the size of the found word array and words to find array tally we advance the current game
				if found_words_array.size() == words_to_find_array.size():
					game_state = GAME_STATE.LEVEL_COMPLETED
					save_progress()
					print("Completed game advanced it and saved!")
					#current_game += 1
					#print("Congratulations! You finished the game!")
					
					screen_transition()
			else:
				word_panel_dict[formed_word].flash_found_word()
				#print("Flash the formed word on screen!")
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
		var new_word_panel: WordPanel = WORD_PANEL.instantiate()
		new_word_panel.word_to_display = word_to_find.to_upper()
		word_grid_container.add_child(new_word_panel)
		
		word_panel_dict[word_to_find.to_upper()] = new_word_panel
	
	load_found_and_bonus_words()


func load_found_and_bonus_words():
	#game_state = GAME_STATE.IN_PROGRESS
	
	if not temp_found_words_array.is_empty():
		found_words_array.clear()
		found_words_array = temp_found_words_array.duplicate()
		
		var word_grid_container_children: Array = word_grid_container.get_children()
		for found_word: String in temp_found_words_array:
			for wp: WordPanel in word_grid_container_children:
				if wp.word_to_display.to_upper() == found_word.to_upper():
					wp.animate_found_word()
					
					#word_panel_dict[word_to_find.to_upper()] = new_word_panel
					print("Word to Display: %s" % [wp.word_to_display])
		
	if not temp_found_bonus_words_array.is_empty():
		found_bonus_words_array.clear()
		found_bonus_words_array = temp_found_bonus_words_array.duplicate()
		#temp_found_bonus_words_array.clear()
		
	#print("word_panel_dict: %s" % [word_panel_dict])


func look_up_word_in_dictionary(formed_word: String):
	if all_words.has(formed_word.to_upper()):
		if not found_bonus_words_array.has(formed_word):
			display_found_bonus_word(formed_word)
			#print("FOUND WORD: %s" % [formed_word])
		else:
			display_already_found_bonus_word(formed_word)
			#print("ALREADY FOUND WORD: %s" % [formed_word])
		
		if formed_word.to_upper() not in found_bonus_words_array:
			found_bonus_words_array.append(formed_word.to_upper())
			save_progress()
			print("Updated bonus words and saved game!")
	else:
		# we have a word not found animation
		pass

func display_found_bonus_word(bonus_word: String):
	bonus_word_rich_text_label.text = "[center][u]Bonus Word Found![/u]\n[font_size=40][color=green]%s[/color][/font_size][/center]" % [bonus_word]
	
	bonus_word_rich_text_label.pivot_offset = bonus_word_rich_text_label.size * 0.5
	
	var bonus_tween := create_tween()
	bonus_tween.tween_property(bonus_word_rich_text_label, "scale", Vector2.ONE, 0.4)
	bonus_tween.tween_property(bonus_word_rich_text_label, "scale", Vector2.ONE, 2.5)
	bonus_tween.tween_property(bonus_word_rich_text_label, "scale", Vector2.ZERO, 0.1)
	bonus_tween.set_ease(Tween.EASE_IN_OUT)
	bonus_tween.set_trans(Tween.TRANS_SPRING)


func display_already_found_bonus_word(bonus_word: String):
	already_found_bonus_word_rich_text_label.text = "[center][u]Bonus Word\nAlready Found![/u]\n[font_size=40][color=green]%s[/color][/font_size][/center]" % [bonus_word]
	
	already_found_bonus_word_rich_text_label.pivot_offset = bonus_word_rich_text_label.size * 0.5
	
	var already_found_bonus_tween := create_tween()
	already_found_bonus_tween.tween_property(already_found_bonus_word_rich_text_label, "scale", Vector2.ONE, 0.2)
	already_found_bonus_tween.tween_property(already_found_bonus_word_rich_text_label, "scale", Vector2.ONE, 1.6)
	already_found_bonus_tween.tween_property(already_found_bonus_word_rich_text_label, "scale", Vector2.ZERO, 0.05)
	already_found_bonus_tween.set_ease(Tween.EASE_IN_OUT)
	already_found_bonus_tween.set_trans(Tween.TRANS_SPRING)


func parse_dictionary(dictionary) -> Array:
	var word_arr: Array = []
	var dict_file := FileAccess.open(dictionary, FileAccess.READ)
	while not dict_file.eof_reached():
		var line: String = dict_file.get_line()
		if "'" not in line and line.length() > 1:
			#print("Current word: %s" % [line])
			word_arr.append(line.to_upper())
	#print("FINAL WORD: ", word_arr[word_arr.size() - 1])
	#print("FINAL WORD: %s - %s" % [word_arr[word_arr.size() - 1], word_arr.size()])
	return word_arr


func shuffle_dots():
	# the intention is to shuffle the dot transform dictionary such that dots get shifted to a random position
	var shuffle_array: Array = dot_transform_dict.keys()
	shuffle_array.shuffle()
	
	for index in dot_transform_dict.keys():
		var random_index: int = shuffle_array[index]
		
		var current_dot: Dot = dot_transform_dict[index].dot
		var shuffle_tween := create_tween()
		shuffle_tween.tween_property(current_dot.get_parent(), "rotation", dot_transform_dict[random_index].parent_rotation, 0.3)
		shuffle_tween.parallel().tween_property(current_dot, "rotation", -dot_transform_dict[random_index].parent_rotation, 0.3)
		shuffle_tween.set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_SINE)
	
	var shuffle_press_tween := create_tween()
	shuffle_press_tween.tween_property(shuffle_texture_button, "scale", Vector2.ONE * 0.6, 0.1)
	shuffle_press_tween.tween_property(shuffle_texture_button, "scale", Vector2.ONE, 0.3)
	shuffle_press_tween.set_ease(Tween.EASE_IN_OUT)
	shuffle_press_tween.set_trans(Tween.TRANS_BOUNCE)
	#print("Shuffle!")


func screen_transition():
	screen_transition_color_rect.visible = true
	#screen_transition_color_rect.scale = Vector2(0, 1)
	screen_transition_color_rect.pivot_offset = Vector2(size.x, size.y * 0.5)
	
	var screen_transition_tween := create_tween()
	screen_transition_tween.tween_property(screen_transition_color_rect, "scale:x", 1, 0.8)
	
	# We wait to cover the screen before loading the next game
	screen_transition_tween.tween_callback(load_next_game)
	
	screen_transition_tween.tween_property(screen_transition_color_rect, "pivot_offset", Vector2(0, size.y * 0.5), 0.05)
	screen_transition_tween.tween_property(screen_transition_color_rect, "scale:x", 0, 0.5)
	screen_transition_tween.set_ease(Tween.EASE_IN_OUT)
	screen_transition_tween.set_trans(Tween.TRANS_QUINT)


func game_over_transition():
	game_over_screen_color_rect.visible = true
	game_over_screen_color_rect.scale = Vector2(0, 1)
	
	game_over_screen_color_rect.pivot_offset = Vector2(0, size.y * 0.5)
	
	var game_over_transition_tween := create_tween()
	game_over_transition_tween.tween_property(game_over_screen_color_rect, "scale:x", 1, 0.4)
	game_over_transition_tween.set_ease(Tween.EASE_OUT)
	game_over_transition_tween.set_trans(Tween.TRANS_SINE)


func choose_dictionary():
	match current_language:
		LANGUAGE.ENGLISH:
			all_words = all_english_words
		LANGUAGE.SWAHILI:
			all_words = all_swahili_words
	#print(all_words[all_words.size() - 1])


func save_progress():
	var save_file := FileAccess.open(save_file_path, FileAccess.WRITE)
	
	current_progress_dict["game_%s_found_words" % [current_game]] = found_words_array.duplicate()
	current_progress_dict["game_%s_found_bonus_words" % [current_game]] = found_bonus_words_array.duplicate()
	
	# here we want to make sure that we are either advancing the current game or just saving progress so far
	match game_state:
		GAME_STATE.LEVEL_COMPLETED:
			current_game += 1
			game_state = GAME_STATE.IN_PROGRESS
			
	current_progress_dict["current_game"] = current_game # we save before advancing to the next game
	current_progress_dict["current_score"] = current_score
		
	save_file.store_var(current_progress_dict)
	save_file.close()
	print("Saved Progress Dict: %s" % [current_progress_dict])


func load_progress():
	if FileAccess.file_exists(save_file_path):
		var read_file := FileAccess.open(save_file_path, FileAccess.READ)
		var loaded_current_progress_dict: Dictionary = read_file.get_var()
		read_file.close()
		current_progress_dict = loaded_current_progress_dict
		#LOAD CURRENT GAME
		if "current_game" in loaded_current_progress_dict:
			current_game = loaded_current_progress_dict["current_game"]
		#LOAD CURRENT SCORE
		if "current_score" in loaded_current_progress_dict:
			current_score = loaded_current_progress_dict["current_score"]
		print("Loaded Progress Dict: %s" % [loaded_current_progress_dict])
		
		#we load the found words here
		# FOUND WORDS
		if "game_%s_found_words" % [current_game] in loaded_current_progress_dict:
			temp_found_words_array = loaded_current_progress_dict["game_%s_found_words" % [current_game]].duplicate()
			print("Game %s Found Words: %s" % [current_game, temp_found_words_array])
		else:
			print("Bado kusave found words!")
			
		# FOUND BONUS WORDS
		if "game_%s_found_bonus_words" % [current_game] in loaded_current_progress_dict:
			temp_found_bonus_words_array = loaded_current_progress_dict["game_%s_found_bonus_words" % [current_game]].duplicate()
			print("Game %s Found Bonus Words: %s" % [current_game, temp_found_bonus_words_array])
		else:
			print("Bado kusave found bonus words!")
		
