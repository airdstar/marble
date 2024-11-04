extends RigidBody3D

var rot_info : Node3D

var proxy_tilt = Node3D.new()
var max_tilt : float = 15
var tilt_sens : float = 20

func _physics_process(delta: float) -> void:
	var floor_tilt = Input.get_vector("tilt_up", "tilt_down", "tilt_right", "tilt_left")
	
	floor_tilt.x = clamp(deg_to_rad(clamp(floor_tilt.x, -0.45, 0.45) * tilt_sens), deg_to_rad(-max_tilt), deg_to_rad(max_tilt))
	floor_tilt.y = clamp(deg_to_rad(clamp(floor_tilt.y, -0.45, 0.45) * tilt_sens), deg_to_rad(-max_tilt), deg_to_rad(max_tilt))
	
	proxy_tilt.rotation = rot_info.transform.basis * Vector3(floor_tilt.x, 0, floor_tilt.y)
	
	var a = Quaternion(self.transform.basis)
	var b = Quaternion(proxy_tilt.transform.basis)
	var c = a.slerp(b,0.15)
	self.transform.basis = Basis(c)
