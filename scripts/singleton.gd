extends Node


var remaining_days = 50

var next_calamity = ""
var blizzard_days = 0
var temp_water = 0

var days_since_calamity: int = 10

var win_lose_animation_player: AnimationPlayer

# village storage
var wood = 10
var food = 10
var water = 10

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

var music1: AudioStreamPlayer
var music2: AudioStreamPlayer

func _ready():
	villagers = get_tree().get_nodes_in_group("villager") as Array[Villager]
	ghosts = get_tree().get_nodes_in_group("ghost") as Array[Ghost]


func end_day():
	days_since_calamity += 1
	print(music1.playing,"   ",music2.playing,"   ",days_since_calamity)
	if days_since_calamity <= 3 and not music2.playing:
		music2.play()
		music1.stop()
	elif days_since_calamity > 3 and not music1.playing:
		music1.play()
		music2.stop()
	
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
		win_lose_animation_player.play("win")
		terminal_log.add_log("You win!!!")
		terminal_log.add_log("You win!!!")
		terminal_log.add_log("You win!!!")
		terminal_log.add_log("I'm proud of you")
		terminal_log.add_log("From the bottom of my weary heart, thank you for playing")
	
	var temp_days = remaining_days % 10
	terminal_log.add_log(next_calamity + " coming in: " + str(temp_days) + " days")
	
	if blizzard_days == 0:
		stream.resource_storage += temp_water
		temp_water = 0
	
	
	
	
	# evenly distribute resources amonst villagers
	need_resource = len(villagers) - 1
	while food > 0 and need_resource > 0:
		villagers.shuffle()
		
		for villager: Villager in villagers:
			if food > 0 and villager.hunger < 100:
				food -= 1
				villager.hunger += 5
			else:
				need_resource -= 1
	need_resource = len(villagers) - 1
	while water > 0 and need_resource > 0:
		
		villagers.shuffle()
		
		for villager: Villager in villagers:
			if water > 0 and villager.thirst < 100:
				water -= 1
				villager.thirst += 5
			else:
				need_resource -= 1
	need_resource = len(villagers) - 1
	while wood > 0 and need_resource > 0:
		
		villagers.shuffle()
		for villager: Villager in villagers:
			if wood > 0 and villager.warmth < 100:
				wood -= 1
				villager.warmth += 5
			else:
				need_resource -= 1
	
	# update villagers at the end of the day
	for villager: Villager in villagers:
		villager.day_pass(randi_range(1, 10), randi_range(1, 10), randi_range(1, 10))
	
	for ghost: Ghost in ghosts:
		ghost.do_action()
	
	if villagers.size() <= 0:
		win_lose_animation_player.play("lose")
		terminal_log.add_log("Awww you lost :(")
		terminal_log.add_log("Restart and try again?")
		terminal_log.add_log("Despite how you did, thank you for playing")
		terminal_log.add_log("If you don't know what's going on I apologize, that is my fault")
		terminal_log.add_log("Play a couple more times, try the help commands if you don't understand how to navigate the files and checkup on how things are going")
		terminal_log.add_log("If you still don't understand please comment, it'd mean the world to me to grow better")


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
	print("playing calamity")
	days_since_calamity = 0
	if days_since_calamity <= 3 and not music2.playing:
		music2.play()
		music1.stop()
	
	if next_calamity == "Blizzard":
		crops.crops = 0
		for villager: Villager in villagers:
			if villager.goal_resource == stream:
				villager.cancel_task()
				villager.warmth -= 20
		blizzard_days = 5
		temp_water = stream.resource_storage
		stream.resource_storage = 0
		terminal_log.add_log("A Blizzard has struck! Our water has frozen, our crops died in the snow and we're cold!")
		blizzard_node.activate_blizzard()
	if next_calamity == "Plague":
		for villager: Villager in villagers:
			villager.get_sick(randi_range(3,7))
		terminal_log.add_log("A plague has fallen upon us! All our villagers are sick!")
		plague_node.activate_plague()
	if next_calamity == "Drought":
		crops.crops = 0
		for villager: Villager in villagers:
			if villager.goal_resource == stream:
				villager.cancel_task()
		stream.resource_storage = 0
		terminal_log.add_log("We've been hit by a drought! Our crops and water have dried up")
		drought_node.activate_drought()
	if next_calamity == "Thunderstorm":
		forest.trees = 0
		terminal_log.add_log("A thunderstorm! The forest has been destroyed!")
		thunderstorm_node.activate_thunderstorm()
