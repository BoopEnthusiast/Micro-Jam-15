class_name Resources extends Area2D


var resource_storage = 0
var claimed_resources = 0

func generate_resource(resource_value):
	resource_storage += resource_value

