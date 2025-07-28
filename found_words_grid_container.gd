extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Size 1: %s" % [size])
	await get_tree().process_frame
	print("Size 2: %s" % [size])
	#await get_tree().process_frame
	#print("Size 3: %s" % [size])
	
	var minimum_letter_size = find_smallest_letter_size()
	print("Min Letter SIze: %s" % [minimum_letter_size])
	assign_minimum_letter_size_globally(minimum_letter_size)


func assign_minimum_letter_size_globally(min_letter_size: float):
	for word_row: Control in get_children():
		var letter_children_array: Array = word_row.get_children()
		for letter: Control in letter_children_array:
			letter.size = Vector2.ONE * min_letter_size
			letter.custom_minimum_size = Vector2.ONE * min_letter_size
			#await get_tree().process_frame
			letter.get_node("LetterLabel").size = Vector2.ONE * (min_letter_size-2)
			letter.get_node("LetterLabel").custom_minimum_size = Vector2.ONE * (min_letter_size-2)
	
	
# we scan through the word_rows and find the smallest vertical size a letter should be
func find_smallest_letter_size() -> float:
	var minimum_vertical_size: float
	var minimum_horizontal_size: float
	var smallest_vertical_division: float = size.x
	var smallest_horizontal_size: float = size.y
	for word_row: Control in get_children():
		var letter_children: int = word_row.get_child_count()
		var control_dimensions: Vector2 = word_row.size
		var vertical_division: float = control_dimensions.x / letter_children
		
		minimum_vertical_size = min(vertical_division, smallest_vertical_division)
		minimum_horizontal_size = min(control_dimensions.y, smallest_horizontal_size)
		
		smallest_vertical_division = minimum_vertical_size
		smallest_horizontal_size = minimum_horizontal_size
		print("Min Vert: %s - Min Ho: %s" % [minimum_vertical_size, minimum_horizontal_size])
		#print("Word Row: %s - Size: %s - %s" % [letter_children, control_dimensions, vertical_division])
	#print("Minimum Vertical Size: %s - Min Horizontal: Size: %s" % [minimum_vertical_size, minimum_horizontal_size])
	return min(minimum_vertical_size, minimum_horizontal_size)
	
#the intention is to scan through all the subdivisons and use the smallest one for all labels
