extends TileMap

onready var room_generator : = $RoomGenerator

signal room_built

func _ready():
	room_generator.connect("done", self, "load_tiles_from_tex_data",[], CONNECT_ONESHOT)
	
func load_tiles_from_tex_data(tex_data : Image):
	tex_data.lock()
	for x in range(tex_data.get_width()):
		for y in range(tex_data.get_height()):
			if tex_data.get_pixel(x,y).r > 0.5:
				set_cell(x,y, 1)
			else:
				set_cell(x,y, 0)
	room_generator.visible = false
	emit_signal("room_built")
