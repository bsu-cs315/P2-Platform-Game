extends Node2D


var main_scene: Node2D = preload("res://src/Main.tscn").instance()


func _on_MenuButton_button_down() -> void:
	get_tree().get_root().add_child(main_scene)
	self.visible = false
