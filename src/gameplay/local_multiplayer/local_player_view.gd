class_name LocalMultiplayerView extends GridContainer
## Updates the amount of subviewports visible depending on how many players are in the game
@export var playerViews : Array[SubViewportContainer]
var visible_viewports : Array[SubViewport]

##hides and unhides views
func update_viewports(playerAmount : int = 1) -> void:
	# Sets colums in grid
	if playerAmount == 0:
		return
	elif playerAmount == 1:
		columns = 1
	else:
		columns = 2
	
	#hides all viewports and clears visible viewport array
	visible_viewports.clear()
	for view in playerViews:
		view.hide()
	
	#unhides and fill visible viewports array based on how many players are in the game
	for player in playerAmount:
		playerViews[player].visible = true
		visible_viewports.append(playerViews[player].get_child(0))
	
## Adds players to unhidden subviewports
func add_players(players : Array[Player]) -> void:
	for i in range(players.size()):
		visible_viewports[i].add_child(players[i])

func add_local_huds(huds : Array[Local_Player_HUD]) -> void:
	for i in range(huds.size()):
		visible_viewports[i].add_child(huds[i])
