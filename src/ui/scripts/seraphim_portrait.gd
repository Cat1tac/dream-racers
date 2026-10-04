extends TextureButton

func _pressed() -> void:
	GameManager.set_character(GameManager.SelectedCharacter.SERAPHIM)
