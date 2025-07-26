extends Control

@onready var h_box_container: HBoxContainer = $Panel/HBoxContainer

func _ready() -> void:
	await get_tree().process_frame # important to allow controls to first draw
	
	var num_of_children: int = h_box_container.get_child_count()
	var control_size: Vector2 = h_box_container.size
	
	var horizontal_size = control_size.x / num_of_children
	
	for ctl in h_box_container.get_children():
		if control_size.y > horizontal_size:
			ctl.custom_minimum_size = Vector2.ONE * horizontal_size
			ctl.size = Vector2.ONE * horizontal_size
		else:
			ctl.custom_minimum_size = Vector2.ONE * control_size.y
			ctl.size = Vector2.ONE * control_size.y
		
