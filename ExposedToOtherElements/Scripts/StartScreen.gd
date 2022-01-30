extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.hide()

func _on_Main_show_start_screen():
	$Panel.show()

func _on_Button_pressed():
	emit_signal("start_game")
	$Panel.hide()

func _on_Button2_pressed():
	get_tree().quit()
