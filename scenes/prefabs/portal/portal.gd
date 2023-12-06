extends Node3D

@export var destination: Vector3
@onready var marker = $marker

func _ready():
	marker.position = destination

func _on_area_3d_area_entered(area):
	var tmp = area.get_parent()
	print(marker.position)
	tmp.position = marker.position
