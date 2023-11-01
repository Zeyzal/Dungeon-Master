atom/var
	Strength
	Agility
	Defence

var/ExperienceMultiplier=1
mob/proc/GainEXP(XP)
	if(CanBeSlaved) EXP+=(XP*ExperienceMultiplier)/2
	else EXP+=XP*ExperienceMultiplier
	LevelUp()
mob/proc/LevelUp()
	if(Level >= 100) return
	while(EXP >= EXPNeeded)
		if(Level >= 100) break
		EXP -= EXPNeeded
		EXPNeeded += 50
		EXPNeeded += Level / 3
		Level += 1
		Owner << "[src] has reached level [Level]!"
		switch(Race)
			if("Dwarf","Demon","Gargoyle","Frogman","Dragon","Svartalfar") OrganMaxHP+=2.25
			if("Vampire","Lizardman","Demon","Orc","Gargoyle","Human","Goblin") OrganMaxHP+=2
			if("Ratman","Illithid","Elf","Kobold","Zombie") OrganMaxHP+=1.75
			//if() OrganMaxHP += 1.5 - For future use
			if("Spider") OrganMaxHP += 1
			else OrganMaxHP += rand(0.75,1)
		if(OrganMaxHP > 300) OrganMaxHP = 400
		var/STR=pick(1,1.25)
		var/AGL=pick(1,1.25)
		var/INT=pick(0.01,0.02)

		var/DEF=0

		var/WEI=pick(15,20)
		var/POI=0
		var/WEB=0

		var/MIN=0
		var/MAX=0
		switch(Race)
			if("Devourer")
				STR+=0.75
				AGL+=0.75
				WEI+=5
				MIN+=0.4
				MAX+=0.4
			if("Skeleton")
				MIN+=0.1
				MAX+=0.1
				DEF+=1
			if("Zombie")
				STR+=0.25
				AGL+=0.25
				WEI+=5
			if("Illithid")
				STR+=0.5
				AGL+=0.75
				WEI+=5
			if("Kobold")
				AGL+=1.5
			if("Ratman")
				AGL+=1.75
				WEI-=5
			if("Goblin","Frogman")
				STR += 0.25
				AGL+=1
				if (Level == 10) Delay -= 1
			if("Human")
				STR+=0.5
				AGL+=0.75
				WEI+=10
			if("Elf")
				STR+=0.5
				AGL+=1.25
				WEI+=5
				INT+=pick(0.25,0.35)
			if("Lizardman")
				STR+=1
				AGL+=0.25
				WEI+=10
				POI+=0.25
				if(SubRace!="HalfDemon") if(Level<=40) DEF+=0.2
			if("Orc")
				STR+=1
				AGL+=1
				WEI+=15
			if("Dwarf")
				STR+=1
				WEI+=30
			if("Gargoyle")
				STR+=1.25
				AGL-=0.05
				DEF += 0.75
				WEI+=25
			if("Svartalfar")
				STR+=1.25
				AGL+=1.25
				WEI+=25
				INT+=0.2
			if("Demon")
				STR+=2
				AGL+=2
				WEI+=30
			if("Dragon")
				CheckDragonElement()
				STR+=1.3
				AGL+=0.6
				POI+=1
				WEI+=25
				DEF+=1.15
				MIN+=0.5
				MAX+=0.5
			if("Spider") switch(SubRace)
				if("Queen")
					POI+=1
					STR+=1.5
					AGL+=1.5
					WEB+=20
					MIN+=0.5
					MAX+=0.75
				if("Warrior")
					STR+=1.25
					AGL+=1
					MIN+=0.25
					MAX+=0.5
				if("Worker")
					STR+=0.75
					AGL+=0.75
					WEI+=30
					WEB+=5
				if("Hunter")
					STR+=0.25
					AGL+=1
					WEB+=1
					POI+=0.75
			if("Vampire")
				STR+=1.5
				AGL+=1.5
				WEI+=20
				VampireEvolution()
		switch(SubRace)
			if("HalfDemon")
				STR+=0.25
				AGL+=0.25
				DEF+=0.2
				WEI+=5
				INT+=0.01
			if("Werewolf")
				STR+=0.25
				AGL+=0.25
				WEI+=5
		Strength+=STR
		Agility+=AGL
		Intelligence+=INT

		Defence+=DEF

		if(Flying||IsMist) Old+=WEI
		else weightmax+=WEI

		PoisonDMG+=POI
		WebContent+=WEB
		MaxWebContent+=WEB

		WeaponDamageMin+=MIN
		WeaponDamageMax+=MAX
	var/MaxStrength=120
	var/MaxAgility=120
	switch(Race)
		if("Kobold","Ratman") MaxAgility+=20
		if("Dwarf", "Gargoyle")
			MaxStrength+=15
			MaxAgility-=5
		if("Vampire", "Orc")
			MaxStrength+=10
		if("Dragon", "Svartalfar")
			MaxStrength += 25
			MaxAgility += 25
	switch(SubRace)
		if("Werewolf")
			MaxStrength+=5
			MaxAgility+=5
		//Spiders
		if("Warrior")
			MaxStrength+=10
			MaxAgility-=10
		if("Worker")
			MaxStrength-=20
			MaxAgility-=20
		if("Hunter")
			MaxStrength-=45
			MaxAgility+=10
	if(IsRoyal)
		MaxStrength+=30
		MaxAgility+=30
	if(Werepowers)
		MaxStrength+=10
		MaxAgility+=10
	if(Strength>MaxStrength) Strength=MaxStrength
	if(Agility>MaxAgility) Agility=MaxAgility