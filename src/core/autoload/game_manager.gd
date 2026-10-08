## handles how many players, characters of each player, track selected and
## any other logic that "sets up" the game
extends Node

signal all_players_selected_character
signal load_finished
var path_to_load: NodePath

var loading_layer: PackedScene = preload("uid://c5yhmxdsx1p77")


## stores all predefined PlayerControls resources
var playerControls : Dictionary[PlayerControls, int] 

## updates whenever a player is added
var players_connected := 0

## an array containing all players and their attributes (id, character, controls, etc)
var player_list: Array[PlayerDefinition] = []

var is_loading = false

#region enums
enum SelectedCharacter {
	NONE,
	SERAPHIM,
	NYX,
	MUFFIN,
}

enum SelectedTrack {
	NONE, ## No track is selected
	TREE, ## Yggdrasil Tree
	SHIP, ## Baa Baa Battleship
}
#endregion

## updates when track is selected from track select
var current_track: SelectedTrack = SelectedTrack.NONE


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_player_controls()

## Will be used to read player input and see if another player has joined the game
func _input(event: InputEvent) -> void:
	for controls in  playerControls:
		if event.is_action(controls.ui_select) and playerControls[controls] == 0:
			playerControls[controls] = 1
			add_player(controls)
		
func _process(_delta: float) -> void:
	if is_loading:
		get_tree().paused = true
		var status: = ResourceLoader.load_threaded_get_status(path_to_load)
		
		# constantly get status on the thread until it is loaded the scene
		match status:
			ResourceLoader.THREAD_LOAD_LOADED:
				_finish_loading()

#region game setup
func load_player_controls() -> void:
	var p1_controls : PlayerControls = preload(ScenePaths.CONTROLS.p1)
	playerControls[p1_controls] = 0
	
	var p2_controls : PlayerControls = preload(ScenePaths.CONTROLS.p2)
	playerControls[p2_controls] = 0

func add_player(controls : PlayerControls) -> void:
	players_connected += 1
	print(controls)
	var new_player : PlayerDefinition = preload(ScenePaths.PLAYER.player_definition).duplicate()
	new_player.id = players_connected - 1
	new_player.controls = controls
	new_player.selected_character = SelectedCharacter.NONE
	new_player.character_select_position = 0
	new_player.character_select_pressed = false
	player_list.append(new_player)
	Events.on_player_added.emit(new_player.character_select_position, new_player.id, true)

func remove_player() -> void:
	players_connected -= 1
	player_list.pop_back()

## sets character num and character model scene in player scene
func set_character(character: SelectedCharacter, player : PlayerDefinition) -> void:
	player.selected_character = character

func remove_character(player : PlayerDefinition) -> void:
	player.selected_character = SelectedCharacter.NONE

func set_track(given_track: SelectedTrack) -> void:
	current_track = given_track
	print(SelectedTrack.keys()[given_track] + " selected!")

## check if all players have selected a character
func validate_character_select() -> bool:
	for player in player_list:
		if player.selected_character == SelectedCharacter.NONE:
			all_players_selected_character.emit(false)
			return false
		
	all_players_selected_character.emit(true)
	return true
#endregion

#region loading
func load_into_path(path: NodePath) -> void:
	is_loading = true
	set_path_to_load(path)
	
	var new_loading_screen = loading_layer.instantiate()
	add_child(new_loading_screen)
	
	# TODO find prettier way to access first child: new_loading_screen.get_child(0) 
	load_finished.connect(new_loading_screen.get_child(0).on_loading_finished)
	
	# when loading screen is fully in position, we can start the load request
	await new_loading_screen.get_child(0).loading_screen_ready
	start_load(path)

func set_path_to_load(path: NodePath) -> void:
	path_to_load = path

func start_load(path: NodePath) -> void:
	ResourceLoader.load_threaded_request(path, "", true)

func _finish_loading() -> void:
	var new_packed_scene: PackedScene = ResourceLoader.load_threaded_get(path_to_load)
	var new_scene = new_packed_scene.instantiate()
	load_finished.emit()
	
	# adds new the new scene and gets rid of old one
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = new_scene
#endregion
