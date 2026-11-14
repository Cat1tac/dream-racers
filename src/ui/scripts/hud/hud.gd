class_name HUD extends Control

@onready var countdown: Label = %Countdown
@onready var results_screen: PackedScene = preload("uid://cj6n40p2vgfo7")
@onready var sfx: Node = $SFX
var instantiated_results_screen: ResultsScreen

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_results_screen: ResultsScreen = results_screen.instantiate()
	add_child(new_results_screen)
	new_results_screen.hide_results_screen()
	instantiated_results_screen = new_results_screen
	
	
	Events.on_get_countdown.connect(_update_countdown_text)
	Events.on_countdown_finished.connect(_countdown_finished)
	Events.on_race_over.connect(_race_over)

## NOTE DEBUG
#func _process(delta: float) -> void:
	#if Input.is_key_pressed(KEY_1):
		#Events.on_race_over.emit()

func _update_countdown_text(num : int, delay : int) -> void:
	await get_tree().create_timer((delay * 60 * get_process_delta_time()) / 60).timeout
	countdown.text = str(num)
	countdown.offset_transform_scale = Vector2.ZERO
	countdown.modulate = Color.WHITE
	_reset_tween()
	tween.tween_property(countdown, "offset_transform_scale", Vector2.ONE, (70 * 60 * get_process_delta_time()) / 60).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(countdown, "modulate", Color.TRANSPARENT, (70 * 60 * get_process_delta_time()) / 60)
	sfx.play_countdown_tick()
	
func _countdown_finished(delay : int) -> void:
	await get_tree().create_timer((delay * 60 * get_process_delta_time()) / 60).timeout
	countdown.text = "GO"
	
	countdown.offset_transform_scale = Vector2.ZERO
	countdown.modulate = Color.WHITE
	_reset_tween()
	tween.tween_property(countdown, "offset_transform_scale", Vector2.ONE, (60 * 60 * get_process_delta_time()) / 60).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(countdown, "modulate", Color.TRANSPARENT, (180 * 60 * get_process_delta_time()) / 60)
	
	sfx.play_countdown_go()
	#countdown.text = " "

func _race_over() -> void:
	countdown.offset_transform_scale = Vector2.ZERO
	countdown.modulate = Color.WHITE
	
	countdown.text = "Finish"
	
	_reset_tween()
	tween.tween_property(countdown, "offset_transform_scale", Vector2.ONE, (60 * 60 * get_process_delta_time()) / 60).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(countdown, "modulate", Color.TRANSPARENT, (180 * 60 * get_process_delta_time()) / 60)
	
	await tween.finished
	await get_tree().create_timer(1).timeout
	instantiated_results_screen.show_results_screen()
	
func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
