class_name NPCNavigation extends NavigationAgent2D


# Constants
const PATH_RADIUS = 50.0


func find_new_path() -> void:
	target_position = get_parent().global_position + Vector2(randf() - 0.5, randf() - 0.5).normalized() * PATH_RADIUS
