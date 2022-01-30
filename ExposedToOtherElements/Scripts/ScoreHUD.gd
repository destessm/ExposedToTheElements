extends CanvasLayer

func _ready():
	
	pass # Replace with function body.

func _on_Main_score(value):
	$ScoreLabel.text = "Score: " + str(value)
