/obj/item/pen/crayon/red
	icon_state = "crayonred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/pen/crayon/orange
	icon_state = "crayonorange"
	colour = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"

/obj/item/pen/crayon/yellow
	icon_state = "crayonyellow"
	colour = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/pen/crayon/green
	icon_state = "crayongreen"
	colour = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"

/obj/item/pen/crayon/blue
	icon_state = "crayonblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

/obj/item/pen/crayon/purple
	icon_state = "crayonpurple"
	colour = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"

/obj/item/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0

/obj/item/pen/crayon/mime/attack_self(mob/user)
	. = ..()
	if(.)
		return //inversion
	if(colour != "#FFFFFF" && shadeColour != "#000000")
		colour = "#FFFFFF"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		colour = "#000000"
		shadeColour = "#FFFFFF"
		to_chat(user, "You will now draw in black and white with this crayon.")
	return

/obj/item/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	colour = "#FFF000"
	shadeColour = "#000FFF"
	colourName = "rainbow"
	uses = 0

/obj/item/pen/crayon/rainbow/attack_self(mob/user)
	. = ..()
	if(.)
		return
	colour = input(user, "Please select the main colour.", "Crayon colour") as color
	shadeColour = input(user, "Please select the shade colour.", "Crayon colour") as color
	return

/obj/item/pen/crayon/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("graffiti","rune","letter","arrow")
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				to_chat(user, "You start drawing a letter on the [target.name].")
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				to_chat(user, "You start drawing an arrow on the [target.name].")
		if(instant || do_after(user, 50))
			if(!user.Adjacent(target))
				return
			new /obj/effect/debris/cleanable/crayon(target,colour,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			log_game("[key_name(user)] drew [target], [colour], [shadeColour], [drawtype] with a crayon.")
			if(uses)
				uses--
				if(!uses)
					to_chat(user, "<span class='warning'>You used up your crayon!</span>")
					qdel(src)
	return

/obj/item/pen/crayon/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(target == user)
		to_chat(user, "You take a bite of the crayon and swallow it.")
		user.nutrition += 1
		user.reagents.add_reagent("crayon_dust",min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user,"<span class='warning'>You ate your crayon!</span>")
				qdel(src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/item/pen/crayon/marker/black
	icon_state = "markerblack"
	colour = "#2D2D2D"
	shadeColour = "#000000"
	colourName = "black"

/obj/item/pen/crayon/marker/red
	icon_state = "markerred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/pen/crayon/marker/orange
	icon_state = "markerorange"
	colour = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"

/obj/item/pen/crayon/marker/yellow
	icon_state = "markeryellow"
	colour = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/pen/crayon/marker/green
	icon_state = "markergreen"
	colour = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"

/obj/item/pen/crayon/marker/blue
	icon_state = "markerblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

/obj/item/pen/crayon/marker/purple
	icon_state = "markerpurple"
	colour = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"

/obj/item/pen/crayon/marker/mime
	icon_state = "markermime"
	desc = "A very sad-looking marker."
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0

/obj/item/pen/crayon/marker/mime/attack_self(mob/user)
	. = ..()
	if(.)
		return //inversion
	if(colour != "#FFFFFF" && shadeColour != "#000000")
		colour = "#FFFFFF"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this marker.")
	else
		colour = "#000000"
		shadeColour = "#FFFFFF"
		to_chat(user, "You will now draw in black and white with this marker.")
	return

/obj/item/pen/crayon/marker/rainbow
	icon_state = "markerrainbow"
	colour = "#FFF000"
	shadeColour = "#000FFF"
	colourName = "rainbow"
	uses = 0

/obj/item/pen/crayon/marker/rainbow/attack_self(mob/user)
	. = ..()
	if(.)
		return
	colour = input(user, "Please select the main colour.", "Marker colour") as color
	shadeColour = input(user, "Please select the shade colour.", "Marker colour") as color
	return

/obj/item/pen/crayon/marker/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(target == user)
		to_chat(user, "You take a bite of the marker and swallow it.")
		user.nutrition += 1
		user.reagents.add_reagent("marker_ink",6)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user,"<span class='warning'>You ate the marker!</span>")
				qdel(src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

//Ritual Chalk
/obj/item/pen/crayon/chalk/white
	icon_state = "chalkwhite"
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "white"

/obj/item/pen/crayon/chalk/red
	icon_state = "chalkred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/pen/crayon/chalk/black
	icon_state = "chalkblack"
	colour = "#2D2D2D"
	shadeColour = "#000000"
	colourName = "black"

/obj/item/pen/crayon/chalk/blue
	icon_state = "chalkblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

/obj/item/pen/crayon/chalk/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/drawtype = input("Choose what you'd like to draw.") in list("graffiti","rune")
		switch(drawtype)
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
		if(instant || do_after(user, 50))
			if(!user.Adjacent(target))
				return
			new /obj/effect/debris/cleanable/crayon/chalk(target,colour,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the chalk is drawn on.
			log_game("[key_name(user)] drew [target], [colour], [shadeColour], [drawtype] with chalk.")
			if(uses)
				uses--
				if(!uses)
					to_chat(user, "<span class='warning'>You used up your chalk!</span>")
					qdel(src)
	return

/obj/item/pen/crayon/chalk/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(target == user)
		to_chat(user, "You take a bite of the chalk and swallow it.")
		user.nutrition += 1
		user.reagents.add_reagent("chalk_dust",min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user,"<span class='warning'>You ate your chalk!</span>")
				qdel(src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()
