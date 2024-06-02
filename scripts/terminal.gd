extends TextEdit


# Constants
const GHOST_DIRECTORY = "ghosts"
const VILLAGER_DIRECTORY = "villagers"
const GHOST_FILE_EXTENSION = ".gs"
const VILLAGER_FILE_EXTENSION = ".vl"

## Variables
# Caret variables
var last_caret_column: int

# Command variables
var command_list = ["help - print this", "ls - list files and directories", "pwd - print current directory", "cd <directory name> - change directory", "cat <file name> - print file contents"]
var current_directory: String = ""

@onready var log_node = $"../../TextBackground/LogContainer/Log"

func _ready():
	grab_focus()


func _on_text_changed():
	# User says to input
	if text.contains("\n"):
		text = text.replace("\n", "")
		log_node.add_log(text)
		entered_command()
		text = ""
	
	# Limit text length
	while len(text) > 17:
		text = text.erase(get_caret_column() - 1)
		set_caret_column(last_caret_column)
	
	# Store caret position
	last_caret_column = get_caret_column()


func _on_caret_changed():
	# Store caret position
	last_caret_column = get_caret_column()


func entered_command() -> void:
	var command = text.to_lower().strip_edges()
	if command == "help":
		print_help()
	
	elif command == "ls":
		if current_directory == GHOST_DIRECTORY:
			for ghost in Singleton.ghosts:
				log_node.add_log(ghost.npc_name + GHOST_FILE_EXTENSION)
		elif current_directory == VILLAGER_DIRECTORY:
			for villager in Singleton.villagers:
				log_node.add_log(villager.npc_name + VILLAGER_FILE_EXTENSION)
		else:
			log_node.add_log(GHOST_DIRECTORY)
			log_node.add_log(VILLAGER_DIRECTORY)
	
	elif command == "pwd":
		log_node.add_log("/" + current_directory)
	
	elif command.begins_with("cd "):
		command = command.lstrip("cd ")
		if len(command) == 0:
			log_node.log_error("cd requires name of directory. List directories and files with ls, use .. to go down a directory")
		else:
			if command == GHOST_DIRECTORY or command == "/" + GHOST_DIRECTORY:
				current_directory = GHOST_DIRECTORY
			elif command == VILLAGER_DIRECTORY or command == "/" + VILLAGER_DIRECTORY:
				current_directory = VILLAGER_DIRECTORY
			elif command == ".." or command == "/":
				current_directory = ""
			else:
				log_node.log_error("did not recognize directory. List directories and files with ls, use .. to go down a directory")
	
	elif command.begins_with("cd"):
		log_node.log_error("cd requires name of directory. List directories and files with ls, use .. to go down a directory")
	
	elif command.begins_with("cat "):
		command = command.lstrip("cat ")
		if len(command) == 0:
			log_node.log_error("cat requires name of file. List directories and files with ls")
		
		log_node.add_log(command)
		if command.ends_with(GHOST_FILE_EXTENSION) and current_directory == GHOST_DIRECTORY:
			var found_ghost := false
			for ghost in Singleton.ghosts:
				if command == ghost.npc_name.to_lower() + GHOST_FILE_EXTENSION:
					log_node.add_log("Name: " + ghost.npc_name)
					log_node.add_log("ID: " + str(ghost.id))
					# log_node.add_log("Currnet action: " + ghost.action) # need to implement -----------------------------------------------
					log_node.add_log("Action days left: " + str(ghost.busy_days_left))
					found_ghost = true
					break
				if not found_ghost:
					log_node.log_error("Could not find file")
		elif command.ends_with(VILLAGER_FILE_EXTENSION) and current_directory == VILLAGER_DIRECTORY:
			var found_villager := false
			for villager in Singleton.villagers:
				if command == villager.npc_name.to_lower() + VILLAGER_FILE_EXTENSION:
					log_node.add_log("Name: " + villager.npc_name)
					log_node.add_log("ID: " + str(villager.id))
					log_node.add_log("Health: " + str(villager.health) + " / " + str(villager.total_health))
					log_node.add_log("Hunger: " + str(villager.hunger))
					log_node.add_log("Thirst: " + str(villager.thirst))
					log_node.add_log("Warmth: " + str(villager.warmth))
					log_node.add_log("Is sick: " + str(villager.sickness > 0))
					found_villager = true
					break
				if not found_villager:
					log_node.log_error("Could not find file")
		else:
			log_node.log_error("Could not find file")
	
	elif command.begins_with("cat"):
		log_node.log_error("cat requires name of file. List directories and files with ls")
	
	elif command.begins_with("chop "):
		command = command.lstrip("chop ")
	
	elif command.begins_with("chop"):
		log_node.log_error("chop requires more arguments")
	
	else:
		log_node.log_error("Could not parse command")


func print_help() -> void:
	log_node.add_bb_log("[color=#ff82bd]Available commands:")
	for command in command_list:
		log_node.add_log(command)
