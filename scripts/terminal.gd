extends TextEdit


## Constants
# Directories
const GHOST_DIRECTORY = "ghosts"
const VILLAGER_DIRECTORY = "villagers"
const RESOURCE_DIRECTORY = "resources"

# File extensions
const GHOST_FILE_EXTENSION = ".gs"
const VILLAGER_FILE_EXTENSION = ".vl"
const RESOURCE_FILE_EXTENSION = ".rs"

# Misc
const RESROUCE_FILES = ["Forest", "Stream", "Crops", "Camp"]

## Variables
# Misc variables
var last_caret_column: int = 0
var current_ghost_index: int = 0
var last_text_length: int = 0

# Command variables
var help_command_list = ["help - print this", "help file - print file commands", "help ghost - print selected ghost commands", "end - end current day and progress actions"]
var file_command_list = ["ls - list files and directories", "pwd - print current directory", "cd <directory name> - change directory", "cat <file name> - print file contents"]
var ghost_command_list = ["selected - print selected ghost", "plant - plant a new tree", "chop - drop wood for villagers to collect", "sow - plant new crops", "harvest - drop food for villagers to collect", "bucket - drop water for villagers to collect, next - skip this ghost"]
var current_directory: String = ""

@onready var log_node = $"../../TextBackground/LogContainer/Log"
@onready var enter_sound = $EnterSound
@onready var keyboard_sounds = $KeyboardSounds


func _ready():
	grab_focus()


func _on_text_changed():
	
	
	# User says to input
	if text.contains("\n"):
		text = text.replace("\n", "")
		log_node.add_bb_log("[color=#a825ba]" + text + "[/color]")
		entered_command()
		text = ""
		enter_sound.play()
	else:
		print("playing_keyboard sound")
		keyboard_sounds.play()
	
	# Limit text length
	while len(text) > 17:
		text = text.erase(get_caret_column() - 1)
		set_caret_column(last_caret_column)
	
	# Store caret position
	last_caret_column = get_caret_column()
	last_text_length = len(text)


func _on_caret_changed():
	# Store caret position
	last_caret_column = get_caret_column()


func entered_command() -> void:
	var command = text.to_lower().strip_edges()
	
#region Help command
	if command == "help":
		print_help(help_command_list)
	elif command.begins_with("help "):
		command = command.trim_prefix("help ")
		if command == "file":
			print_help(file_command_list)
		elif command == "ghost":
			print_help(ghost_command_list)
		else:
			log_node.log_error("Could not find command list")
#endregion
#region Ls command
	elif command == "ls":
		if current_directory == GHOST_DIRECTORY:
			for ghost in Singleton.ghosts:
				log_node.add_log(ghost.npc_name + GHOST_FILE_EXTENSION)
		elif current_directory == VILLAGER_DIRECTORY:
			for villager in Singleton.villagers:
				log_node.add_log(villager.npc_name + VILLAGER_FILE_EXTENSION)
		elif current_directory == RESOURCE_DIRECTORY:
			for resource in RESROUCE_FILES:
				log_node.add_log(resource + RESOURCE_FILE_EXTENSION)
		else:
			log_node.add_log(GHOST_DIRECTORY)
			log_node.add_log(VILLAGER_DIRECTORY)
			log_node.add_log(RESOURCE_DIRECTORY)
#endregion
#region Pwd command
	elif command == "pwd":
		log_node.add_log("/" + current_directory)
#endregion
#region Cd command
	elif command.begins_with("cd "):
		command = command.trim_prefix("cd ")
		if len(command) == 0:
			log_node.log_error("cd requires name of directory. List directories and files with ls, use .. to go down a directory")
		else:
			if command == GHOST_DIRECTORY or command == "/" + GHOST_DIRECTORY:
				current_directory = GHOST_DIRECTORY
			elif command == VILLAGER_DIRECTORY or command == "/" + VILLAGER_DIRECTORY:
				current_directory = VILLAGER_DIRECTORY
			elif command == ".." or command == "/":
				current_directory = ""
			elif command == RESOURCE_DIRECTORY or command == "/" + RESOURCE_DIRECTORY:
				current_directory = RESOURCE_DIRECTORY
			else:
				log_node.log_error("did not recognize directory. List directories and files with ls, use .. to go down a directory")

	
	elif command.begins_with("cd"):
		log_node.log_error("cd requires name of directory. List directories and files with ls, use .. to go down a directory")
