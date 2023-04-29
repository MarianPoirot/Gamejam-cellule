extends TileMap

var blank : Vector2i = Vector2i(2,0)

func _unhandled_input(event):
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		var cellPos : Vector2i = local_to_map(get_global_mouse_position())
		set_cell(0, cellPos,0, blank)
