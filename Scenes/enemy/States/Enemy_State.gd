extends Node
class_name EnemyState


var enemy : Enemy
var state_machine: EnemyStateMachine


func init():
	pass
	
	
func enter()-> void:
	pass
	
func exit()-> void:
	pass
	
	
func process(_delta: float )-> EnemyState:
	return null
	
func physics(_delta: float)-> EnemyState:
	return null
