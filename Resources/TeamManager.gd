extends Node2D

signal all_teams_acted

var team_script : = preload("res://Resources/Team.gd")

func current_team():
	return get_child(0)

func current_member():
	return current_team().current_member()

func pass_turn():
	if current_member().defeated():
		remove_team(current_member())
	move_child(current_team(), get_child_count() - 1)
		
func game_over():
	return get_child_count() <= 1

func add_team(team_name : String, team_color : Color):
	var new_team : = Node2D.new()
	new_team.set_script(team_script)

func remove_team(team : Team):
	remove_child(find_team(team.team_name))
	
func find_team(team_name : String):
	for child in get_children():
		if team_name == child.team_name:
			return child

func get_teams():
	return get_children()
