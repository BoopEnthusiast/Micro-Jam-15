class_name Ghost extends NPC

var busy_days_left = 0

func do_action() :
	if busy_days_left > 0:
		busy_days_left -= 1

func action_forest_chop() :
	busy_days_left = 1

func action_forest_grow():
	busy_days_left = 1

func action_food_grow() :
	busy_days_left = 1

