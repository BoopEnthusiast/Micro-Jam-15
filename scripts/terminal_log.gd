extends RichTextLabel


func add_log(text_to_add: String) -> void:
	append_text("\n %s" % text_to_add.replace("[", "[lb]"))
