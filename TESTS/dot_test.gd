extends Area2D
class_name WordDot

var GAME_SETTINGS = load("res://Resources/GameSettings.tres")

var dot_size = 40

var dot_value: String = 'A'

var adding_line: bool

@onready var dot_sprite_2d: Sprite2D = $SpriteHub/DotSprite2D
@onready var dot_label: Label = $DotLabel

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var normal_color: Color = Color.ORANGE_RED
@export var highlight_color: Color = Color.GREEN

func _ready() -> void:
	mouse_entered.connect(on_dot_mouse_entered)
	mouse_exited.connect(on_dot_mouse_exited)
	
	await get_tree().process_frame
	dot_label.text = dot_value


func on_dot_mouse_entered():
	print("Mouse entered %s" % [self])
	dot_activate()


func on_dot_mouse_exited():
	print("Mouse exited %s" % [self])
	dot_deactivate()


func dot_activate():
	GAME_SETTINGS.current_dot = self
	
	adding_line = false
	
	animate_color(highlight_color, 0.125)
	
	if not GAME_SETTINGS.selected_dots.has(GAME_SETTINGS.current_dot):
		GAME_SETTINGS.formed_word += dot_value
		GAME_SETTINGS.selected_dots.append(GAME_SETTINGS.current_dot)


func dot_deactivate():
	GAME_SETTINGS.previous_dot = self
	
	adding_line = true
	
	animate_color(normal_color)


func animate_color(color: Color, duration: float = 0.25):
	var _animate_tween = create_tween()
	_animate_tween.tween_property(dot_sprite_2d, "modulate", color, duration)
	_animate_tween.set_ease(Tween.EASE_IN_OUT)
	_animate_tween.set_trans(Tween.TRANS_SINE)


#a janky way to make the screen exited signal fire for the current dot
#when we let go of the screen
func fire_mouse_exit_signal():
	collision_shape_2d.disabled = true
	await get_tree().process_frame
	collision_shape_2d.disabled = false
	
	GAME_SETTINGS.current_dot = null
