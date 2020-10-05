extends CanvasLayer


var coins: int = 0


func _process(_delta):
	$CoinLabel.text = "Coins: " + String(Score.score)
	
