extends Node


var enums = preload("res://scripts/player/enums.gd")

#State scripts
var idle_ss = preload("res://scripts/player/states/idle.gd")
var walking_ss = preload("res://scripts/player/states/walking.gd")
var sprinting_ss = preload("res://scripts/player/states/sprinting.gd")
var crouching_ss = preload("res://scripts/player/states/crouching.gd")
var sliding_ss = preload("res://scripts/player/states/sliding.gd")
var jumping_ss = preload("res://scripts/player/states/jumping.gd")
var airtime_ss = preload("res://scripts/player/states/airtime.gd")
var wallclimb_ss = preload("res://scripts/player/states/wallclimb.gd")
var wallrun_ss = preload("res://scripts/player/states/wallrun.gd")

#And associated variables
var idle_state
var walking_state
var sprinting_state
var crouching_state
var sliding_state
var jumping_state
var airtime_state
var wallclimb_state
var wallrun_state

var player: playerData

var old_state

func debug_print_player_state():
	match player.current_state:
		enums.player_states.Idle:
			print("idle")
		enums.player_states.Walking:
			print("walking")
		enums.player_states.Sprinting:
			print("sprinting")
		enums.player_states.Jumping:
			print("jumping")
		enums.player_states.Crouching:
			print("crouching")
		enums.player_states.Sliding:
			print("sliding")
		enums.player_states.AirTime:
			print("airtime")
		enums.player_states.WallClimb:
			print("wallclimb")
		enums.player_states.WallRun:
			print("wallrun")
	

func init(player_object):
	#Instanciate state scripts
	idle_state = idle_ss.new()
	walking_state = walking_ss.new()
	sprinting_state = sprinting_ss.new()
	crouching_state = crouching_ss.new()
	sliding_state = sliding_ss.new()
	jumping_state = jumping_ss.new()
	airtime_state = airtime_ss.new()
	wallclimb_state = wallclimb_ss.new()
	wallrun_state = wallrun_ss.new()
	
	idle_state.init(player_object)
	walking_state.init(player_object)
	sprinting_state.init(player_object)
	crouching_state.init(player_object)
	sliding_state.init(player_object)
	jumping_state.init(player_object)
	airtime_state.init(player_object)
	wallclimb_state.init(player_object)
	wallrun_state.init(player_object)
	
	player = player_object
	
func get_next_state():
	old_state = player.current_state
	match player.current_state:
		enums.player_states.Idle:
			idle_state.check()
		enums.player_states.Walking:
			walking_state.check()
		enums.player_states.Sprinting:
			sprinting_state.check()
		enums.player_states.Jumping:
			jumping_state.check()
		enums.player_states.Crouching:
			crouching_state.check()
		enums.player_states.Sliding:
			sliding_state.check()
		enums.player_states.AirTime:
			airtime_state.check()
		enums.player_states.WallClimb:
			wallclimb_state.check()
		enums.player_states.WallRun:
			wallrun_state.check()
	if not player.current_state == old_state:
		set_current_state()

func set_current_state():
	#Exit the current state
	match old_state:
		enums.player_states.Idle:
			idle_state.exit()
		enums.player_states.Walking:
			walking_state.exit()
		enums.player_states.Sprinting:
			sprinting_state.exit()
		enums.player_states.Jumping:
			jumping_state.exit()
		enums.player_states.Crouching:
			crouching_state.exit()
		enums.player_states.Sliding:
			sliding_state.exit()
		enums.player_states.AirTime:
			airtime_state.exit()
		enums.player_states.WallClimb:
			wallclimb_state.exit()
		enums.player_states.WallRun:
			wallrun_state.exit()
	#Enter new state
	old_state = player.current_state
	match player.current_state:
		enums.player_states.Idle:
			idle_state.enter()
		enums.player_states.Walking:
			walking_state.enter()
		enums.player_states.Sprinting:
			sprinting_state.enter()
		enums.player_states.Jumping:
			jumping_state.enter()
		enums.player_states.Crouching:
			crouching_state.enter()
		enums.player_states.Sliding:
			sliding_state.enter()
		enums.player_states.AirTime:
			airtime_state.enter()
		enums.player_states.WallClimb:
			wallclimb_state.enter()
		enums.player_states.WallRun:
			wallrun_state.enter()
	
func update_current_state():
	match player.current_state:
		enums.player_states.Idle:
			idle_state.update()
		enums.player_states.Walking:
			walking_state.update()
		enums.player_states.Sprinting:
			sprinting_state.update()
		enums.player_states.Jumping:
			jumping_state.update()
		enums.player_states.Crouching:
			crouching_state.update()
		enums.player_states.Sliding:
			sliding_state.update()
		enums.player_states.AirTime:
			airtime_state.update()
		enums.player_states.WallClimb:
			wallclimb_state.update()
		enums.player_states.WallRun:
			wallrun_state.update()

func run():
	get_next_state()
	if player.current_state != old_state:
		print(player.current_state)
		print(old_state)
		set_current_state()
		debug_print_player_state()
		#print(player.velocity.length())
	update_current_state()
