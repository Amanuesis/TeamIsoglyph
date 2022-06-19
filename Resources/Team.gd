extends Node2D
class_name Team

export var team_name : String
export var team_color : Color

var team_members : = []
var current_member_index : = 0

onready var team_manager : = get_parent()

func _ready():
	for child in get_children():
		register_team_member(child)

func start_turn():
	for member in team_members:
		member.can_act = true
		
func next_member():
	for i in range(team_members.size()):
		var next_index : = wrapi(current_member_index + i, 0, team_members.size() - 1)
		if team_members[wrapi(current_member_index + i, 0, team_members.size() - 1)].can_act:
			return next_index
	return null

func defeated():
	for member in team_members:
		if member.health > 0:
			return false
	return true
	
func current_member():
	var team_member: = get_child(current_member_index)
	if team_member.can_act != true:
		team_member = next_member()
	return team_member
	
func register_team_member(member:Object):
	team_members.append(member)
	member.modulate = team_color
	
func deregister_team_member(member:Object):
	team_members.remove(team_members.find(member))
	member.modulate = Color.white
