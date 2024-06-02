extends Node


var remaining_days = 50
var wood
var food
var water


func end_day():
	for villager: Villager in get_tree().get_nodes_in_group("villager"):
		villager.day_pass(randi_range(1, 10), randi_range(1, 10), randi_range(1, 10))


