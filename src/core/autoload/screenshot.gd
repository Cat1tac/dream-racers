extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(_event: InputEvent) -> void:
	if OS.is_debug_build() and Input.is_action_just_pressed('screenshot'):
		var img : Image = get_viewport().get_texture().get_image()
		print(img)
		img.save_png('res://assets/screenshot/yggdrasil.png')
