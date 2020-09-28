extends CanvasLayer


var coins: int = 0


func add_coins(count: int) -> void:
	coins += count
	$CoinLabel.text = "Coins: " + String(coins)
	
