class_name NPC extends CharacterBody2D


#Constants
const SPEED = 15.0

# Signals
signal npc_ready_done

# Export variables
@export_range(0, 8) var id: int
@export var npc_name: String

# In-scene nodes
@onready var navigation = $Navigation
@onready var hair = $Hair


func _ready():
	assert(id, "ID of a villager was not set")
	assert(npc_name, "Name of " + str(id) + " was not set")
	assert(hair.texture is AtlasTexture, "Hair texture on " + npc_name + " is not an AtlasTexture")
	
	npc_ready_done.emit()


func _physics_process(_delta):
	if navigation.is_navigation_finished():
		navigation.find_new_path()
	
	velocity = global_position.direction_to(navigation.get_next_path_position()) * SPEED
	
	move_and_slide()


func do_action():
	pass
