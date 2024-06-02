extends AnimationPlayer
@onready var color_rect = $CanvasLayer/ColorRect
@onready var plague_sound = $PlagueSound



func _enter_tree():
	Singleton.plague_node = self

func activate_plague():
	play("plague")
	color_rect.visible = true
	plague_sound.play()
	

func _on_animation_finished(_anim_name):
	color_rect.visible = false
