extends Node3D


func _ready():
	$playerLoliRiggedClean/PlayerSkelIK/Skeleton3D/PhysicalBoneSimulator3D.active = true
	$playerLoliRiggedClean/PlayerSkelIK/Skeleton3D/PhysicalBoneSimulator3D.physical_bones_start_simulation()
