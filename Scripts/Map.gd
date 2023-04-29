extends TileMap

class_name Map

var productiveCellCoord : Vector2i = Vector2i(2,0)

func _ready():
	var center : Vector2i = Vector2i(get_viewport_rect().size/2) - (tile_set.tile_size/2)
	var cellPos : Vector2i = local_to_map(center)
	set_cell(0, cellPos,0, productiveCellCoord)

func _unhandled_input(event):
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		print(local_to_map(get_global_mouse_position()))

func isProductiveCell() -> bool:
	var textureCoord = get_cell_atlas_coords(0, local_to_map(get_local_mouse_position()))
	return textureCoord == productiveCellCoord

func alignCoord(coord : Vector2) -> Vector2:
	var cell = local_to_map(coord)
	return map_to_local(cell)

func center() -> Vector2:
	return Vector2i(get_viewport_rect().size/2) - (tile_set.tile_size/2)
