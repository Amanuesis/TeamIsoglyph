extends Node2D
 
onready var tilemap : = $Navigation2D/Room
onready var room_generator : = $Navigation2D/Room/RoomGenerator
onready var nav : = $Navigation2D
onready var team_manager : = $TeamManager
onready var camera : = $Camera2D 

func _ready():
	set_process(false)
	build_room()
	
func build_room():
	room_generator.start()
	place_entities()

func place_entities():
	var starting_locations : = [Vector2(3,3), Vector2(32,24), Vector2(32,0), Vector2(0,24)]
	var index : = 0
	for team in team_manager.get_teams():
		while(team.next_member() != null):
			team.current_member().global_position = starting_locations[index] * tilemap.cell_size
			team.current_member().action()
			index += 1
	set_process(true)
	camera.register_primary_focus(team_manager.current_member())
	
func _process(delta):
	if not team_manager.game_over():
		$Line2D.clear_points()
		var start_pos : Vector2 = nav.get_closest_point(team_manager.current_member().position)
		var end_pos : = get_global_mouse_position()
		$Line2D.add_point(tilemap.map_to_world(tilemap.world_to_map(start_pos))  + tilemap.cell_size/2)
		for point in nav.get_simple_path(start_pos,end_pos, false):
			$Line2D.add_point(tilemap.map_to_world(tilemap.world_to_map(point)) + tilemap.cell_size/2)

func _input(event):
	team_manager.current_member().input(event)

func win():
	print("yay")
