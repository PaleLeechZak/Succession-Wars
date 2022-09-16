extends Control

onready var game = get_node("../../")

func _process(delta):
	$Panel/Date.text = String(game.date)


func set_speed(level):
	game.current_speed = level


func _on_Speed1_button_down():
	set_speed(1)


func _on_Speed2_button_down():
	set_speed(2)


func _on_Speed3_button_down():
	set_speed(3)


func _on_Speed4_button_down():
	set_speed(4)


func _on_Speed5_button_down():
	set_speed(5)


func _on_Speed0_button_down():
	set_speed(0)
