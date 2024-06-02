class_name Forest extends Resources


var trees = 5


func _enter_tree():
	Singleton.forest = self


func chop_tree():
	trees -= 1
	generate_resource(randi_range(4,6))
