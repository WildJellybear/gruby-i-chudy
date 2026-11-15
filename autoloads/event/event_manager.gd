@warning_ignore_start("unused_signal")
extends Node
# Event manager is a node that provides just a list of signals.
# Each signal, ideally, SHOULD follow the one emitter, many listeners principle.
# For each signal, the writer or writers MUST be documented in the comments.
# Readers MAY be documented, but are not required.

## Emitted by the Game autoload when a new/different player instance is assigned.
##
## Should be listened to by each object which directly uses the player instance,
## in order to keep the referenced instance up-to-date.
signal player_changed(player: Player)

## Emitted by the Flag autoload when a Flag is raised/lowered, 
## except for the initial load.
##
## Should be listened to only by objects which need access to updates on EVERY flag.
## For objects which only need to listen to updates on Flag resource F, use
## F.flag_changed signal instead.
signal flag_changed(flag: Flag, value: bool)

## Emitted by the Enemy instance 
## when the instance spots the player,
##
## May be listened to by objects which use the information
## on currently chasing enemies
signal start_player_chase(enemy: Enemy)

## Emitted by the Enemy instance 
## when the instance loses focus on the player,
##
## May be listened to by objects which use the information
## on currently chasing enemies
signal stop_player_chase(enemy: Enemy)
