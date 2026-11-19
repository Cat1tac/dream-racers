class_name CharacterView extends PanelContainer

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
var current_model_packed_scene : PackedScene
var model_instance : Model
@export var stats_page: ColorRect
@export var name_tag : Label
@export var stat_bars : Array[ProgressBar]

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
	
func toggle_stats() -> void:
	stats_page.visible = !stats_page.visible
	
func set_stats(character_stats : Stats) -> void:
	stat_bars[0].value = (character_stats.speed + 1)/2
	stat_bars[1].value = (character_stats.acceleration + 1)/2
	stat_bars[2].value = ((character_stats.max_steering_angle_fast + character_stats.max_steering_angle_slow)/2 + 1)/2
	stat_bars[3].value = (character_stats.weight + 1)/2
	stat_bars[4].value = ((character_stats.boost_top_speed + character_stats.boost_time)/2 + 1)/2
	
func set_nametag(name:String) -> void:
	name_tag.text = name
	
