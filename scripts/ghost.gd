class_name Ghost extends NPC

var busy_days_left = 0

func do_action() :
	if busy_days_left > 0:
		busy_days_left -= 1

func forest_chop() :
	var busy_days_left = 1

func forest_grow():
	var busy_days_left = 1

func food_grow() :
	var busy_days_left = 1

