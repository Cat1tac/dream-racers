class_name PlayerPanel extends PanelContainer

@onready var player_panel_label: Label = %PlayerPanelLabel
@onready var finish_time_label: Label = %FinishTimeLabel
@onready var placement_number: TextureRect = $MarginContainer/HBoxContainer/PlacementNumber

@export var placement_numbers: Array[CompressedTexture2D]

var player_id : int

func _init() -> void:
	pass

## sets based on player.selected_character in PlayerDefinition
func set_character_name(character: int) -> void:
	match character:
		1:
			player_panel_label.text = "Seraphim"
		2:
			player_panel_label.text = "Nyx"
		3: 
			player_panel_label.text = "Chambo"
		_: 
			player_panel_label.text = "Character Not Found"

func update_timer() -> void:
	var time : float = GameManager.player_list[player_id].completion_time
	var minutes : int = int(time) / 60
	var seconds : int = int (time) % 60
	finish_time_label.text = "%02d:%02d" % [minutes, seconds]

func set_placement_number(placement_index : int) -> void:
	placement_number.texture = placement_numbers[placement_index + 1]
