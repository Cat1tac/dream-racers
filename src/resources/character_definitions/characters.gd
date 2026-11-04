class_name Stats extends Resource
## Has definitions for stats
@export_category("Stats")
@export_group("Speed")
## Modifies top speed of character (Base 27.0)
@export_range(-1,1, 0.01, "prefer_slider") var speed : float
## Modifies how fast character slows down in air (Base 5.0)
@export_range(-5,5, 0.1, "prefer_slider") var air_resistance : float
@export_group("Acceleration")
## Modifies how fast kart reaches top speed (Base 8.0)
@export_range(-1,1, 0.01, "prefer_slider") var acceleration : float
@export_group("Handling")
## Modifies how much you can turn when in upper range if speed (Base 5.5)
@export_range(-1, 1, 0.01, "prefer_slider") var max_steering_angle_fast : float
## Modifies how much you can turn when in upper range if speed (Base 7.0)
@export_range(-1, 1, 0.01, "prefer_slider") var max_steering_angle_slow : float
## Modifies how much kart slides when turning (Base 0.3)
@export_range(-0.5, 0.5, 0.01, "prefer_slider") var traction_factor : float
## Modifies how much drifting increases turn angle (Base 1.5)
@export_range(-1, 1, 0.01, "prefer_slider") var drift_multiplier : float
@export_group("Weight")
@export_range(-0.1, 0.1, 0.01, "prefer_slider") var weight : float
## Modifies how much receiving player gets knockedback when hit with spin
@export_range(-5, 5, 1, "prefer_slider") var knockback : float
@export_group("Boost")
## Modifies boost speed added to speed (Base 3.0)
@export_range(-1,1, 0.01, "prefer_slider") var boost_top_speed : float
## Modifies how fast a kart charges drift boosts (Base 0)
@export_range(-1,1, 0.01, "prefer_slider") var drift_charge_speed : float
## Modifies the amt of time a gear and dreamcatcher speedboost lasts for
@export_range(-0.5, 0.5, 0.1, "prefer_slider") var boost_time : float
