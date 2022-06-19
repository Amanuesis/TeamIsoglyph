extends Entity

onready var parent : = get_parent().get_parent().get_parent()

func input(event):
	if Input.is_action_pressed("ui_left"):
		position.x -= 10 
	if Input.is_action_pressed("ui_right"):
		position.x += 10
	if Input.is_action_pressed("ui_up"):
		position.y -= 10
	if Input.is_action_pressed("ui_down"):
		position.y += 10
