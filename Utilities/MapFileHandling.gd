class_name MapFileHandling
extends Node

static func export_relationship_json(neighbouringTerritories):
	var relationships = File.new()
	relationships.open("user://relationships.json", File.WRITE_READ)
	relationships.store_line(JSON.print(neighbouringTerritories))
	relationships.close()

static func import_relationship_json():
	var relationships = File.new()
	relationships.open("user://relationships.json", File.READ)
	return JSON.parse(relationships.get_line()).get_result()
