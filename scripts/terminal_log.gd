extends RichTextLabel


func add_log(text_to_add: String) -> void:
	print(text)
	append_text("\n %s" % [text_to_add.replace("[", "[lb]")])
	print(text)
