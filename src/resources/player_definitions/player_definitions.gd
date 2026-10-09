## a class that defines a player's attributes (id, controls, selected character, etc.) 
##
## The "representation" of a Player.
class_name PlayerDefinition extends Resource

@export var id : int
@export var controls : PlayerControls
@export var selected_character : int
@export var character_select_position : int
@export var character_select_pressed : bool
