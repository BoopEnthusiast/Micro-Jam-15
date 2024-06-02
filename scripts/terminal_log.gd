extends RichTextLabel


func add_log(text_to_add: String) -> void:
	append_text("\n %s" % [text_to_add.replace("[", "[lb]")])


func log_error(text_to_log: String) -> void:
	append_text("\n [color=red]%s[/color]" % [text_to_log])
