## a class that defines a player's controls
class_name PlayerControls extends Resource

@export var actions : Dictionary[String, String] = {
	"forward" : "",
	"backwards" : "",
	"right" : "",
	"left" : "",
	"up" : "",
	"down" : "",
	"drift" : "",
	"spin" : "",
	"store" : "",
	"start" : "",
	"leave" : ""
}

## Creates new actions from base control scheme
func duplicate_controls(id : int) -> void:
	for input in InputMap.get_actions(): # gets all actions in inputs
		if input.match("controller*"):  # matches actions with controller suffix
			var new_action : String = str(id) + "_" + input # creates new unique action using id
			InputMap.add_action(new_action) # adds action to InputMap
			for event : InputEvent in InputMap.action_get_events(input): # gets all events in original action
				var duplicate_event : InputEvent = event.duplicate() # duplicates event (otherwise would change originals mapping)
				duplicate_event.device = id # sets the events to new devices id
				InputMap.action_add_event(new_action, duplicate_event) # adds event to the action
	
			actions[input.get_slice("_", 1)] = new_action # stores action strings in the action dictionary
