extends Camera2D
class_name GlobalCamera

var primary_focus : = []
var secondary_focus : = []
var debug : = true
var pan_offset : = Vector2.ZERO


func _process(delta):
	global_position = get_center() + (pan_offset / zoom)
	if zoom <= Vector2.ZERO:
		zoom = Vector2.ONE / 100.0
		
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			var zoom_pos = get_camera_screen_center()
			if event.button_index == BUTTON_WHEEL_UP:
				zoom_pos = get_global_mouse_position()
				zoom += Vector2(0.1,0.1)
			# zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom_pos = get_global_mouse_position()
				zoom -= Vector2(0.1,0.1)				
	if Input.is_action_pressed("ui_left"):
		position.x -= 100 * zoom.x
	if Input.is_action_pressed("ui_right"):
		position.x += 100 * zoom.x		
	if Input.is_action_pressed("ui_up"):
		position.y -= 100 * zoom.y		
	if Input.is_action_pressed("ui_down"):
		position.y += 100 * zoom.y		
#	if Input.is_action_pressed("ui_left"):
#		pan_offset.x -= 10 * zoom.x
#	if Input.is_action_pressed("ui_right"):
#		pan_offset.x += 10 * zoom.x
#	if Input.is_action_pressed("ui_up"):
#		pan_offset.y -= 10 * zoom.y
#	if Input.is_action_pressed("ui_down"):
#		pan_offset.y += 10 * zoom.y
	
func get_center() -> Vector2:
	"""
	Calculates Camera center position based on primary and secondary focuses list
	"""
	#Primary Focus
	if not primary_focus:
		return position
		
	var influence : Vector2 = primary_focus[0].get_position()
	for focus in primary_focus:
		if focus == primary_focus[0]:
			continue
		influence += focus.get_position()
	influence /= primary_focus.size()
	#Secondary Influences
	var primary_center : = influence
	var secondary_influence : = Vector2.ZERO
	var counter = 0
	for focus in secondary_focus:
		var distance_to_focus : = primary_center.distance_to(focus[0].get_position())
		if  distance_to_focus >= focus[1]:
			continue
		secondary_influence += (focus[0].get_position() - primary_center) #* clamp(pow((1.0 - (distance_to_focus / focus[1])),2),0,1)
		counter += 1
	if counter:
		secondary_influence /= counter
	influence = primary_center + secondary_influence / 2
	return influence

func register_primary_focus(entity):
	if entity is Target:
		primary_focus.append(entity)
	elif entity is Vector2 or entity is Object:
		var entity_target : = Target.new()
		entity_target.setup(entity)
		primary_focus.append(entity_target)
	else:
		print_debug("Not a valid focus target")
		assert(false)

func clear_primary_focus(entity):
	primary_focus = []


func register_secondary_focus(entity, focus_radius : float):
	if entity is Target:
		secondary_focus.append([entity, focus_radius])
	elif entity is Vector2 or entity is Object:
		var entity_target : = Target.new()
		entity_target.setup(entity)
		secondary_focus.append([entity_target, focus_radius])
	else:
		print_debug("Not a valid focus target")
		assert(false)
	
