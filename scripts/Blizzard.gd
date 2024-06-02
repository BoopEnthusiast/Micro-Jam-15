extends GPUParticles2D
@onready var timer = $Timer


func activate_blizzard():
	emitting = true
	timer.start()

func _on_timer_timeout():
	pass # Replace with function body.
