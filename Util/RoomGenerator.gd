tool
extends Node2D

#onready var generation_viewport : = $GPUGeneration/Viewport
#onready var generation_sprite : = $GPUGeneration/Viewport/Sprite
#onready var output_sprite : = $Output

export var steps : = 5
export (float, 0.0, 1.0)var fill_percent : = 0.45 setget set_fill_percent
export var random_seed : = 1.0 setget set_random_seed
export var simulate_ca : = false setget set_simulate_ca

var is_ca_active : = false
var fill_shader : = preload("res://Shaders/random_fill.shader")
var ca_shader : = preload("res://Shaders/CA.shader")
var current_steps : = steps

signal done
func _ready():
	start()
func start():
	if not Engine.editor_hint:
		self.simulate_ca = false
		yield(VisualServer, "frame_post_draw")	
		yield(VisualServer, "frame_post_draw")	
		start_ca()
	
func start_ca():
	var generation_sprite : = $GPUGeneration/Viewport/Sprite
	var generation_viewport : = $GPUGeneration/Viewport
	generation_sprite.material.shader = ca_shader
	generation_sprite.material.set_shader_param("enabled", true)
	generation_sprite.material.set_shader_param("stopped", false)
	generation_sprite.material.set_shader_param("wall_values", generation_viewport.get_texture())
	is_ca_active = true
	
func stop_ca():
	var generation_sprite : = $GPUGeneration/Viewport/Sprite
	generation_sprite.material.set_shader_param("stopped", true)
	
func reset():
	var generation_sprite : = $GPUGeneration/Viewport/Sprite
	var generation_viewport : = $GPUGeneration/Viewport
	generation_sprite.material.shader = fill_shader
	generation_viewport.render_target_clear_mode = Viewport.CLEAR_MODE_ALWAYS
	yield(VisualServer, "frame_post_draw")
	generation_viewport.render_target_clear_mode = Viewport.CLEAR_MODE_NEVER
	current_steps = steps
	set_process(true)
	if Engine.editor_hint:
		if simulate_ca:
			yield(VisualServer, "frame_post_draw")	
			yield(VisualServer, "frame_post_draw")	
			start_ca()
			
func _process(delta):
	var output_sprite : = $Output
	if is_ca_active:
		current_steps -= 1
		
	if current_steps <= 0:
		stop_ca()
		emit_signal("done", output_sprite.texture.get_data())
		set_process(false)
		is_ca_active = false
		
func set_random_seed(new_seed : float) :
	random_seed = new_seed
	if Engine.editor_hint:	
		$GPUGeneration/Viewport/Sprite.material.set_shader_param("rand_seed", new_seed)
		reset()
#		if simulate_ca:
#			yield(VisualServer, "frame_post_draw")	
#			yield(VisualServer, "frame_post_draw")	
#			start_ca()

func set_fill_percent(fill : float) :
	fill_percent = fill
	if Engine.editor_hint:	
		$GPUGeneration/Viewport/Sprite.material.set_shader_param("threshold", fill)
		reset()
#		if simulate_ca:
#			yield(VisualServer, "frame_post_draw")	
#			yield(VisualServer, "frame_post_draw")	
#			start_ca()

func set_simulate_ca(value : bool):
	simulate_ca = value
	if Engine.editor_hint:	
		if value:
			start_ca()
		else:
			reset()
