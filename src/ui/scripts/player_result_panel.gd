class_name PlayerPanel extends PanelContainer

@onready var player_panel_label: Label = %PlayerPanelLabel
@onready var finish_time_label: Label = %FinishTimeLabel

func _init() -> void:
	pass

func _ready() -> void:
	# TODO create a way to store a unique time for each player
	Events.on_get_time.connect(_update_timer)

## sets based on player.selected_character in PlayerDefinition
func set_character_name(character: int) -> void:
	match character:
		1:
			player_panel_label.text = "Seraphim"
		2:
			player_panel_label.text = "Nyx"
		3: 
			player_panel_label.text = "Muffin"
		_: 
			player_panel_label.text = "Character Not Found"

func _update_timer(time : float) -> void:
	var minutes : int = int(time) / 60
	var seconds : int = int (time) % 60
	
	finish_time_label.text = "%02d:%02d" % [minutes, seconds]
