extends Node

signal on_get_steer
signal on_get_speed
signal on_get_time
signal on_get_stored_charge

signal on_get_lap_count
signal on_get_countdown
signal on_countdown_finished

## Used to signal a player has joined the game
signal on_player_added

signal on_checkpoints_list_filled
signal on_track_loaded
signal players_finished_race
signal on_race_over
