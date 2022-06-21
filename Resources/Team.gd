extends Resource
class_name Team

export var team_name : String
export var team_color : Color
export var tint_members : = false

var team_members : = []
var current_member_index : = 0


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
	
func current_member() -> Entity:
	return team_members[current_member_index] 
	
func switch_to(member : Entity):
	current_member_index = team_members.find(member)
	
func register_team_member(member:Entity):
	team_members.append(member)
	if tint_members:
		member.modulate = team_color
	
func deregister_team_member(member:Entity):
	team_members.remove(team_members.find(member))
	if tint_members:
		member.modulate = Color.white

func get_members():
	return team_members
