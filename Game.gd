extends Node2D

export var current_speed = 1.0 setget set_speed
export var min_speed = 1.0
export var max_speed = 5.0
export var seconds_per_tick = 1.0

export var date = 0

export var playerFaction = 'Marik'

func set_speed(val):
	if(val != 0):
		current_speed = min(max_speed, max(min_speed, val))
		adjust_tickrate()
	else:
		$Timer.stop()

func _ready():
	pass # Replace with function body.


func _tick():
	date += 1
	for child in get_children():
		if(child.has_method('_tick')):
			child.call('_tick')


func adjust_tickrate():
	$Timer.wait_time = seconds_per_tick / pow(2, current_speed - 1) #1,2,4,8,16
	$Timer.start()


func _on_Timer_timeout():
	_tick() # Replace with function body.
