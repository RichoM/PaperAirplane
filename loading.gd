extends Label

var count = -1

func _on_timer_timeout():
	count = (count + 1) % 3
	text = "Loading"
	for i in 3:
		text += "." if i <= count else " "

func _on_fetch_scores_request_completed(result, response_code, headers, body):
	queue_free()
