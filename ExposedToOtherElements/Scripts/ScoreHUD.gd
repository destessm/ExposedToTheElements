extends CanvasLayer

func _on_Main_score(value):
	$ScoreLabel.text = "Score: " + str(value)

func hide_all():
	$ScoreLabel.hide()

func show_all():
	$ScoreLabel.show()
