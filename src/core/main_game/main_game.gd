class_name MainGame extends Node
## Main entry point for the game
## Responsible for setting up the World layers and coordinating high-level systems

@export var playerControls : Array[PlayerControls]
#test
# Future (main menu): Load test level for prototype
const TESTING_SCENE : String = "uid://c0i43c0ijhpqa"
const PLAYER_SCENE_UID : String = ScenePaths.PLAYER.player
const PLAYER_VIEW_UID : String = "uid://bqy6omuyhur8a"
const LOCAL_PLAYER_HUD : String = "uid://y05frtm4j8pc"
const DEBUG_MENU : String = "uid://csverqobfpghe"
#const TEST_TRACK_1 :String = ScenePaths.TRACKS.test_track_1

var players : Array[Player]

var _current_level : BaseLevel = null

# Game World root nodes
@onready var level_root: Node3D = %LevelRoot
@onready var entity_root: Node3D = %EntityRoot
@onready var effect_root: Node3D = %EffectRoot

# UI Root nodes 
@onready var hud_root: Control = %HudRoot
@onready var pause_root: Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot
@onready var debug_root: Control = %DebugRoot

# HUD element nodes
@onready var speedometer_uid: String = "uid://cebpjaeco7bpy"

func _ready() -> void:
	_init_players(GameManager.players_connected)
	# There will be a track set up script that will contain all the info on setting up the track
	#Will contain the selected track, selected character, what control scheme to use for each character, and any track specific settings 
	load_level(_get_selected_track_uid())
	_load_debug()
	#_load_hud()

#region Get what players selected
func _get_selected_track_uid() -> String:
	return ScenePaths.TRACKS[GameManager.current_track]

func _get_character_packed_scene(character_uid : String) -> PackedScene:	 
	var character_scene : PackedScene = ResourceLoader.load(character_uid) as PackedScene
	if character_scene == null:
		push_error("Could not load player scene: " + PLAYER_SCENE_UID)
		return
	return character_scene
	
#endregion

#region load players and track
## Instantiates the players and adds it to the local player subview
func _init_players(playerAmount : int = 1) -> void:
	var local_player_view : LocalMultiplayerView = _init_local_player_view(playerAmount)
	 
	var player_scene : PackedScene = ResourceLoader.load(PLAYER_SCENE_UID) as PackedScene
	if player_scene == null:
		push_error("Could not load player scene: " + PLAYER_SCENE_UID)
		return
	
	
	var local_huds : Array[Local_Player_HUD]
	for i in playerAmount:
		var player : Player = player_scene.instantiate() as Player
		if player == null:
			push_error("Loaded player scene does not extend player or DNE: " + PLAYER_SCENE_UID)
			return
		player.playerId = i
		player.kart_model_scene = _get_character_packed_scene(ScenePaths.CHARACTERS[GameManager.player_list[i].selected_character])#GameManager.player_list[i].selected_character_model
		player.playerControls = playerControls[i]
		players.append(player)
		local_huds.append(_init_local_hud(i))
		
	local_player_view.add_players(players)
	local_player_view.add_local_huds(local_huds)

## Loads each player hud with speedometer
func _init_local_hud(id : int) -> Local_Player_HUD:
	var local_player_hud_scene : PackedScene = ResourceLoader.load(LOCAL_PLAYER_HUD) as PackedScene
	if local_player_hud_scene == null:
		push_error("Could not load local player hud scene " + LOCAL_PLAYER_HUD)
		return
		
	var local_hud : Local_Player_HUD = local_player_hud_scene.instantiate() as Local_Player_HUD
	if local_hud == null:
		push_error("Loaded scene does not exist " + LOCAL_PLAYER_HUD)
		return 
		
	local_hud.set_ids(id)
	return local_hud

## Returns instantiated player view and adds it to the entity layer
func _init_local_player_view(playerAmount : int = 1) -> LocalMultiplayerView:
	var local_player_view_scene : PackedScene = ResourceLoader.load(PLAYER_VIEW_UID) as PackedScene
	if local_player_view_scene == null:
		push_error("Could not load local player view scene " + PLAYER_VIEW_UID)
		return
		
	var local_player_view : LocalMultiplayerView = local_player_view_scene.instantiate() as LocalMultiplayerView
	if local_player_view == null:
		push_error("Loaded scene does not exist" + PLAYER_VIEW_UID)
		
	local_player_view.update_viewports(playerAmount)
	entity_root.add_child(local_player_view)
	return local_player_view
	
## Called for load a level scene
## NOTE: The input level_scene must extend BaseLevel
func load_level(level_scene : String) -> void:
	# Make sure this is called during idle time
	_deferred_load_level.call_deferred(level_scene)

func _deferred_load_level(level_scene_uid : String) -> void:
	if _current_level != null:
		_current_level.queue_free()
		_current_level = null
	
	# Allow the old level to finish freeing before adding the new one
	await get_tree().process_frame
	
	var new_level_packed : PackedScene =\
		ResourceLoader.load(level_scene_uid, "PackedScene") as PackedScene
	if new_level_packed == null:
		push_error("Loaded level is not of type level or does not exist")
		return
		
	_current_level = new_level_packed.instantiate() as BaseLevel
	if _current_level == null:
		push_error("loaded level is not of type Level or does not exist")
		return
		# FUTURE (main menu): SHould have a fall back scene
	
	level_root.add_child(_current_level)
	
	#Allow level to fully process before accessing it
	await get_tree().process_frame
	for player in players:
		_place_player_at_level_spawn(player)

func _place_player_at_level_spawn(player : Player) -> void:
	if player == null:
		push_error("Cannot place player in level because it is null")
		return
	if _current_level == null:
		push_error("Cannot place player into level because level is null")
		return
	
	var playerLevelSetup : Array[Marker3D] = _current_level.get_default_player_spawn()
	player.global_position = playerLevelSetup[player.playerId].global_position
	player.rotation = playerLevelSetup[player.playerId].rotation
	player.current_track = _current_level
#endregion


func _load_hud() -> void: # TODO clean up instantiation code
	var speedometer: PackedScene = ResourceLoader.load(speedometer_uid)
	var speedometer_instance := speedometer.instantiate()
	hud_root.add_child(speedometer_instance)

func _load_debug() -> void:
	var debug_menu : PackedScene =\
		ResourceLoader.load(DEBUG_MENU, "PackedScene") as PackedScene
	if debug_menu == null:
		push_error("debug menu does not exist")
		return
		
	var debug_menu_instance := debug_menu.instantiate() as Control
	if debug_menu_instance == null:
		push_error("debug_menu_instance does not exist")
		return
		# FUTURE (main menu): SHould have a fall back scene
	
	debug_root.add_child(debug_menu_instance)
