class_name NPC extends CharacterBody2D


#Constants
const SPEED = 25.0

# In-scene nodes
@onready var navigation = $Navigation

# Name
var village_name = "John"


func _physics_process(_delta):
	if navigation.is_navigation_finished():
		navigation.find_new_path()
	
	velocity = global_position.direction_to(navigation.get_next_path_position()) * SPEED
	
	move_and_slide()


func do_action(action):
	assert(false, "Please implement function on " + self.name)
