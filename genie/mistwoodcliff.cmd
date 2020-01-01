#debug 10
#---------------------------------------
# INCLUDES
#---------------------------------------
goto SubSkip
#---------------------------------------
# Local Subroutines
#---------------------------------------

SubSkip:

#---------------------------------------
# CONSTANT VARIABLES
#---------------------------------------

#---------------------------------------
# VARIABLES
#---------------------------------------

#---------------------------------------
# ACTIONS
#---------------------------------------
	action var Dir $1 when ^Peering closely at a faint path, you realize you would need to head (\w+)\.
#---------------------------------------
# SCRIPT START
#---------------------------------------
	put peer path
	waitforre Peering closely at
	put down
     waitforre ^You also see|^Obvious|Clusters
	put %Dir
     pause 0.3
     pause 0.2
	put nw
	waitforre ^Birds chitter in the branches
	pause
	put #parse MOVE SUCCESSFUL
	