#endregion
#region Cat command
	elif command.begins_with("cat "):
		command = command.trim_prefix("cat ")
		if len(command) == 0:
			log_node.log_error("cat requires name of file. List directories and files with ls")
		
		if command == GHOST_DIRECTORY or command == VILLAGER_DIRECTORY or command == RESOURCE_DIRECTORY:
			log_node.log_error("That is a directory, not a file")
		
		elif command.ends_with(GHOST_FILE_EXTENSION) and current_directory == GHOST_DIRECTORY:
			var found_ghost := false
			for ghost in Singleton.ghosts:
				if command == ghost.npc_name.to_lower() + GHOST_FILE_EXTENSION:
					log_node.add_log("Name: " + ghost.npc_name)
					log_node.add_log("ID: " + str(ghost.id))
					log_node.add_log("Currnet action: " + ghost.action_string)
					log_node.add_log("Action days left: " + str(ghost.busy_days_left))
					found_ghost = true
					break
				if not found_ghost:
					log_node.log_error("Could not find ghost file, use ls to view files")
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
				log_node.log_error("Could not find villager file, use ls to view files")
		elif command.ends_with(RESOURCE_FILE_EXTENSION) and current_directory == RESOURCE_DIRECTORY:
			if command == "forest" + RESOURCE_FILE_EXTENSION:
				log_node.add_log("Trees: " + str(Singleton.forest.trees))
				log_node.add_log("Available wood: " + str(Singleton.forest.resource_storage))
			elif command == "stream" + RESOURCE_FILE_EXTENSION:
				log_node.add_log("Available water: " + str(Singleton.forest.resource_storage))
			elif command == "crops" + RESOURCE_FILE_EXTENSION:
				log_node.add_log("Crops: " + str(Singleton.crops.crops))
				log_node.add_log("Available food: " + str(Singleton.crops.resource_storage))
			elif command == "camp" + RESOURCE_FILE_EXTENSION:
				log_node.add_log("Food: " + str(Singleton.food))
				log_node.add_log("Water: " + str(Singleton.water))
				log_node.add_log("Warmth: " + str(Singleton.wood))
				log_node.add_log("Villagers alive: " + str(Singleton.villagers.size()))
				log_node.add_log("Ghosts unalive: " + str(Singleton.ghosts.size()))
			else:
				log_node.log_error("Could not find resource file, use ls to view files")
		else:
			log_node.log_error("Could not find file, use ls to view directories and files")
	
	elif command.begins_with("cat"):
		log_node.log_error("cat requires name of file. List directories and files with ls")
#endregion
#region Selected command
	elif command == "selected":
		if not is_end_of_ghosts():
			log_node.add_log(str(Singleton.ghosts[current_ghost_index].npc_name))
#endregion
#region Action commands 
	elif command == "plant":
		if not is_end_of_ghosts() and not ghost_is_doing_something():
			Singleton.ghosts[current_ghost_index].action_forest_grow()
			increase_ghost()
	
	elif command == "chop":
		if not is_end_of_ghosts() and not ghost_is_doing_something():
			Singleton.ghosts[current_ghost_index].action_forest_chop()
			increase_ghost()
	
	elif command == "sow":
		if not is_end_of_ghosts() and not ghost_is_doing_something():
			Singleton.ghosts[current_ghost_index].action_crops_grow()
			increase_ghost()
	
	elif command == "harvest":
		if not is_end_of_ghosts() and not ghost_is_doing_something():
			Singleton.ghosts[current_ghost_index].action_harvest_crops()
			increase_ghost()
	
	elif command == "bucket":
		if not is_end_of_ghosts() and not ghost_is_doing_something():
			Singleton.ghosts[current_ghost_index].action_collect_water()
			increase_ghost()
	
	elif command == "next":
		increase_ghost()
#endregion
#region End command
	elif command == "end":
		Singleton.end_day()
		current_ghost_index = 0
#endregion
#region Parse error
	else:
		log_node.log_error("Could not parse command")
#endregion


func print_help(which_help: Array) -> void:
	log_node.add_bb_log("[color=#ff82bd]Available commands:")
	for command in which_help:
		log_node.add_log(command)


func increase_ghost() -> void:
	if not is_end_of_ghosts():
		log_node.add_log(Singleton.ghosts[current_ghost_index].npc_name + " is now doing: " + Singleton.ghosts[current_ghost_index].action_string)
		current_ghost_index += 1


func is_end_of_ghosts() -> bool:
	if current_ghost_index >= Singleton.ghosts.size():
		log_node.log_error("You have given all available ghosts tasks")
		return true
	return false


func ghost_is_doing_something() -> bool:
	if Singleton.ghosts[current_ghost_index].action == Ghost.actions.IDLE:
		return false
	log_node.log_error("Ghost is already perfoming task, they can only wait")
	return true
