extends InfoScreen
# buttons
@onready var start_boost_button: Button = %StartBoostButton
@onready var button: Button = %Button
@onready var drift_button: Button = %DriftButton
@onready var spin_button: Button = %SpinButton
@onready var trick_button: Button = %TrickButton

# text
@onready var header: Label = %DescriptionHeader
@onready var body: Label = %DescriptionBody

func _process(_delta: float) -> void:
	match get_viewport().gui_get_focus_owner():
		start_boost_button:
			_set_start_boost_text()
		button:
			_set_gear_text()
		drift_button:
			_set_drift_text()
		spin_button:
			_set_spin_text()
		trick_button:
			_set_trick_text()

#region Descriptions
func _set_start_boost_text() -> void:
	header.text = "Start Boost"
	body.text = "At the start of a race, press accelerate in time with the flashing countdown numbers and GO to build and initiate a Start Boost.\n
				Missed timing on numbers will lock you out from building Start Boost from that number. Timing is key!
				"

func _set_gear_text() -> void:
	header.text = "Gear"
	body.text = "There are 4 Gear Levels, shown in the speedometer.\n
				Higher Gear → Top Speed UP!\n
				Gear duration will decrease over time, perform techniques such as drift charges, tricking, & spinning. Play stylishly to keep your Gear Level!\n
				Gear Level can be increased by drift charging. Your Gear Level is equal to the highest drift charge performed during your gear's duration.\n
				Gear 0-1 → up to drift charge 2
				Gear 2 → up to drift charge 3
				Gear 3 → up to drift charge 4
				"

func _set_drift_text() -> void:
	header.text = "Drift"
	body.text = "While accelerating, hold the drift button and steer in a given direction to drift!\n
				The longer you hold a drift and the sharper the angle, the more drift charge will build. Release the drift button to use your drift charge!\n
				Snaking: Quickly releasing and pressing the drift button while holding in the opposite direction, will retain the drift charge and allow you to swap directions.\n
				Rolling Drift: Releasing acceleration while drifting, will allow you to make sharper drifts but also deccelerates you.\n
				Brake Drift: Braking during a drift will slow you down.
				"

func _set_spin_text() -> void:
	header.text = "Spin"
	body.text = "Press the spin button to spin! Weeee! :D\n
				Spin on Dreamcatchers to gain a boost that increases based on Gear Level and briefly pauses your Gear Time.
				Spin on Opponents to knock them back and remove their drift charge, alongside gaining the boost.
				"

func _set_trick_text() -> void:
	header.text = "Trick"
	body.text = "Press the spin button after quickly leaving a surface or bouncing off a cloud to perform a trick!\n
				A trick will briefly pause your Gear Time and will put you in Gear 2 if below, otherwise, it will increase your Gear Time.
				"
#endregion
