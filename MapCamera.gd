extends Camera2D

var speed = 512.0
export var bounds := Vector2.ZERO 

var desiredZoom = 1

func _ready():
	pass # Replace with function body.

func _input(event):
	if(event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_DOWN):
		desiredZoom = min(desiredZoom * 2.0, 16)
	if(event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_UP):
		desiredZoom = max(0.125, desiredZoom / 2.0)
		pass

func _process(delta):
	var horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if(abs(position.x) < bounds.x || (position.x > bounds.x && horizontal < 0) || (position.x < -bounds.x && horizontal > 0)):
		position += Vector2(horizontal, 0) * speed * delta
	if(abs(position.y) < bounds.y || (position.y > bounds.y && vertical < 0) || (position.y < -bounds.y && vertical > 0)):
		position += Vector2(0, vertical) * speed * delta
	
	if(self.zoom != Vector2(desiredZoom, desiredZoom)):
		self.zoom = lerp(self.zoom, Vector2(desiredZoom, desiredZoom), 0.1)
