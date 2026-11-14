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

## Score determined by current lap * total checkpoints + current checkpoint index
var score : float = 0.0
var completion_time : float = 99.99
