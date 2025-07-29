extends Control

const MAIN_SCENE = preload("res://main_scene.tscn")

@onready var start_button: Button = $StartButton

var dictionary_file = "res://Assets/dictionary.txt"
var kamusi_file = "res://Assets/Kamusi/kamusi_words.txt"

func _ready() -> void:
	start_button.pressed.connect(on_start_button_pressed)


func on_start_button_pressed():
	var main_scene = MAIN_SCENE.instantiate()
	main_scene.all_words = parse_dictionary()
	get_tree().change_scene_to_packed(main_scene)


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
