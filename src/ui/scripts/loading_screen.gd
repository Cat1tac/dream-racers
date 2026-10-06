extends Control

signal loading_screen_ready
## emit when loading screen gone to instantiate ui and start cutscene
signal loading_screen_gone

var tween: Tween

func _init() -> void:
	offset_transform_enabled = true
	offset_transform_position_ratio = Vector2(0,1)
	
	screen_enter()
	await tween.finished
	loading_screen_ready.emit()

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
	queue_free()

func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
