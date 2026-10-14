class_name SpinVFX extends Node3D
@export var spin_vfx : MeshInstance3D
@export var show_curve : Curve

@export var vfx_colors : Dictionary[int, Color]

func show_spin_effect(time : float, max_time : float, level : int) -> void:
	var spin_material : Material = spin_vfx.material_override as ShaderMaterial
	spin_material.set_shader_parameter("albedo", vfx_colors[level])
	var gradient_tex : GradientTexture2D = spin_material.get_shader_parameter("vertical_mask") as GradientTexture2D
	var value : float = remap(time, 0, max_time, show_curve.min_domain, show_curve.max_domain)
	var curve_value : float = show_curve.sample(value)
	gradient_tex.fill_from = Vector2(curve_value, gradient_tex.fill_from.y)
