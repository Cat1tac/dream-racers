extends Node

## player var signals
signal on_get_steer
signal on_get_speed
signal on_get_time
signal on_get_stored_charge
signal on_player_finished

## gameplay to hud signals
signal on_get_lap_count
signal on_get_total_laps
signal on_get_countdown
signal on_countdown_finished
signal on_placement_update
signal on_final_placement
signal on_going_reverse

## Used to signal a player has joined the game
signal on_player_added

## track signals
signal on_checkpoints_list_filled
signal on_send_checkpoints
signal on_starting_respawn
signal players_finished_race
signal on_race_over
signal get_start_line_position(Vector3)

## ui signals
signal on_how_to_play
