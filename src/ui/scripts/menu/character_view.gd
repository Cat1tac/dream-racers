class_name CharacterView extends PanelContainer

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
var current_model_packed_scene : PackedScene
var model_instance : Model

## Removes previous instance of model and adds in new instance
func set_model_in_viewport(model : Model, id : int) -> void:
	remove_model_in_viewport()
	sub_viewport.add_child(model)
	model_instance = model
	model_instance.global_position += Vector3.RIGHT * -3.312 * id 

## Removes instance of model in viewport
func remove_model_in_viewport() -> void:
	for child in sub_viewport.get_children():
		if child is Model:
			sub_viewport.remove_child(child)
			child.queue_free()
	current_model_packed_scene = null
	model_instance = null
