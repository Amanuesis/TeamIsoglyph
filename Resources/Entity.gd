extends KinematicBody2D
class_name Entity

export var health : = 20 setget set_health
export var damage : = 5
export var movement : = 5

var can_act : = true
var in_focus : = false

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
	
