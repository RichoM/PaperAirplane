extends Spatial

func _ready():
	SceneManager.register_current_scene()
	#$fetch_scores.request(Globals.LEADERBOARD_URL)

func _on_fetch_scores_request_completed(result, response_code, headers, body):
	pass # TODO(Richo): Store the leaderboard in globals to avoid waiting later!
