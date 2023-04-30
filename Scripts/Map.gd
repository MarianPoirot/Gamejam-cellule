extends TileMap

class_name Map

var occupedTile : Vector2i = Vector2i(0,0)

func Init():
	var center : Vector2i = Vector2i(get_viewport_rect().size/2) - (tile_set.tile_size/2)
	var cellPos : Vector2i = local_to_map(center)
	set_cell(0, cellPos,0, occupedTile)


func alignCoord(coord : Vector2) -> Vector2:
	var cell = local_to_map(coord)
	return map_to_local(cell)

func findNeighbor(worldCoord : Vector2) -> Vector2:
	var neighbors = []
	var cellCoord = local_to_map(worldCoord)
	neighbors.append(get_neighbor_cell(cellCoord,TileSet.CELL_NEIGHBOR_RIGHT_SIDE))
	neighbors.append(get_neighbor_cell(cellCoord,TileSet.CELL_NEIGHBOR_LEFT_SIDE))
	neighbors.append(get_neighbor_cell(cellCoord,TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE))
	neighbors.append(get_neighbor_cell(cellCoord,TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE))
	neighbors.append(get_neighbor_cell(cellCoord,TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE))
	neighbors.append(get_neighbor_cell(cellCoord,TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE))
	neighbors.append(get_neighbor_cell(cellCoord,TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE))
	
	randomize()
	
	neighbors.shuffle()
	for i in range(neighbors.size()):
		if(get_cell_atlas_coords(0,neighbors[i]) != occupedTile):
			set_cell(0,neighbors[i],0,occupedTile)
			return map_to_local(neighbors[i])
	return worldCoord

func center() -> Vector2:
	return Vector2i(get_viewport_rect().size/2) - (tile_set.tile_size/2)

func align(coord) -> Vector2:
	var mapCoord = local_to_map(coord)
	return map_to_local(mapCoord)

