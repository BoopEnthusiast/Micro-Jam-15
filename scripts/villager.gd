class_name Villager extends NPC

# Survival variables
var hunger = 100
var thirst = 100
var warmth = 100

var total_health = 100
var health = 100

var sickness = 0

var days_busy = 0
var goal_resource = Singleton.forest

# Booleans
var is_hungry = false
var is_thirsty = false
var is_cold = false
var is_busy = 0
var collecting_from: Resources
var collecting_amount: int

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
		return
	
	if is_busy <= 0:
		var priority_resource = Singleton.forest
		var secondary_resource = Singleton.stream
		var tertiary_resource = Singleton.crops
		
		var wa = Singleton.water
		var wo = Singleton.wood
		var fo = Singleton.food
		
		if wa == wo and wo == fo:
			priority_resource = Singleton.forest
			secondary_resource = Singleton.stream
			tertiary_resource = Singleton.crops
		if fo > wa and fo > wo:
			if wo > wa:
				priority_resource = Singleton.stream
				secondary_resource = Singleton.forest
				tertiary_resource = Singleton.crops
			else:
				priority_resource = Singleton.forest
				secondary_resource = Singleton.stream
				tertiary_resource = Singleton.crops
		if wa > fo and wa > wo:
			if wo > fo:
				priority_resource = Singleton.crops
				secondary_resource = Singleton.forest
				tertiary_resource = Singleton.stream
			else:
				priority_resource = Singleton.forest
				secondary_resource = Singleton.crops
				tertiary_resource = Singleton.stream
		if wo > wa and wo > fo:
			if wa > fo:
				priority_resource = Singleton.crops
				secondary_resource = Singleton.stream
				tertiary_resource = Singleton.forest
			else:
				priority_resource = Singleton.stream
				secondary_resource = Singleton.crops
				tertiary_resource = Singleton.forest
		
		if priority_resource.resource_storage:
			claim_resource(priority_resource)
		elif secondary_resource.resource_storage:
			claim_resource(secondary_resource)
		else:
			claim_resource(tertiary_resource)
	else:
		is_busy -= 1
		if is_busy == 0:
			collecting_from.resource_storage -= collecting_amount
			collecting_from.claimed_resources -= collecting_amount
			if collecting_from is Forest:
				Singleton.wood += collecting_amount
			elif collecting_from is Stream:
				Singleton.water += collecting_amount
			elif collecting_from is Crops:
				Singleton.food += collecting_amount
			collecting_amount = 0
			collecting_from = null


func claim_resource(priority_resource: Resources) -> void:
	is_busy = 2
	if priority_resource.claimed_resources >= 10:
		priority_resource.claimed_resources = 10
		collecting_from = priority_resource
		collecting_amount = priority_resource.claimed_resources
	else:
		priority_resource.claimed_resources = priority_resource.resource_storage
		collecting_from = priority_resource
		collecting_amount = priority_resource.claimed_resources
	
