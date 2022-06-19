extends Resource
class_name Target

var entity : Object = null
var position : = Vector2.ZERO

func setup(entity_or_position):
	"""
	Constructor for target object
	"""
	if entity_or_position is Vector2:
		position = entity_or_position
	elif entity_or_position is Object:
		entity = entity_or_position
		position = entity.global_position
	else:
		print_debug("Target has invalid target")
		assert(false)
	
func has_entity() -> bool:
	"""
	Returns if the target is tracking an entity
	"""
	return entity != null

func get_entity() -> Object:
	"""
	Returns tracked entity
	"""
	return entity
	
func get_position() -> Vector2:
	"""
	Returns target position
	"""
	if has_entity():
		return get_entity().global_position
	return position

func destroy_on_signal(caller : Object, destroy_signal : String) -> void:
	"""
	Allows target to be destroyed when signal called
	"""
	caller.connect(destroy_signal, self, "free")
	
#func debug_draw():
#	"""
#	Allows a sprite to be draw at Target location for debug purposes
#	"""
#	var debug = Sprite.new()

#classAITargetBase{
#	public:virtualboolInit(constAICreationData& cd);
#	// Get the target's position
#	virtual const AIVectorBase& GetPosition() const= 0;
#	// Get the entity associated with this target (if any)
#	virtual AIEntity* GetEntity() const{ returnNULL; }
#	virtual bool HasEntity() const{ returnfalse; }
