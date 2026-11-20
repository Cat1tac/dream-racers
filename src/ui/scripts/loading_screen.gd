extends Control

signal loading_screen_ready
## emit when loading screen gone to instantiate ui and start cutscene
signal loading_screen_gone

enum LoadingScreenType {
	MAIN,
	INFO
}

var current_lst : LoadingScreenType = LoadingScreenType.MAIN
@onready var key_art_screen: TextureRect = $KeyArtScreen
@onready var info_screen: ColorRect = $InfoScreen
@onready var question_label: Label = $InfoScreen/QuestionLabel

var tween: Tween

func _ready() -> void:
	offset_transform_enabled = true
	offset_transform_position_ratio = Vector2(0,1)
	
	get_tree().call_group("LoadingScreens", "hide")
	
	screen_enter()
	
	match current_lst:
		LoadingScreenType.MAIN:
			key_art_screen.show()
		LoadingScreenType.INFO:
			info_screen.show()
			await tween.finished
			_info_screen_tween()
	
	await tween.finished
	loading_screen_ready.emit()

#func _ready() -> void:


func screen_enter() -> void:
	_reset_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "offset_transform_position_ratio", Vector2(0,0), 1)

func screen_exit() -> void:
	_reset_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "offset_transform_position_ratio", Vector2(0,-1), 2)

## connects to [code]_finish_loading()[/code], the screen exits and deletes itself
func on_loading_finished() -> void:
	screen_exit()
	
	GameManager.is_loading = false
	get_tree().paused = false
	
	await tween.finished
	loading_screen_gone.emit()
	get_parent().queue_free()

func set_loading_screen_type(type : int) -> void:
	current_lst = type as LoadingScreenType

func _info_screen_tween() -> void:
	print("speen")
	question_label.offset_transform_enabled = true
	_reset_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(question_label, "offset_transform_rotation", deg_to_rad(360), 1)


func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
