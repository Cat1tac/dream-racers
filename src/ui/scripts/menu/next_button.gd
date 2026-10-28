extends NavButton

@onready var line: ColorRect = $Line

var line_size: Vector2 = Vector2(5000, 5)

func enter() -> void:
	show()
	line.show()
	
	# line tween
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(line, "offset_transform_scale", line_size, 0.2)

	await tween.finished
	
	#Audio.play_ready_in()
	# button tween
	_reset_tween()
	offset_transform_enabled = true
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "offset_transform_position_ratio", Vector2.ZERO, 0.4)
	tween.tween_property(self, "offset_transform_scale", Vector2.ONE, 0.2)
	
	

func exit() -> void:
	# line tween
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(line, "offset_transform_scale", Vector2(0, 4), 0.1)
	
	await tween.finished
	line.hide()
	
	#Audio.play_ready_out()
	# button tween
	_reset_tween()
	offset_transform_enabled = true
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	tween.tween_property(self, "offset_transform_position_ratio", offscreen_vector_ratio, 0.5)
	tween.tween_property(self, "offset_transform_scale", Vector2.ONE, 0.1)
	
	# reset offset scale
	line.offset_transform_scale = Vector2.ONE
	

func _pressed() -> void:
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "offset_transform_scale", Vector2(1.5,1.5), 0.35)
	
	await tween.finished
	exit()
