extends InfoScreen
@onready var button: Button = %Button
@onready var keyboard_button: Button = %KeyboardButton

@onready var controller_controls: TextureRect = %ControllerControls
@onready var keyboard_controls: TextureRect = %KeyboardControls

func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	match get_viewport().gui_get_focus_owner():
		button:
			controller_controls.show()
			keyboard_controls.hide()
		keyboard_button:
			keyboard_controls.show()
			controller_controls.hide()
