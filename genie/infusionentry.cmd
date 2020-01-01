action setvariable aspect.light dolphin when the image of a deer drinking from a flowing stream
action setvariable aspect.light panther when the image of a cluster of twinkling stars
action setvariable aspect.light cat when the image of a grimacing woman in the throes of childbirth
action setvariable aspect.light ram when the image of a flourishing rose garden
action setvariable aspect.light cobra when the image of a shattered egg
action setvariable aspect.light wolf when the image of a charred black stave
action setvariable aspect.light boar when the image of a longbow
action setvariable aspect.light raven when the image of a bowl of striped peppermint
action setvariable aspect.light lion when the image of a pack of well-groomed battle hounds
action setvariable aspect.light wren when the image of a plump opera singer
action setvariable aspect.dark dolphin when the image of a great tidal wave
action setvariable aspect.dark panther when the image of a child shivering fearfully in the throes of a nightmare
action setvariable aspect.dark cat when image of a pair of twin crossed swords with jagged blades
action setvariable aspect.dark ram when the image of a jagged crystalline blade
action setvariable aspect.dark cobra when the image of an erupting volcano
action setvariable aspect.dark wolf when the image of a long flowing skirt
action setvariable aspect.dark boar when the image of a berserking barbarian
action setvariable aspect.dark raven when the image of a shattered caravan wheel
action setvariable aspect.dark lion when the image of a bloodstained stiletto
action setvariable aspect.dark wren when the image of a cracked mirror
action setvariable aspect $1 when (dolphin|panther|cat|ram|cobra|wolf|boar|raven|lion|wren)
action setvariable coffin.ready $1 when bier bearing the image .* (dolphin|panther|cat|ram|cobra|wolf|boar|raven|lion|wren)
action setvariable coffin.ready no when A steel-reinforced ebony coffin hangs in the air 
action setvariable coffin.ready no when  A steel-reinforced ebony coffin lies on the floor near the biers


infusion:
#action (aspect) activate
put look sun
pause 0.5
put look star
pause 0.5
action remove (dolphin|panther|cat|ram|cobra|wolf|boar|raven|lion|wren)
pause 0.5
put look bier
pause 1
if %aspect = %coffin.ready then goto coffinready
pause 0.5
put turn crank
pause 0.5
pause 0.5
move s
move go white tap
gosub aspect.light.look
move se
move go black tap
gosub aspect.dark.look
move sw
move n
put pull lev
pause 0.5
pause 0.5
put look bier
if %aspect = %coffin.ready then goto coffinready
goto infusion

aspect.light.look:
	put look wheel
	pause 1
	if %aspect = %aspect.light then goto return
	gosub pull.rope 
	goto aspect.light.look

aspect.dark.look:
	put look wheel
	pause 1
	if %aspect = %aspect.dark then goto return
	gosub pull.rope
	goto aspect.dark.look

pull.rope:
	put pull rope
	match return grinding
	match return wheel turns
	match return heave the wheel
	match pull.rope You'll have to get a better grip 
	matchwait 

coffinready:
put open coffin
pause 0.1
pause 0.1
put go coffin
pause 0.1
pause 0.1
put close coffin
waitforre You suddenly feel the presence of cold stone beneath you
stunwait:
if $stunned then 
	{
	pause 5
	goto stunwait
	}
if $prone then put stand
put #parse MOVE SUCCESSFUL