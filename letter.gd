extends Control

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	
	custom_minimum_size = Vector2.ONE * get_parent_area_size().x
	size = Vector2.ONE * get_parent_area_size().x
	
	#print("PARENT: %s - SIZE: %s" % [get_parent_control(), get_parent_area_size()])


func _draw() -> void:
	pass
