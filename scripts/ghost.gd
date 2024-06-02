class_name Ghost extends NPC

enum actions{CHOP_TREE, GROW_TREE, GROW_CROPS, HARVEST_CROPS, COLLECT_WATER, HELP_VILLAGER, STATIONARY}
var busy_days_left = 0
var action = actions.STATIONARY

func do_action():
	if busy_days_left > 0:
		busy_days_left -= 1
	if busy_days_left == 0:
		if action == actions.CHOP_TREE:
			for resource : Resources in get_tree().get_nodes_in_group("resources"):
				if resource is Forest:
					resource.chop_tree()
					break
			action = actions.STATIONARY
		
		if action == actions.GROW_TREE:
			for resource : Resources in get_tree().get_nodes_in_group("resources"):
				if resource is Forest:
					resource.trees += 1
					break
			action = actions.STATIONARY
		
		if action == actions.GROW_CROPS:
			for resource : Resources in get_tree().get_nodes_in_group("resources"):
				if resource is Crops:
					resource.crops += 1;
					break
			action = actions.STATIONARY
		
		if action == actions.HARVEST_CROPS:
			for resource : Resources in get_tree().get_nodes_in_group("resources"):
				if resource is Crops:
					resource.harvest_crops()
					break
			action = actions.STATIONARY
		
		if action == actions.COLLECT_WATER:
			for resource : Resources in get_tree().get_nodes_in_group("resources"):
				if resource is Stream:
					resource.resource_storage += 1
					break
			action = actions.STATIONARY
		
		if action == actions.HELP_VILLAGER:
			pass
			action = actions.STATIONARY
		
		


func action_forest_chop():
	var busy_days_left = 1
	action = actions.CHOP_TREE


func action_forest_grow():
	var busy_days_left = 1
	action = actions.GROW_TREE


func action_crops_grow():
	var busy_days_left = 1
	action = actions.GROW_CROPS

func action_harvest_crops():
	var busy_days_left = 1
	action = actions.HELP_VILLAGER


func action_collect_water():
	var busy_days_left = 1
	action = actions.COLLECT_WATER


func action_help_villager():
	var busy_days_left = 1
	action = actions.HELP_VILLAGER



