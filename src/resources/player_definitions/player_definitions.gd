## a class that defines a player's attributes (id, controls, selected character, etc.) 
##
## The "representation" of a Player.
class_name PlayerDefinition extends Resource

var id : int
var controls : PlayerControls
var selected_character : int
var character_select_position : int
var character_select_pressed : bool
var is_cpu : bool = false

var placement : Dictionary[String, Variant] = { 
	"distance_to_next_key_checkpoint" : 0.0,
	"current_key_checkpoint" : 0,
	"current_lap" : 0,
	}
