class_name Stream extends Resources
@onready var bucket_water = $BucketWater



func _enter_tree():
	Singleton.stream = self


func collect_water():
	generate_resource(5)
	bucket_water.play()
