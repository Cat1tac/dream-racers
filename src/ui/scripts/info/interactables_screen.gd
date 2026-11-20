extends InfoScreen
# buttons
@onready var button: Button = %Button
@onready var small_energy_button: Button = %SmallEnergyButton
@onready var big_energy_button: Button = %BigEnergyButton
@onready var big_catcher_button: Button = %BigCatcherButton

# text
@onready var header: Label = $VBoxContainer/DescriptionPanel/DescriptionMargin/DescriptionVBox/DescriptionHeader
@onready var body: Label = $VBoxContainer/DescriptionPanel/DescriptionMargin/DescriptionVBox/DescriptionBody


func _process(_delta: float) -> void:
	match get_viewport().gui_get_focus_owner():
		button:
			_set_dreamcatcher_text()
		small_energy_button:
			_set_small_energy_text()
		big_energy_button:
			_set_big_energy_text()
		big_catcher_button:
			_set_bigcatcher_text()

#region Descriptions
func _set_dreamcatcher_text() -> void:
	header.text = "Dreamcatcher"
	body.text = "Spin into a dreamcatcher to gain a boost that increases based on Gear Level and briefly pauses your Gear Time.
				"

func _set_small_energy_text() -> void:
	header.text = "Stratus Energy"
	body.text = "Collect this item to instantly gain Gear 1 or gain a bit of Gear Time. 
				"

func _set_big_energy_text() -> void:
	header.text = "Alto Energy"
	body.text = "Collect this item to instantly gain Gear 3 or gain a lot of Gear Time. 
				"

func _set_bigcatcher_text() -> void:
	header.text = "Bigcatcher"
	body.text = "While in Gear 4, spin into Bigcatchers to access an exclusive shortcut!
				"
#endregion
