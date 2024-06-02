class_name Villager extends NPC

# Survival variables
var hunger = 100
var thirst = 100
var warmth = 100

var total_health = 100
var health = 100

var sickness = 0

var days_busy = 0
var big_haul
var haul_resource

# Booleans
var is_hungry = false
var is_thirsty = false
var is_cold = false
var is_busy = false

const GHOST = preload("res://scenes/ghost.tscn")

# functions
func death():
	var new_ghost = GHOST.instantiate()
	new_ghost.id = id
	new_ghost.npc_name = npc_name
	new_ghost.global_position = global_position
	Singleton.ghosts.append(new_ghost)
	Singleton.main_node.add_child(new_ghost)
	Singleton.terminal_log.log_error(npc_name + " has died")
	Singleton.villagers.erase(self)
	queue_free()

func get_sick(days) :
	var sick_chance = 400 - hunger - thirst - warmth - health
	if randi_range(200, 400) < sick_chance :
		sickness += 2
	
	sickness += days

func do_action() :
	pass

func cancel_task():
	is_busy = false
	haul_resource = null

func day_pass(remove_hunger, remove_thirst, remove_warmth):

	# Update survival variables
	hunger -= remove_hunger
	thirst -= remove_thirst
	warmth -= remove_warmth
	
	# Check if villager is hungry, thirsty and cold
	if hunger < 20 and not is_hungry:
		is_hungry = true
		total_health -= 25
	else :
		is_hungry = false
		total_health += 25
	
	if thirst < 20 and not is_thirsty:
		is_thirsty = true
		total_health -= 25
	else :
		is_thirsty = false
		total_health += 25
	
	if warmth < 20  and not is_cold:
		is_cold = true
		total_health -= 25
	else :
		is_cold = false
		total_health += 25
	
	# Check if villager is sick
	if sickness > 0 :
		health -= 5
	else :
		health += 5
		get_sick(0)
	
	
	# Update villager survival variables
	if hunger > 100 :
		hunger = 100
	
	if thirst > 100 :
		thirst = 100
	
	if warmth > 100 :
		warmth = 100
	
	if total_health > 100 :
		total_health = 100
	
	if health > total_health :
		health = total_health
	
	
	# Kill villager if any survival variable are 0
	if hunger <= 0 or thirst <= 0 or warmth <= 0 or health <= 0:
		death()
		
		
	var smallest_resource
	var claimed_wood = 0
	var claimed_food = 0
	var claimed_water = 0
	var resource_difference
	
	for resource: Resources in get_tree().get_nodes_in_group("resources"):
		if resource is Forest:
			claimed_wood = resource.claimed_resources + resource.resources_in_stasis
		if resource is Crops:
			claimed_food = resource.claimed_resources
		if resource is Stream:
			claimed_water = resource.claimed_resources
	
	
	if Singleton.food + claimed_food < Singleton.water + claimed_water:
		if Singleton.food + claimed_food < Singleton.wood + claimed_wood:
			#food is smallest
			smallest_resource = Crops
		else:
			#wood is smallest
			smallest_resource = Forest
	elif Singleton.water + claimed_water < Singleton.wood + claimed_wood:
		#water is smallest
		smallest_resource = Stream
	else:
		#wood is smallest
		smallest_resource = Forest
		
		
	if not is_busy:
		for resource: Resources in get_tree().get_nodes_in_group("resources"):
			resource_difference = resource.resource_storage - resource.claimed_resource
			if typeof(resource) == typeof(smallest_resource): 
				if resource_difference > 0:
					if resource_difference >= 10:
						if resource_difference >= 15:
							if resource_difference >= 20:
								resource.resources_in_stasis += 5
								days_busy += 1
								big_haul += 5
							resource.resources_in_stasis += 5
							days_busy += 1
							big_haul += 5
						resource.resources_in_stasis += 10
						days_busy += 1
						is_busy = true
						big_haul += 10
						haul_resource = resource
					if resource_difference < 5:
						resource.claimed_resources = resource.resource_storage
					elif resource_difference < 10:
						resource.claimed_resources += 5
		
	if is_busy and big_haul == 20:
		big_haul = 0
		haul_resource.resources_in_stasis -= 20
		haul_resource.claimed_resources += 20
		is_busy = false
	if is_busy and big_haul == 15:
		big_haul = 0
		haul_resource.resources_in_stasis -= 15
		haul_resource.claimed_resources += 15
		is_busy = false
	if is_busy and big_haul == 15:
		big_haul = 0
		haul_resource.resources_in_stasis -= 10
		haul_resource.claimed_resources += 10
		is_busy = false
	days_busy -= 1

