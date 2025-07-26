extends Resource

var touch_started: bool = false

var current_dot = null
var previous_dot = null

var selected_dots: Array
var links: Dictionary

var formed_word: String
var validated_word: String

var tries: int

var dictionary_array: Array

func process_formed_word():
	if current_dot:
		current_dot.fire_mouse_exit_signal()
		if formed_word.length() > 1:
			validate_formed_word()
			tries += 1
		reset_all()


func selected_dots_check():
	if selected_dots.has(current_dot):
		return
	selected_dots.append(current_dot)


func validate_formed_word() -> bool:
	if dictionary_array.has(formed_word):
		return true
	return false


func reset_all():
	selected_dots.clear()
	formed_word = ""
