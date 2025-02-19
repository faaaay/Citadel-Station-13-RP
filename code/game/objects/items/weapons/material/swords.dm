/obj/item/material/sword
	name = "claymore"
	desc = "From the former island nation of Britain, comes this enduring design. The claymore's long, heavy blade rewards large sweeping strikes, provided one can even lift this heavy weapon."
	icon_state = "claymore"
	slot_flags = SLOT_BELT
	force_divisor = 0.5 // 30 when wielded with hardnes 60 (steel)
	thrown_force_divisor = 0.5 // 10 when thrown with weight 20 (steel)
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'

/obj/item/material/sword/plasteel
	default_material = "plasteel"

/obj/item/material/sword/durasteel
	default_material = "durasteel"

/obj/item/material/sword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(unique_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/material/sword/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	viewers(user) << "<span class='danger'>[user] is falling on the [src.name]! It looks like [TU.he] [TU.is] trying to commit suicide.</span>"
	return(BRUTELOSS)

/obj/item/material/sword/katana
	name = "katana"
	desc = "An ancient Terran weapon, from a former island nation. This sharp blade requires skill to use properly. Despite the number of flash-forged knock-offs flooding the market, this looks like the real deal."
	icon_state = "katana"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/material/sword/katana/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	visible_message(SPAN_DANGER("[user] is slitting [TU.his] stomach open with \the [src.name]! It looks like [TU.hes] trying to commit seppuku."), SPAN_DANGER("You slit your stomach open with \the [src.name]!"), SPAN_DANGER("You hear the sound of flesh tearing open.")) // gory, but it gets the point across
	return(BRUTELOSS)

/obj/item/material/sword/katana/plasteel
	default_material = "plasteel"

/obj/item/material/sword/katana/durasteel
	default_material = "durasteel"
