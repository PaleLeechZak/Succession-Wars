extends Node

export var territoryColor = Color.white
export var current = false

onready var game = get_node('../..')
onready var map = get_node('../../Map')

var selected_unit = null

var money = 0

func _ready():
	pass

func _tick():
	for child in get_children():
		if(child.has_method('_tick')):
			child.call('_tick')


func _input(event):
	if(game.playerFaction == self.name):
		if(event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed()):
			selected_unit = null
			for child in get_children():
				if child is Unit && child.currentTerritory == map.currentTerritory:
					selected_unit = child
					break
		if(event is InputEventMouseButton && event.button_index == BUTTON_RIGHT && event.is_pressed()):
			if(selected_unit != null):
				selected_unit.set_target(map.currentTerritory)
