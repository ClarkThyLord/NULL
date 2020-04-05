tool
extends "res://addons/Voxel-Core/src/VoxelObject.gd"
class_name VoxelMesh, 'res://addons/Voxel-Core/assets/VoxelMesh.png'



# VoxeMesh:
# The most basic VoxelObject class.
# NOTE: Should be used to display a small amount of Voxels. (e.g. Voxels <= 1000)



# Declarations
var voxels := {} setget set_voxels, get_voxels



# Core
func _load() -> void:
	._load()
	
	if has_meta('voxels'): voxels = get_meta('voxels')

func _save() -> void:
	._save()
	
	set_meta('voxels', voxels)


func _init() -> void:
	_load()
func _ready() -> void:
	set_voxel_set_path(VoxelSetPath, false, false)
	_load()


func get_rvoxel(grid : Vector3):
	return voxels.get(grid)

func get_voxels() -> Dictionary:
	return voxels.duplicate(true)


func set_voxel(grid : Vector3, voxel, update := false) -> void:
	voxels[grid] = voxel
	.set_voxel(grid, voxel, update)

func set_voxels(_voxels : Dictionary, update := true) -> void:
	erase_voxels(false)
	
	voxels = _voxels.duplicate(true)
	if update: update()


func erase_voxel(grid : Vector3, update := false) -> void:
	voxels.erase(grid)
	.erase_voxel(grid, update)

func erase_voxels(update : bool = true) -> void:
	voxels.clear()
	if update: update()


# Main function used when Greedy Meshing on update
# st           :   SurfaceTool      -   SurfaceTool to append Greedy Mesh to
# origin       :   Vector3          -   grid position from which to start Greedy Meshing
# direction    :   Vector3          -   orientation of face
# directions   :   Array<Vector3>   -   directions for Greedy Meshing
# used         :   Array<Vector3>   -   positions already used
#
# Example:
#   greed([SurfaceTool], [Vector3], [Vector3], Array<Vector3>, Array<Vector3>) -> Array<Vector3>
#
func greed(st : SurfaceTool, origin : Vector3, direction : Vector3, directions : Array, used : Array) -> Array:
	used.append(origin)
	
	var origin_voxel = get_voxel(origin)
	var origin_color = Voxel.get_color_side(origin_voxel, direction)
	var origin_texture = Voxel.get_texture_side(origin_voxel, direction)
	
	var g1 = origin
	var g2 = origin
	var g3 = origin
	var g4 = origin
	
	if origin_texture == null:
		var temp = []
		var offset = 1
		var length = 1
		
		while true:
			var temp_grid = g4 + (directions[0] * offset)
			var temp_voxel = get_voxel(temp_grid)
		
			if voxels.has(temp_grid) and not Voxel.is_voxel_obstructed(temp_grid, direction, voxels, used) and Voxel.get_color_side(temp_voxel, direction) == origin_color:
				offset += 1
				temp.append(temp_grid)
			else: break
		
		used += temp
		length += temp.size()
		g1 += directions[0] * temp.size()
		g3 += directions[0] * temp.size()
		
		temp = []
		offset = 1
		
		while true:
			var temp_grid = g4 + (directions[1] * offset)
			var temp_voxel = get_voxel(temp_grid)
			
			if voxels.has(temp_grid) and not Voxel.is_voxel_obstructed(temp_grid, direction, voxels, used) and Voxel.get_color_side(temp_voxel, direction) == origin_color:
				offset += 1
				temp.append(temp_grid)
			else: break
		
		used += temp
		length += temp.size()
		g2 += directions[1] * temp.size()
		g4 += directions[1] * temp.size()
		
		temp = []
		offset = 1
		
		while true:
			var temp_grid = g4 + (directions[2] * offset)
			
			var valid = true
			for temp_offset in range(length):
				var _temp_grid = temp_grid + directions[0] * temp_offset
				var temp_voxel = get_voxel(_temp_grid)
			
				if voxels.has(_temp_grid) and not Voxel.is_voxel_obstructed(_temp_grid, direction, voxels, used) and Voxel.get_color_side(temp_voxel, direction) == origin_color:
					temp.append(_temp_grid)
				else:
					valid = false
					break
			
			if valid:
				used += temp
				offset += 1
			else: break
		
		g1 += directions[2] * (offset - 1)
		g2 += directions[2] * (offset - 1)
		
		temp = []
		offset = 1
		while true:
			var temp_grid = g4 + (directions[3] * offset)
			
			var valid = true
			for temp_offset in range(length):
				var _temp_grid = temp_grid + directions[0] * temp_offset
				var temp_voxel = get_voxel(_temp_grid)
			
				if voxels.has(_temp_grid) and not Voxel.is_voxel_obstructed(_temp_grid, direction, voxels, used) and Voxel.get_color_side(temp_voxel, direction) == origin_color:
					temp.append(_temp_grid)
				else:
					valid = false
					break
			
			if valid:
				used += temp
				offset += 1
			else: break
		
		g3 += directions[3] * (offset - 1)
		g4 += directions[3] * (offset - 1)
	
	if UVMapping: Voxel.generate_side_with_uv(direction, st, get_voxel(origin), g1, g2, g3, g4, VoxelSet.UV_SCALE if VoxelSet else 1.0)
	else: Voxel.generate_side(direction, st, get_voxel(origin), g1, g2, g3, g4)
	
	return used


