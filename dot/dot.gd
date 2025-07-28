extends Area2D
class_name Dot

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var dot_sprite_2d: Sprite2D = $DotSprite2D

@onready var dot_label: Label = $DotLabel

var dot_size = 40

var dot_value: String = 'A'

@export var highlight_color: Color = Color('#ff4500')
var normal_color: Color = Color.WHITE

func _ready() -> void:
	dot_label.text = dot_value
	
	dot_sprite_2d.scale = Vector2.ZERO


func highlight_dot():
	var highlight_tween := create_tween()
	highlight_tween.tween_property(dot_sprite_2d, "modulate", highlight_color, 0.2)
	highlight_tween.parallel().tween_property(dot_sprite_2d, "scale", Vector2.ONE, 0.2)
	highlight_tween.set_ease(Tween.EASE_IN_OUT)
	highlight_tween.set_trans(Tween.TRANS_SPRING)


func dehighlight_dot():
	var dehighlight_tween := create_tween()
	dehighlight_tween.tween_property(dot_sprite_2d, "modulate", normal_color, 0.2)
	dehighlight_tween.parallel().tween_property(dot_sprite_2d, "scale", Vector2.ZERO, 0.2)
	dehighlight_tween.set_ease(Tween.EASE_IN_OUT)
	dehighlight_tween.set_trans(Tween.TRANS_SPRING)
