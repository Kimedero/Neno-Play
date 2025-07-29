extends Control

var word_to_display: String = "JINA"

@onready var word_label: RichTextLabel = $WordLabel

func _ready() -> void:
	word_label.text = ""
	for letter in word_to_display:
		word_label.text += "_ "
		#print(word_label.text)
	#print(word_to_display)


func animate_found_word():
	apply_found_word_theme()
	
	var found_word_tween = create_tween()
	found_word_tween.tween_property(word_label, "text", word_to_display, 0.5)
	#found_word_tween.parallel().tween_property(word_label, "modulate", Color.GREEN_YELLOW, 0.2)
	#found_word_tween.tween_property(word_label, "modulate", Color.WHITE, 1.0)
	found_word_tween.set_ease(Tween.EASE_IN_OUT)
	found_word_tween.set_trans(Tween.TRANS_SPRING)


func apply_found_word_theme():
	var new_style_box_flat = StyleBoxFlat.new()
	new_style_box_flat.corner_radius_top_left = 10
	new_style_box_flat.corner_radius_top_right = 10
	new_style_box_flat.corner_radius_bottom_right = 10
	new_style_box_flat.corner_radius_bottom_left = 10
	
	new_style_box_flat.bg_color = Color.GREEN
	
	word_label["theme_override_styles/normal"] = new_style_box_flat
