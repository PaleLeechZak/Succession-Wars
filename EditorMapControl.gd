extends Sprite

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
	import_relationship_json()

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
	if(heldTerritory != null):
		var territoryRoot = get_node(heldTerritory) as Position2D
		var relationships = neighbouringTerritories[heldTerritory]
		
		for relationship in relationships:
			var relatedNode = get_node(relationship) as Position2D
			draw_line(territoryRoot.position, relatedNode.position, Color.green)

func _input(event):
	if(event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed()):
		print(currentTerritory)
		heldTerritory = currentTerritory
		update()
	if(event is InputEventMouseButton && event.button_index == BUTTON_RIGHT && event.is_pressed()):
		if(currentTerritory != null):
			if(!neighbouringTerritories[heldTerritory].has(currentTerritory)):
				neighbouringTerritories[heldTerritory].append(currentTerritory)
				neighbouringTerritories[currentTerritory].append(heldTerritory)
			else:
				neighbouringTerritories[heldTerritory].erase(currentTerritory)
				neighbouringTerritories[currentTerritory].erase(heldTerritory)
		update()
	if(event.is_action_pressed("ui_home")):
		export_relationship_json()

func export_relationship_json():
	var relationships = File.new()
	relationships.open("user://relationships.json", File.WRITE_READ)
	relationships.store_line(JSON.print(neighbouringTerritories))
	relationships.close()

func import_relationship_json():
	var relationships = File.new()
	relationships.open("res://relationships.tres", File.READ)
	neighbouringTerritories = JSON.parse(relationships.get_line()).get_result()
