extends Control


func _ready():
	pass


func _process(delta):
	pass


func _on_NewGame_pressed():
	get_tree().change_scene("res://TheMap.tscn")


func _on_LoadGame_pressed():
	pass # Replace with function body.


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()
