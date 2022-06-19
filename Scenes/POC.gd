extends Node2D
 
onready var tilemap : = $Room
onready var room_generator : = $Room/RoomGenerator
onready var nav : = AStar2D.new()
onready var team_manager : = $TeamManager
onready var camera : = $Camera2D 
onready var tween : = $Tween

func _ready():
	set_process(false)
	build_nav()
	
func build_nav():
#	room_generator.start()
	yield(tilemap, "room_built")
	#Add all pathfinding points
	for cell_coord in tilemap.get_used_cells():
		var debug_sprite : = Sprite.new()
		#debug
		debug_sprite.texture = preload("res://single_white_pixel.png")
		debug_sprite.position = tilemap.map_to_world(cell_coord) + tilemap.cell_size/2.0
		debug_sprite.modulate = Color.red
		debug_sprite.scale *= 8.0
		if tilemap.get_cellv(cell_coord) != 0:
			nav.add_point(nav.get_available_point_id(), tilemap.map_to_world(cell_coord) + tilemap.cell_size/2.0, 1.0)
		else:
			nav.add_point(nav.get_available_point_id(), tilemap.map_to_world(cell_coord) + tilemap.cell_size/2.0, 100.0)
			debug_sprite.modulate = Color.pink
		add_child(debug_sprite)
	#Connect them up
	for cell_coord in tilemap.get_used_cells():
		if tilemap.get_cellv(cell_coord) != 0:
			var current_cell : = nav.get_closest_point(tilemap.map_to_world(cell_coord))
			nav.connect_points(current_cell, vec_to_id(cell_coord + Vector2.LEFT))
			nav.connect_points(current_cell, vec_to_id(cell_coord + Vector2.UP))
#			var cell_to_the_left : = nav.get_closest_point(tilemap.map_to_world(cell_coord + Vector2.LEFT))
#			var cell_to_the_top : = nav.get_closest_point(tilemap.map_to_world(cell_coord + Vector2.UP))
#			if current_cell != cell_to_the_left:
#				nav.connect_points(current_cell, cell_to_the_left)
#			if current_cell != cell_to_the_top:
#				nav.connect_points(current_cell, cell_to_the_top)
#			for x in range(-1, 1):
#				for y in range(-1, 1):
#					var offset : = Vector2(x,y)
#					if offset != Vector2.ZERO and (x == 0 or y == 0):
#						if tilemap.get_cellv(cell_coord + offset) != 0:
#							nav.connect_points(nav.get_closest_point(tilemap.map_to_world(cell_coord)), nav.get_closest_point(tilemap.map_to_world(cell_coord + offset)))
	#Move to next step
	place_entities()

func place_entities():
	var starting_locations : = [Vector2(3,3), Vector2(32,24), Vector2(32,0), Vector2(0,24)]
	var index : = 0
	for team in team_manager.get_teams():
		while(team.next_member() != null):
			team.current_member().global_position = nav.get_point_position(nav.get_closest_point(team.current_member().global_position))
			team.current_member().action()
			index += 1
	set_process(true)
	camera.register_primary_focus(team_manager.current_member())
func _process(delta):
	
	if not team_manager.game_over():		
		$Line2D.clear_points()
		var start_pos : = nav.get_closest_point(team_manager.current_member().position)
		var end_pos : = nav.get_closest_point(get_global_mouse_position())
		for point in nav.get_point_path(start_pos,end_pos):
			$Line2D.add_point(point)

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		move_member(team_manager.current_member(), get_global_mouse_position())
		team_manager.current_member().action()
#	team_manager.current_member().input(event)

func win():
	print("yay")


func vec_to_id(vec : Vector2):
	return  vec.y * tilemap.get_used_rect().size.x + vec.x
	
func move_member(entity : Entity, point : Vector2, move_time : = 0.5):
	var start_pos : = nav.get_closest_point(entity.position)
	var end_pos : = nav.get_closest_point(get_global_mouse_position())
	var path : = nav.get_point_path(start_pos,end_pos)
	
	var time_per_segment : = move_time / path.size()
	for i in range(path.size() - 2):
		tween.interpolate_property(entity, "position", path[i], path[i+1], time_per_segment,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, time_per_segment * i )
	tween.start()
	
