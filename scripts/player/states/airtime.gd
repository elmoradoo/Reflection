extends BaseState

var player: playerData
const max_speed: float = 3.0
var enums = preload("res://scripts/player/enums.gd")


func init(obj):
	player = obj

func get_state_name():
	return enums.player_states.AirTime

func enter():
	pass

func exit():
	player.animation_player.play("land")

func update():
	super.update_event(player)
	super.reset_head_bob(player)
	#print(player.velocity.y)
	

		
		# Wall is not perpendicular
func get_next_state():
	#test()
	if player.myself.is_on_floor():
		return enums.player_states.Idle
	elif super.can_wallclimb(player):
		return enums.player_states.WallClimb
	elif super.can_wallrun(player):
		return enums.player_states.WallRun
	return enums.player_states.AirTime
