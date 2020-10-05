extends CanvasLayer


func _process(_delta) -> void:
	render()
	

func render() -> void:
	$CoinLabel.text = "Coins: " + String(Score.score)
	
