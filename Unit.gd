extends Sprite
class_name Unit

var currentTerritory = null
var targetTerritory = null
var path = null

var faction = null

onready var map = get_node('../../../Map')

var ticksToMove = 10
var ticksElapsed = 0

func _ready():
	print(map)
	currentTerritory = map.get_closest_territory(self.position)
	print(currentTerritory)
	faction = get_parent().name
	
	_align_territory()

func _draw():
	pass

func _tick():
	if(path != null):
		ticksElapsed += 1
		
		if(ticksElapsed >= ticksToMove):
			_do_move()
			ticksElapsed = 0
		
		update()

func _do_move():
	if(path != null):
		currentTerritory = map.get_child(path[1]).name
		_align_territory()
		path.pop_front()
		if(path.size() == 1):
			path = null #Completed order


func set_target(tgt):
	targetTerritory = tgt
	path = Array(map.get_territory_path(map.get_node(currentTerritory).get_index(), map.get_node(tgt).get_index()))


func _align_territory():
	self.position = map.get_node(currentTerritory).position
