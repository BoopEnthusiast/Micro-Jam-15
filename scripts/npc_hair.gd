class_name NPCHair extends Sprite2D


func _on_npc_ready_done():
	texture = texture.duplicate()
	var tex: AtlasTexture = texture as AtlasTexture
	tex.region.position.y = (get_parent().id - 1) * 8
