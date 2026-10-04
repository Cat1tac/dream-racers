@abstract
class_name UIState
extends Control
## an abstract class for UI states with functions to transition between
## and signal transitions.

signal transition_state_to(newState: UIState)
signal transition_finished

# NOTE each UIState node must have "exit_left" "enter_left"
@export var transition_animations: AnimationPlayer

var forward_transition_buffer: float = 0.1
var backward_transition_buffer: float = 0.3

@export var next_state: UIState
@export var previous_state: UIState

func _ready() -> void:
	pass

func transition_to_state(newState: UIState) -> void:
	## exit old state
	if newState == next_state: # going forward a state
		transition_animations.play("exit_left")
	else: # going back a state
		transition_animations.play("exit_right")
	
	newState.show()
	
	## enter newState
	if newState == next_state: # going forward a state
		await get_tree().create_timer(forward_transition_buffer).timeout # transition buffer timer
		newState.transition_animations.play("enter_right")
	else: # going back a state
		await get_tree().create_timer(backward_transition_buffer).timeout
		newState.transition_animations.play("enter_left")
	
	# hide old screen
	await transition_animations.animation_finished
	hide()

##Sets focus to first button
func set_initial_focus(button : Control) -> void:
	button.grab_focus()
