extends CanvasLayer


func _process(_delta) -> void:
	render()
	

func render() -> void:
	$CoinLabel.text = "Coins: " + String(Score.score) + "/25"
	if Score.score >= 25:
		$VictoryScreen.visible = true
	else:
		$VictoryScreen.visible = false


func _on_MenuButton_button_down():
	var _useless_var: int = get_tree().reload_current_scene()
	Score.score = 0
	get_tree().get_root().get_node("Main").queue_free()
