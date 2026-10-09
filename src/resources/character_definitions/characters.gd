class_name Stats extends Resource
## Has definitions for stats
@export_category("Stats")
@export_group("Speed")
@export_range(-5,5, 1, "prefer_slider") var speed : float
@export_range(-5,5, 0.1, "prefer_slider") var air_resistance : float
@export_group("Acceleration")
@export_range(-5,5, 1, "prefer_slider") var acceleration : float
@export_group("Handling")
@export_range(-3, 3, 1, "prefer_slider") var max_steering_angle_fast : float
@export_range(-5, 5, 1, "prefer_slider") var max_steering_angle_slow : float
@export_range(-0.5, 0.5, 0.01, "prefer_slider") var traction_factor : float
@export_range(-1, 1, 0.1, "prefer_slider") var drift_multiplier : float
@export_group("Weight")
@export_range(-0.1, 0.1, 0.01, "prefer_slider") var weight : float
@export_range(-5, 5, 1, "prefer_slider") var knockback : float
@export_group("Boost")
@export_range(-5,5, 1, "prefer_slider") var boost_top_speed : float
@export_range(-1,1, 0.1, "prefer_slider") var drift_charge_speed : float
@export_range(-1, 1, 0.1, "prefer_slider") var boost_time : float
