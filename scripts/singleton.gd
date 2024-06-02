extends Node


var remaining_days = 50

# village storage
var wood = 0
var food = 0
var water = 0

var villagers: Array
var ghosts: Array

func _ready():
	villagers = get_tree().get_nodes_in_group("villager") as Array[Villager]
	ghosts = get_tree().get_nodes_in_group("ghost") as Array[Ghost]


func end_day():
	villagers = get_tree().get_nodes_in_group("villager") as Array[Villager]
	ghosts = get_tree().get_nodes_in_group("ghost") as Array[Ghost]
	var need_resource: int
	
	if villagers.size() <= 0:
		pass # end game lose
	
	# evenly distribute resources amonst villagers
	while food > 0 and need_resource > 0:
		need_resource = len(villagers)
		villagers.shuffle()
		
		for villager: Villager in villagers:
			if food > 0 and villager.hunger < 100:
				food -= 1
				villager.hunger += 5
			if villager.hunger >= 100:
				need_resource -= 1
	
	while water > 0 :
		need_resource = len(villagers)
		villagers.shuffle()
		
		for villager: Villager in villagers:
			if water > 0 and villager.thirst < 100:
				water -= 1
				villager.thirst += 5
			if villager.thirst >= 100:
				need_resource -= 1
	
	while wood > 0 :
		need_resource = len(villagers)
		villagers.shuffle()
		for villager: Villager in villagers:
			if wood > 0 and villager.warmth < 100:
				wood -= 1
				villager.warmth += 5
			if villager.warmth >= 100:
				need_resource -= 1
	
	# update villagers at the end of the day
	for villager: Villager in villagers:
		villager.day_pass(randi_range(1, 10), randi_range(1, 10), randi_range(1, 10))
	
	if remaining_days > 0:
		remaining_days -= 1
		if remaining_days % 10 == 9:
			random_calamity()
		if remaining_days != 50 and remaining_days % 10 == 0:
			play_calamity()
	else:
		pass # end game win


func random_calamity():
	pass
	#Blizzard - water become frozen for x days, all crops die
	#Plague - random numkber of villagers get sick for x days
	#Drought - all crops die, all water stores are removed
	#Thunderstorm - random number of trees are removed

func play_calamity():
	pass
