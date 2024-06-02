extends RichTextLabel


func _enter_tree():
	Singleton.terminal_log = self



func add_log(text_to_log: String) -> void:
	append_text("\n [color=#d74ac7]%s[/color]" % [text_to_log.replace("[", "[lb]")])


func log_error(text_to_log: String) -> void:
	append_text("\n [color=#ffb0bf]%s[/color]" % [text_to_log])


func add_bb_log(text_to_log) -> void:
	append_text("\n %s" % [text_to_log])
