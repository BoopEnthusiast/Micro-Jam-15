class_name Stream extends Resources


func _enter_tree():
	Singleton.stream = self


func collect_water():
	generate_resource(5)
