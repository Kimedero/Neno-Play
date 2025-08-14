extends Control

@onready var current_game_label: Label = $CurrentGameLabel
@onready var word_text_edit: TextEdit = $wordTextEdit
@onready var save_button: Button = $SaveButton
@onready var info_label: Label = $infoLabel

var progress_dict: Dictionary
var current_game: int = 0

func _ready() -> void:
	save_button.pressed.connect(save_progress)


func save_progress():
	var text_to_save: String = ""
	for i in current_game + 1:
		text_to_save += "%s -> " % [word_text_edit.text]
	progress_dict["game_%s" % current_game] = text_to_save
	
	info_label.text = "%s" % progress_dict
	current_game += 1
