extends CanvasItem

var territoriesByFaction = {
	"Draconis": [],
	"Davion": [],
	"Liao": [],
	"Marik": [],
	"Steiner": [],
	"Independents": [],
}

var colorsByFaction = {
	"Draconis": Color.red,
	"Davion": Color.yellow,
	"Liao": Color.green,
	"Marik": Color.blueviolet,
	"Steiner": Color.blue,
	"Independents": Color.white
}

var neighbouringTerritories = {}

var factions = ["Draconis", "Davion", "Liao", "Marik", "Steiner", "Independents"]

var currentTerritory = null
var heldTerritory = null

var pathfinder = AStar2D.new()

func _ready():
	var territories = File.new()
	territories.open("res://territories.tres", File.READ)
	var territoriesText = territories.get_as_text()
	territories.close()
	
	var currentFaction = 0
	for factionTerritories in territoriesText.split('\n'):
		if(factionTerritories == ''):
			break
		for territory in factionTerritories.split(','):
			territoriesByFaction.get(factions[currentFaction]).append(territory)
		currentFaction += 1
	
	
	for child in get_children():
		pathfinder.add_point(child.get_index(), child.position)
		if(!neighbouringTerritories.has(child.name)):
			neighbouringTerritories[child.name] = []
		
		var childKinematic = child.get_node("KinematicBody2D") as KinematicBody2D
		
		if(child.name != 'Terra'):
			var childCollisionMesh = childKinematic.get_node("CollisionPolygon2D") as CollisionPolygon2D
			var childPolygon = Polygon2D.new()
			
			for faction in factions:
				if(child.name in territoriesByFaction[faction]):
					childPolygon.color = colorsByFaction[faction]
			
			childPolygon.name = 'Polygon2D'
			childPolygon.color.a = 0.25
			
			childPolygon.set_polygon(childCollisionMesh.polygon)
			child.add_child(childPolygon)
		
		childKinematic.input_pickable = true
		childKinematic.connect("mouse_entered", self, "_on_mouse_enter", [child])
		childKinematic.connect("mouse_exited", self, "_on_mouse_exit", [child])
	neighbouringTerritories = MapFileHandling.import_relationship_json()
	
	for key in neighbouringTerritories.keys():
		var child = get_node(key)
		for neighbour in neighbouringTerritories.get(key):
			var neighbourNode = get_node(neighbour)
			pathfinder.connect_points(child.get_index(), neighbourNode.get_index())

func _on_mouse_enter(child: Position2D):
	currentTerritory = child.name
	if(child.has_node("Polygon2D")):
		child.get_node("Polygon2D").color.a = 0.75

func _on_mouse_exit(child: Position2D):
	if(child.has_node("Polygon2D")):
		child.get_node("Polygon2D").color.a = 0.25
	
	if(currentTerritory == child.name):
		currentTerritory = null

func _draw():
	if(heldTerritory != null && currentTerritory != null):
		var path = pathfinder.get_point_path(get_node(heldTerritory).get_index(), get_node(currentTerritory).get_index())
		draw_polyline(path, Color.green)

func _input(event):
	if(event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed()):
		heldTerritory = currentTerritory
		update()
	if(event is InputEventMouseButton && event.button_index == BUTTON_RIGHT && event.is_pressed()):
		update()

func get_closest_territory(pos: Vector2):
	return get_child(pathfinder.get_closest_point(pos)).name

func get_territory_path(start, end):
	return pathfinder.get_id_path(start, end)
