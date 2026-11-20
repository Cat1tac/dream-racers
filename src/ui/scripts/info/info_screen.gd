class_name InfoScreen extends Control
@onready var main_panel: PanelContainer = %MainPanel
@onready var description_panel: PanelContainer = %DescriptionPanel
@onready var media_panel: PanelContainer = %MediaPanel
@onready var sfx: Node = $SFX

var _exit_started : bool = false
signal screen_return
var tween : Tween

func _ready() -> void:
	_set_offscreen()
	_enter_animation()
	get_node("%Button").grab_focus()

func _input(event: InputEvent) -> void:
	for player : PlayerDefinition in GameManager.player_list:
		if player.is_cpu:
			return
		if Input.is_action_just_pressed(player.controls.actions["backwards"]) and not _exit_started:
				_exit_animation()
				_exit_started = true
				sfx.play_ui_back()
				await tween.finished
				screen_return.emit()
				queue_free()
			
		elif Input.is_action_just_pressed(player.controls.actions["up"]):
			sfx.play_ui_up()
		elif Input.is_action_just_pressed(player.controls.actions["down"]):
			sfx.play_ui_down()

func _set_offscreen() -> void:
	main_panel.offset_transform_enabled = true
	description_panel.offset_transform_enabled = true
	media_panel.offset_transform_enabled = true
	
	main_panel.offset_transform_position_ratio = Vector2(-1, 0)
	description_panel.offset_transform_position_ratio = Vector2(0, 1)
	media_panel.offset_transform_scale = Vector2.ZERO

func _enter_animation() -> void:
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(main_panel, "offset_transform_position_ratio", Vector2.ZERO, 0.3)
	tween.tween_property(description_panel, "offset_transform_position_ratio", Vector2.ZERO, 0.4)
	tween.tween_property(media_panel, "offset_transform_scale", Vector2.ONE, 0.4)

func _exit_animation() -> void:
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(main_panel, "offset_transform_position_ratio", Vector2(-1, 0), 0.3)
	tween.tween_property(description_panel, "offset_transform_position_ratio", Vector2(0, 1), 0.3)
	tween.tween_property(media_panel, "offset_transform_scale", Vector2.ZERO, 0.4)

func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