func update() -> void:
	if voxels.size() > 0:
		var _material := get_surface_material(0) if get_surface_material_count() > 0 else null
		
		var ST = SurfaceTool.new()
		ST.begin(Mesh.PRIMITIVE_TRIANGLES)
		var material = SpatialMaterial.new()
		material.roughness = 1
		material.vertex_color_is_srgb = true
		material.vertex_color_use_as_albedo = true
		
		if UVMapping and VoxelSet and not VoxelSet.AlbedoTexture == null:
			material.albedo_texture = VoxelSet.AlbedoTexture
		
		ST.set_material(material)
		
		
		if editing or MeshType == MeshTypes.NAIVE:
			for voxel_grid in voxels:
				if UVMapping:
					if not voxels.has(voxel_grid + Vector3.RIGHT): Voxel.generate_right_with_uv(ST, get_voxel(voxel_grid), voxel_grid, null, null, null, VoxelSet.UV_SCALE if VoxelSet else 1.0)
					if not voxels.has(voxel_grid + Vector3.LEFT): Voxel.generate_left_with_uv(ST, get_voxel(voxel_grid), voxel_grid, null, null, null, VoxelSet.UV_SCALE if VoxelSet else 1.0)
					if not voxels.has(voxel_grid + Vector3.UP): Voxel.generate_up_with_uv(ST, get_voxel(voxel_grid), voxel_grid, null, null, null, VoxelSet.UV_SCALE if VoxelSet else 1.0)
					if not voxels.has(voxel_grid + Vector3.DOWN): Voxel.generate_down_with_uv(ST, get_voxel(voxel_grid), voxel_grid, null, null, null, VoxelSet.UV_SCALE if VoxelSet else 1.0)
					if not voxels.has(voxel_grid + Vector3.BACK): Voxel.generate_back_with_uv(ST, get_voxel(voxel_grid), voxel_grid, null, null, null, VoxelSet.UV_SCALE if VoxelSet else 1.0)
					if not voxels.has(voxel_grid + Vector3.FORWARD): Voxel.generate_forward_with_uv(ST, get_voxel(voxel_grid), voxel_grid, null, null, null, VoxelSet.UV_SCALE if VoxelSet else 1.0)
				else:
					if not voxels.has(voxel_grid + Vector3.RIGHT): Voxel.generate_right(ST, get_voxel(voxel_grid), voxel_grid)
					if not voxels.has(voxel_grid + Vector3.LEFT): Voxel.generate_left(ST, get_voxel(voxel_grid), voxel_grid)
					if not voxels.has(voxel_grid + Vector3.UP): Voxel.generate_up(ST, get_voxel(voxel_grid), voxel_grid)
					if not voxels.has(voxel_grid + Vector3.DOWN): Voxel.generate_down(ST, get_voxel(voxel_grid), voxel_grid)
					if not voxels.has(voxel_grid + Vector3.BACK): Voxel.generate_back(ST, get_voxel(voxel_grid), voxel_grid)
					if not voxels.has(voxel_grid + Vector3.FORWARD): Voxel.generate_forward(ST, get_voxel(voxel_grid), voxel_grid)
		elif MeshType == MeshTypes.GREEDY:
			var rights = []
			var right_directions = [ Vector3.FORWARD, Vector3.BACK, Vector3.DOWN, Vector3.UP ]
			var lefts = []
			var left_directions = [ Vector3.FORWARD, Vector3.BACK, Vector3.DOWN, Vector3.UP ]
			var ups = []
			var up_directions = [ Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT ]
			var downs = []
			var down_directions = [ Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT ]
			var backs = []
			var back_directions = [ Vector3.LEFT, Vector3.RIGHT, Vector3.DOWN, Vector3.UP ]
			var forwards = []
			var forward_directions = [ Vector3.LEFT, Vector3.RIGHT, Vector3.DOWN, Vector3.UP ]
			
			for voxel_grid in voxels:
				if not Voxel.is_voxel_obstructed(voxel_grid, Vector3.RIGHT, voxels, rights): rights = greed(ST, voxel_grid, Vector3.RIGHT, right_directions, rights)
				if not Voxel.is_voxel_obstructed(voxel_grid, Vector3.LEFT, voxels, lefts): lefts = greed(ST, voxel_grid, Vector3.LEFT, left_directions, lefts)
				if not Voxel.is_voxel_obstructed(voxel_grid, Vector3.UP, voxels, ups): ups = greed(ST, voxel_grid, Vector3.UP, up_directions, ups)
				if not Voxel.is_voxel_obstructed(voxel_grid, Vector3.DOWN, voxels, downs): downs = greed(ST, voxel_grid, Vector3.DOWN, down_directions, downs)
				if not Voxel.is_voxel_obstructed(voxel_grid, Vector3.BACK, voxels, backs): backs = greed(ST, voxel_grid, Vector3.BACK, back_directions, backs)
				if not Voxel.is_voxel_obstructed(voxel_grid, Vector3.FORWARD, voxels, forwards): forwards = greed(ST, voxel_grid, Vector3.FORWARD, forward_directions, forwards)
		
		ST.index()
		mesh = ST.commit()
		mesh.surface_set_name(0, 'voxels')
		set_surface_material(0, _material)
	else: mesh = null
	
	.update()
	_save()

func update_static_body() -> void:
	var staticbody
	if has_node('StaticBody'): staticbody = get_node('StaticBody')
	
	if (editing or BuildStaticBody) and mesh:
		var collisionshape
		if not staticbody:
			staticbody = StaticBody.new()
			staticbody.set_name('StaticBody')
		
		if staticbody.has_node('CollisionShape'):
			collisionshape = staticbody.get_node('CollisionShape')
		else:
			collisionshape = CollisionShape.new()
			collisionshape.set_name('CollisionShape')
			staticbody.add_child(collisionshape)
		
		collisionshape.shape = mesh.create_trimesh_shape()
		
		if not has_node('StaticBody'): add_child(staticbody)
		
		if BuildStaticBody and not staticbody.owner: staticbody.set_owner(get_tree().get_edited_scene_root())
		elif not BuildStaticBody and staticbody.owner: staticbody.set_owner(null)
		if BuildStaticBody and not collisionshape.owner: collisionshape.set_owner(get_tree().get_edited_scene_root())
		elif not BuildStaticBody and staticbody.owner: collisionshape.set_owner(null)
	elif staticbody:
		remove_child(staticbody)
		staticbody.queue_free()
