class_name ResultsScreen extends Control

@onready var player_panel: PackedScene = preload("uid://mw4eni75dngb")
@onready var players_v_box: VBoxContainer = $ResultsMargin/VBoxContainer/PlayersMargin/PlayersVBox

## used to loop a tween for each player
var player_panel_array: Array[PlayerPanel] = []
var player_panel_offscreen_vector: Vector2 = Vector2(-2.5, 0)

var tween: Tween

# TODO Implement ranking logic to sort the player panel array by lowest time completed
## gets all players in the player_list and creates a panel for them
func _ready() -> void:
	Events.on_final_placement.connect(_create_new_player_panel)
#region DEBUG
#func _process(delta: float) -> void:
	#if Input.is_key_pressed(KEY_2):
		#var player_panel_instance: PlayerPanel = player_panel.instantiate()
		#players_v_box.add_child(player_panel_instance)
		#player_panel_array.append(player_panel_instance)
	#
	#if Input.is_key_pressed(KEY_3):
		#show_results_screen()
	#
	#if Input.is_key_pressed(KEY_4):
		#hide_results_screen()
#endregion

## creates a player panel with the selected character and sorts into placement_index
func _create_new_player_panel(player_id: int, placement_index : int) -> void:
	var player_panel_instance: PlayerPanel = player_panel.instantiate()
	players_v_box.add_child(player_panel_instance)
	players_v_box.move_child(player_panel_instance, placement_index)
	player_panel_instance.set_character_name(GameManager.player_list[player_id].selected_character)
	player_panel_instance.player_id = player_id
	GameManager.player_list[player_id].score + placement_index
	player_panel_instance.update_timer()
	player_panel_instance.set_placement_number(placement_index)
	player_panel_array.append(player_panel_instance)

#region Tweens
func show_results_screen() -> void:
	offset_transform_enabled = true
	show()
	
	_set_player_panels_offscreen()
	
	# tween header into view
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "offset_transform_position_ratio", Vector2.ZERO, 0.3)
	
	await tween.finished
	
	# tween player panels into view
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel()
	
	# tween each player with stagger delay
	for i in player_panel_array.size():
		player_panel_array[i].offset_transform_enabled = true
		player_panel_array[i].show()
		tween.tween_property(player_panel_array[i], "offset_transform_position_ratio", Vector2.ZERO, 0.3).set_delay(i * 0.08)

func hide_results_screen() -> void:
	offset_transform_enabled = true
	offset_transform_position_ratio = Vector2(-1, 0)
	hide()

func _set_player_panels_offscreen() -> void:
	for i in player_panel_array.size():
		player_panel_array[i].hide()
		player_panel_array[i].offset_transform_position_ratio = player_panel_offscreen_vector

func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
#endregion
