extends KinematicBody2D
class_name Entity

export var health : = 20 setget set_health
export var damage : = 5
export var movement : = 5
export var team_name : String 
export var turn_manager_path : NodePath
onready var turn_manager : = get_node(turn_manager_path)

var can_act : = true
var in_focus : = false
var has_status_effect : = false

func _ready():
	var team : Team = turn_manager.find_team(team_name)
	team.register_team_member(self)

func deal_damage(other : Entity):
	other.health -= damage
	if other.health > 0:
		health -= other.damage
		
func die():
	modulate = Color.darkblue
	scale *= 0.5

func set_health(new_health : int):
	health = new_health
	if health < 0:
		die()

func action():
	can_act = false
	
