extends AnimationPlayer
@onready var color_rect = $CanvasLayer/ColorRect



func _enter_tree():
	Singleton.plague_node = self

func activate_plague():
	play("plague")
	color_rect.visible = true

func _on_animation_finished(anim_name):
	color_rect.visible = false
