class_name Ghost extends NPC

enum actions{CHOP_TREE, GROW_TREE, GROW_CROPS, HARVEST_CROPS, COLLECT_WATER, HEAL_VILLAGER, IDLE}
var busy_days_left = 0
var action = actions.IDLE
var action_string = "idle"
var sick_villager

func do_action():
	if busy_days_left > 0:
		busy_days_left -= 1
	if busy_days_left == 0 and action != actions.IDLE:
		global_position = Singleton.tele_home.global_position
		navigation.find_new_path()
		match action:
			actions.CHOP_TREE:
				Singleton.forest.chop_tree()
			actions.GROW_TREE:
				Singleton.forest.trees += 1
			actions.GROW_CROPS:
				Singleton.crops.crops += 1
			actions.HARVEST_CROPS:
				Singleton.crops.harvest_crops()
			actions.COLLECT_WATER:
				Singleton.stream.resource_storage += 1
			actions.HEAL_VILLAGER:
				sick_villager.sickness -= 1
		action = actions.IDLE
		action_string = "idle"



func action_forest_chop():
	busy_days_left = 1
	action = actions.CHOP_TREE
	action_string = "chop"
	global_position = Singleton.tele_forest.global_position
	navigation.find_new_path()


func action_forest_grow():
	busy_days_left = 3
	action = actions.GROW_TREE
	action_string = "grow"
	global_position = Singleton.tele_forest.global_position
	navigation.find_new_path()


func action_crops_grow():
	busy_days_left = 2
	action = actions.GROW_CROPS
	action_string = "plant"
	global_position = Singleton.tele_crop.global_position
	navigation.find_new_path()

func action_harvest_crops():
	busy_days_left = 1
	action = actions.HARVEST_CROPS
	action_string = "harvest"
	global_position = Singleton.tele_crop.global_position
	navigation.find_new_path()


func action_collect_water():
	busy_days_left = 1
	action = actions.COLLECT_WATER
	action_string = "collect"
	global_position = Singleton.tele_water.global_position
	navigation.find_new_path()


func action_heal_villager(villager):
	busy_days_left = 1
	sick_villager = villager
	action = actions.HEAL_VILLAGER
	action_string = "heal"



