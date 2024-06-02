extends GPUParticles2D
@onready var timer = $Timer
@onready var thunder = $Thunder


func _enter_tree():
	Singleton.thunderstorm_node = self

func activate_thunderstorm():
	emitting = true
	timer.start()
	thunder.play("thunderstorm")

func _on_timer_timeout():
	emitting = false
