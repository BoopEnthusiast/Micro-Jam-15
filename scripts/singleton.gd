extends Node


var remaining_days = 50

var next_calamity = ""
var blizzard_days = 0
var temp_water = 0


# village storage
var wood = 0
var food = 0
var water = 0

var villagers: Array
var ghosts: Array
var forest: Forest
var crops: Crops
var stream: Stream

var main_node: Node2D

var terminal_log: RichTextLabel

var tele_water: Marker2D
var tele_crop: Marker2D
var tele_forest: Marker2D
var tele_home: Marker2D

var blizzard_node: GPUParticles2D
var thunderstorm_node: GPUParticles2D
var drought_node: AnimationPlayer
var plague_node: AnimationPlayer

func _ready():
	villagers = get_tree().get_nodes_in_group("villager") as Array[Villager]
	ghosts = get_tree().get_nodes_in_group("ghost") as Array[Ghost]


func end_day():
	villagers = get_tree().get_nodes_in_group("villager") as Array[Villager]
	ghosts = get_tree().get_nodes_in_group("ghost") as Array[Ghost]
	var need_resource: int
	
	blizzard_days -= 1
	if remaining_days > 0:
		remaining_days -= 1
		if remaining_days % 10 == 9:
			random_calamity()
		if remaining_days != 50 and remaining_days % 10 == 0:
			play_calamity()
	else:
		pass # end game win
	
	var temp_days = remaining_days % 10
	terminal_log.add_log(next_calamity + " coming in: " + str(temp_days) + " days")
	
	if blizzard_days == 0:
		stream.resource_storage += temp_water
		temp_water = 0
	
	
	
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
	
	for ghost: Ghost in ghosts:
		ghost.do_action()
	
	wood += forest.claimed_resources
	food += crops.claimed_resources
	water += stream.claimed_resources
	
	forest.claimed_resources = 0
	crops.claimed_resources = 0
	stream.claimed_resources = 0


func random_calamity():
	var random_num = randi_range(1,4)
	if random_num == 1:
		next_calamity = "Blizzard"
	if random_num == 2:
		next_calamity = "Plague"
	if random_num == 3:
		next_calamity = "Drought"
	if random_num == 4:
		next_calamity = "Thunderstorm"
	terminal_log.add_log("Incoming calamity: " + next_calamity)

func play_calamity():
	if next_calamity == "Blizzard":
		crops.crops = 0
		for villager: Villager in villagers:
			if villager.haul_resource == stream:
				villager.cancel_task()
				villager.warmth -= 20
		stream.resources_in_stasis = 0
		blizzard_days = 5
		temp_water = stream.resource_storage
		stream.resource_storage = 0
		terminal_log.add_log("A Blizzard has struck! Our water has frozen, our crops died in the snow and we're cold!")
	if next_calamity == "Plague":
		for villager: Villager in villagers:
			villager.get_sick(randi_range(3,7))
		terminal_log.add_log("A plague has fallen upon us! All our villagers are sick!")
	if next_calamity == "Drought":
		crops.crops = 0
		for villager: Villager in villagers:
			if villager.haul_resource == stream:
				villager.cancel_task()
		stream.resource_storage = 0
		stream.resources_in_stasis = 0
		terminal_log.add_log("We've been hit by a drought! Our crops and water have dried up")
	if next_calamity == "Thunderstorm":
		forest.trees = 0
		terminal_log.add_log("A thunderstorm! The forest has been destroyed!")
