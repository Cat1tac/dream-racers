class_name CharacterButton extends TextureRect
@export var indicators : Array[TextureRect]
@export var character_model : PackedScene
@export var character_enum : GameManager.SelectedCharacter
@export var character_resource : Stats
@export var nametag_name : String

var player_ids_on_box : Array[int]

func _ready() -> void:
	for indicator in indicators:
		indicator.visible = false

func unhide_indicator(id : int) -> void:
	indicators[id].visible = true

func hide_indicator(id : int) -> void:
	indicators[id].visible = false
	
func selected(id : int) -> void:
	indicators[id].material.set_shader_parameter("selected", true)
	
func unselect(id : int) -> void:
	indicators[id].material.set_shader_parameter("selected", false)
