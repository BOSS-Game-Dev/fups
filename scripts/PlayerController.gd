extends CharacterBody3D

const SPEED : float = 5.0
const JUMP_VELOCITY : float = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity :float = ProjectSettings.get_setting("physics/3d/default_gravity")

# Get default physics time step for interpolation
var phys_time_step : float = ProjectSettings.get_setting("physics/common/physics_ticks_per_second")

@onready var orientation = $Orientation
@onready var CAMERA_HOLDER = $CameraHolder
@onready var CAM_OFFSET = CAMERA_HOLDER.position.y

func _onready():
  print(gravity)

func _physics_process(delta):
  # Add the gravity.
  if not is_on_floor():
    velocity.y -= gravity * delta

  # Handle jump.
  if Input.is_action_just_pressed("jump") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var input_dir : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
  var direction : Vector3 = (orientation.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)

  move_and_slide()
  
# Linearly interpolates the camera for smoother movement
# Code is from Garbaj
func _process(delta):
  var fps : float = Engine.get_frames_per_second()
  
  if fps > phys_time_step:
    var new_pos : Vector3 = global_position + (velocity / fps)
    new_pos.y += CAM_OFFSET
    
    CAMERA_HOLDER.top_level = true
    CAMERA_HOLDER.global_position = lerp(CAMERA_HOLDER.global_position, new_pos, 20 * delta)
  else:
    CAMERA_HOLDER.top_level = false
    CAMERA_HOLDER.global_position = Vector3(global_position.x, global_position.y + CAM_OFFSET, global_position.z)
