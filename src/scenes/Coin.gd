extends Area2D


onready var hud: CanvasLayer = get_tree().get_root().find_node("HUD", true, false)


func _on_Coin_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		print("Coin collected!")
		hud.add_coins(1)
		queue_free()
