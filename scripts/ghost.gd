class_name Ghost extends NPC

enum actions{CHOP_TREE, GROW_TREE, GROW_CROPS, HARVEST_CROPS, COLLECT_WATER, HEAL_VILLAGER, IDLE}
var busy_days_left = 0
var action = actions.IDLE
var action_string = "idle"
var sick_villager

func do_action():
	if busy_days_left > 0:
		busy_days_left -= 1
	if busy_days_left == 0:
		if action == actions.CHOP_TREE:
			for resource : Resources in get_tree().get_nodes_in_group("resources"):
				if resource is Forest:
					resource.chop_tree()
					break
			action = actions.IDLE
			action_string = "idle"
		
		if action == actions.GROW_TREE:
			for resource : Resources in get_tree().get_nodes_in_group("resources"):
				if resource is Forest:
					resource.trees += 1
					break
			action = actions.IDLE
			action_string = "idle"
		
		if action == actions.GROW_CROPS:
			for resource : Resources in get_tree().get_nodes_in_group("resources"):
				if resource is Crops:
					resource.crops += 1;
					break
			action = actions.IDLE
			action_string = "idle"
		
		if action == actions.HARVEST_CROPS:
			for resource : Resources in get_tree().get_nodes_in_group("resources"):
				if resource is Crops:
					resource.harvest_crops()
					break
			action = actions.IDLE
			action_string = "idle"
		
		if action == actions.COLLECT_WATER:
			for resource : Resources in get_tree().get_nodes_in_group("resources"):
				if resource is Stream:
					resource.resource_storage += 1
					break
			action = actions.IDLE
			action_string = "idle"
		
		if action == actions.HEAL_VILLAGER:
			sick_villager.sickness -= 1
			action = actions.IDLE
			action_string = "idle"



func action_forest_chop():
	busy_days_left = 1
	action = actions.CHOP_TREE
	action_string = "chop"


func action_forest_grow():
	busy_days_left = 3
	action = actions.GROW_TREE
	action_string = "grow"


func action_crops_grow():
	busy_days_left = 2
	action = actions.GROW_CROPS
	action_string = "plant"

func action_harvest_crops():
	busy_days_left = 1
	action = actions.HARVEST_CROPS
	action_string = "harvest"


func action_collect_water():
	busy_days_left = 1
	action = actions.COLLECT_WATER
	action_string = "collect"


func action_heal_villager(villager):
	busy_days_left = 1
	sick_villager = villager
	action = actions.HEAL_VILLAGER
	action_string = "heal"



