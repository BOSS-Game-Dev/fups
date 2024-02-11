extends Node3D

@export var mouse_sensitivity : float = 3

var mouse_input : Vector2
var cam_rot : Vector3

@onready var orientation = get_node("../Orientation")

func _ready():
  # Mouse is stuck to the center of the screen and hidden
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
  
func _process(delta):
  cam_rot.x -= mouse_input.y
  cam_rot.y -= mouse_input.x
  rotation = cam_rot
  orientation.rotation.y = cam_rot.y
  
  mouse_input = Vector2.ZERO

func _input(event):
  if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
    mouse_input = event.relative * 0.001 * mouse_sensitivity
    
    
    
