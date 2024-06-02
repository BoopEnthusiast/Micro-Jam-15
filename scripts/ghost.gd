class_name Ghost extends NPC

enum actions{CHOP_TREE, GROW_TREE, GROW_FOOD, COLLECT_WATER, HELP_VILLAGER, STATIONARY}
var busy_days_left = 0
var action = actions.STATIONARY

func do_action():
	if busy_days_left > 0:
		busy_days_left -= 1
	if busy_days_left == 0:
		if action == actions.CHOP_TREE:
			pass
			action = actions.STATIONARY
		if action == actions.GROW_TREE:
			pass
			action = actions.STATIONARY
		if action == actions.GROW_FOOD:
			pass
			action = actions.STATIONARY
		if action == actions.COLLECT_WATER:
			pass
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

func action_food_grow():
	var busy_days_left = 1
	action = actions.GROW_FOOD

func action_collect_water():
	var busy_days_left = 1
	action = actions.COLLECT_WATER

func action_help_villager():
	var busy_days_left = 1
	action = actions.HELP_VILLAGER

