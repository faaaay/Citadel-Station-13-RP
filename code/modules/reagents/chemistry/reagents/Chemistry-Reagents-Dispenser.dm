/datum/reagent/aluminum
	name = "Aluminum"
	id = "aluminum"
	description = "A silvery white and ductile member of the boron group of chemical elements."
	taste_description = "metal"
	taste_mult = 1.1
	reagent_state = REAGENT_SOLID
	color = "#A8A8A8"

/datum/reagent/calcium
	name = "Calcium"
	id = "calcium"
	description = "A chemical element, the building block of bones."
	taste_description = "metallic chalk" // Apparently, calcium tastes like calcium.
	taste_mult = 1.3
	reagent_state = REAGENT_SOLID
	color = "#e9e6e4"

/datum/reagent/carbon
	name = "Carbon"
	id = "carbon"
	description = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	reagent_state = REAGENT_SOLID
	color = "#1C1300"
	ingest_met = REM * 5

/datum/reagent/carbon/affect_ingest(mob/living/carbon/M, alien, removed)
	if(alien == IS_DIONA)
		return
	if(M.ingested && M.ingested.reagent_list.len > 1) // Need to have at least 2 reagents - cabon and something to remove
		var/effect = 1 / (M.ingested.reagent_list.len - 1)
		for(var/datum/reagent/R in M.ingested.reagent_list)
			if(R == src)
				continue
			M.ingested.remove_reagent(R.id, removed * effect)

/datum/reagent/carbon/touch_turf(turf/T)
	if(!istype(T, /turf/space))
		var/obj/effect/debris/cleanable/dirt/dirtoverlay = locate(/obj/effect/debris/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/debris/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)

/datum/reagent/chlorine
	name = "Chlorine"
	id = "chlorine"
	description = "A chemical element with a characteristic odour."
	taste_description = "pool water"
	reagent_state = REAGENT_GAS
	color = "#d1db77"

/datum/reagent/chlorine/affect_blood(mob/living/carbon/M, alien, removed)
	M.take_organ_damage(1*REM, 0)

/datum/reagent/chlorine/affect_touch(mob/living/carbon/M, alien, removed)
	M.take_organ_damage(1*REM, 0)

/datum/reagent/copper
	name = "Copper"
	id = "copper"
	description = "A highly ductile metal."
	taste_description = "pennies"
	color = "#6E3B08"

/datum/reagent/ethanol
	name = "Ethanol" //Parent class for all alcoholic reagents.
	id = "ethanol"
	description = "A well-known alcohol with a variety of applications."
	taste_description = "pure alcohol"
	reagent_state = REAGENT_LIQUID
	color = "#404030"

	ingest_met = REM * 2

	var/nutriment_factor = 0
	var/hydration_factor = 0
	var/strength = 10 // This is, essentially, units between stages - the lower, the stronger. Less fine tuning, more clarity.
	var/toxicity = 1

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0

	glass_name = "ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."

/datum/reagent/ethanol/touch_mob(mob/living/L, amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 15)

/datum/reagent/ethanol/affect_blood(mob/living/carbon/M, alien, removed) //This used to do just toxin. That's boring. Let's make this FUN.
	if(issmall(M)) removed *= 2
	var/strength_mod = 3 //Alcohol is 3x stronger when injected into the veins.
	if(alien == IS_SKRELL)
		strength_mod *= 5
	if(alien == IS_TAJARA)
		strength_mod *= 1.25
	if(alien == IS_UNATHI)
		strength_mod *= 0.75
	if(alien == IS_DIONA)
		strength_mod = 0
	if(alien == IS_SLIME)
		strength_mod *= 2
	if(alien == IS_ALRAUNE)
		if(prob(5))
			to_chat(M, "<span class='danger'>You feel your leaves start to wilt.</span>")
		strength_mod *=5 //cit change - alcohol ain't good for plants

	var/effective_dose = dose * strength_mod * (1 + volume/60) //drinking a LOT will make you go down faster
	M.add_chemical_effect(CE_ALCOHOL, 1)
	if(HAS_TRAIT(M, TRAIT_ALCOHOL_INTOLERANT))
		if(prob(effective_dose/2))
			M.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		M.adjustToxLoss(effective_dose/2)
		return 0
	if(effective_dose >= strength) // Early warning
		M.make_dizzy(18) // It is decreased at the speed of 3 per tick
	if(effective_dose >= strength * 2) // Slurring
		M.slurring = max(M.slurring, 90)
	if(effective_dose >= strength * 3) // Confusion - walking in random directions
		M.Confuse(60)
	if(effective_dose >= strength * 4) // Blurry vision
		M.eye_blurry = max(M.eye_blurry, 30)
	if(effective_dose >= strength * 5) // Drowsyness - periodically falling asleep
		M.drowsyness = max(M.drowsyness, 60)
	if(effective_dose >= strength * 6) // Toxic dose
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, toxicity*3)
	if(effective_dose >= strength * 7) // Pass out
		M.afflict_unconscious(20 * 60)
		M.afflict_sleeping(20 * 90)

	if(druggy != 0)
		M.druggy = max(M.druggy, druggy*3)

	if(adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		M.hallucination = max(M.hallucination, halluci*3)
	return effective_dose

/datum/reagent/ethanol/affect_ingest(mob/living/carbon/M, alien, removed)
	if(issmall(M)) removed *= 2
	M.adjust_nutrition(nutriment_factor * removed)
	M.adjust_hydration(hydration_factor * removed)
	var/strength_mod = 1
	if(alien == IS_SKRELL)
		strength_mod *= 5
	if(alien == IS_TAJARA)
		strength_mod *= 1.25
	if(alien == IS_UNATHI)
		strength_mod *= 0.75
	if(alien == IS_DIONA)
		strength_mod = 0
	if(alien == IS_SLIME)
		strength_mod *= 2
	var/is_vampire = M.species.is_vampire
	if(is_vampire)
		handle_vampire(M, alien, removed, is_vampire)

	var/effective_dose = strength_mod * dose // this was being recalculated a bunch before--why?
	if(HAS_TRAIT(M, TRAIT_ALCOHOL_INTOLERANT))
		if(prob(effective_dose/2))
			M.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		M.adjustToxLoss(effective_dose/2)
		return 0
	M.add_chemical_effect(CE_ALCOHOL, 1)
	if(effective_dose >= strength) // Early warning
		M.make_dizzy(6) // It is decreased at the speed of 3 per tick
	if(effective_dose >= strength * 2) // Slurring
		M.slurring = max(M.slurring, 30)
	if(effective_dose >= strength * 3) // Confusion - walking in random directions
		M.Confuse(20)
	if(effective_dose >= strength * 4) // Blurry vision
		M.eye_blurry = max(M.eye_blurry, 10)
	if(effective_dose >= strength * 5) // Drowsyness - periodically falling asleep
		M.drowsyness = max(M.drowsyness, 20)
	if(effective_dose >= strength * 6) // Toxic dose
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, toxicity)
	if(effective_dose >= strength * 7) // Pass out
		M.afflict_unconscious(20 * 20)
		M.afflict_sleeping(20 * 30)

	if(druggy != 0)
		M.druggy = max(M.druggy, druggy)

	if(adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		M.hallucination = max(M.hallucination, halluci)
	return effective_dose

/datum/reagent/ethanol/touch_obj(obj/O)
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(volume < 5)
			return
		if(istype(O, /obj/item/book/tome))
			to_chat(usr, "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>")
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		to_chat(usr, "<span class='notice'>The solution dissolves the ink on the book.</span>")
	return

/datum/reagent/fluorine
	name = "Fluorine"
	id = "fluorine"
	description = "A highly-reactive chemical element."
	taste_description = "acid"
	reagent_state = REAGENT_GAS
	color = "#808080"

/datum/reagent/fluorine/affect_blood(mob/living/carbon/M, alien, removed)
	M.adjustToxLoss(removed)

/datum/reagent/fluorine/affect_touch(mob/living/carbon/M, alien, removed)
	M.adjustToxLoss(removed)

/datum/reagent/hydrogen
	name = "Hydrogen"
	id = "hydrogen"
	description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
	taste_mult = 0 //no taste
	reagent_state = REAGENT_GAS
	color = "#808080"

/datum/reagent/iron
	name = "Iron"
	id = "iron"
	description = "Pure iron is a metal."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#353535"

/datum/reagent/iron/affect_ingest(mob/living/carbon/M, alien, removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed)

/datum/reagent/lithium
	name = "Lithium"
	id = "lithium"
	description = "A chemical element, used as antidepressant."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#808080"

/datum/reagent/lithium/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien != IS_DIONA)
		if(CHECK_MOBILITY(M, MOBILITY_CAN_MOVE) && istype(M.loc, /turf/space))
			step(M, pick(GLOB.cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))

/datum/reagent/mercury
	name = "Mercury"
	id = "mercury"
	description = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	reagent_state = REAGENT_LIQUID
	color = "#484848"

/datum/reagent/mercury/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien != IS_DIONA)
		if(CHECK_MOBILITY(M, MOBILITY_CAN_MOVE) && istype(M.loc, /turf/space))
			step(M, pick(GLOB.cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))
		M.adjustBrainLoss(0.1)

/datum/reagent/nitrogen
	name = "Nitrogen"
	id = "nitrogen"
	description = "A colorless, odorless, tasteless gas."
	taste_mult = 0 //no taste
	reagent_state = REAGENT_GAS
	color = "#808080"

/datum/reagent/oxygen
	name = "Oxygen"
	id = "oxygen"
	description = "A colorless, odorless gas."
	taste_mult = 0
	reagent_state = REAGENT_GAS
	color = "#808080"

/datum/reagent/oxygen/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 3)

/datum/reagent/phosphorus
	name = "Phosphorus"
	id = "phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	reagent_state = REAGENT_SOLID
	color = "#832828"

/datum/reagent/phosphorus/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien == IS_ALRAUNE)
		if(prob(5))
			to_chat(M, "<span class='vox'>You feel a rush of nutrients fill your body.</span>")
		M.nutrition += removed * 2 //cit change - phosphorus is good for plants

/datum/reagent/potassium
	name = "Potassium"
	id = "potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	reagent_state = REAGENT_SOLID
	color = "#A0A0A0"

/datum/reagent/radium
	name = "Radium"
	id = "radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	taste_mult = 0	//Apparently radium is tasteless
	reagent_state = REAGENT_SOLID
	color = "#C7C7C7"

/datum/reagent/radium/affect_blood(mob/living/carbon/M, alien, removed)
	if(issmall(M))
		removed *= 2
	M.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_RADIUM(removed))
	if(M.virus2.len)
		for(var/ID in M.virus2)
			var/datum/disease2/disease/V = M.virus2[ID]
			if(prob(5))
				M.antibodies |= V.antigen

/datum/reagent/radium/touch_turf(turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/debris/cleanable/greenglow/glow = locate(/obj/effect/debris/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/debris/cleanable/greenglow(T)
			return

/datum/reagent/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	reagent_state = REAGENT_LIQUID
	color = "#DB5008"
	metabolism = REM * 2
	touch_met = 50 // It's acid!
	var/power = 5
	var/meltdose = 10 // How much is needed to melt

/datum/reagent/acid/affect_blood(mob/living/carbon/M, alien, removed)
	if(issmall(M)) removed *= 2
	M.take_organ_damage(0, removed * power * 2)

/datum/reagent/acid/affect_touch(mob/living/carbon/M, alien, removed) // This is the most interesting
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.unacidable)
				to_chat(H, "<span class='danger'>Your [H.head] protects you from the acid.</span>")
				remove_self(volume)
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.head] melts away!</span>")
				qdel(H.head)
				H.update_inv_head(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.wear_mask)
			if(H.wear_mask.unacidable)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] protects you from the acid.</span>")
				remove_self(volume)
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] melts away!</span>")
				qdel(H.wear_mask)
				H.update_inv_wear_mask(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.glasses)
			if(H.glasses.unacidable)
				to_chat(H, "<span class='danger'>Your [H.glasses] partially protect you from the acid!</span>")
				removed /= 2
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.glasses] melt away!</span>")
				qdel(H.glasses)
				H.update_inv_glasses(1)
				removed -= meltdose / 2
		if(removed <= 0)
			return

	if(volume < meltdose) // Not enough to melt anything
		M.take_organ_damage(0, removed * power * 0.2) //burn damage, since it causes chemical burns. Acid doesn't make bones shatter, like brute trauma would.
		return
	if(!M.unacidable && removed > 0)
		if(istype(M, /mob/living/carbon/human) && volume >= meltdose)
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
			if(affecting)
				if(affecting.take_damage(0, removed * power * 0.1))
					H.UpdateDamageIcon()
				if(prob(100 * removed / meltdose)) // Applies disfigurement
					if (affecting.organ_can_feel_pain())
						H.emote("scream")
		else
			M.take_organ_damage(0, removed * power * 0.1) // Balance. The damage is instant, so it's weaker. 10 units -> 5 damage, double for pacid. 120 units beaker could deal 60, but a) it's burn, which is not as dangerous, b) it's a one-use weapon, c) missing with it will splash it over the ground and d) clothes give some protection, so not everything will hit

/datum/reagent/acid/touch_obj(obj/O)
	if(O.unacidable)
		return
	if((istype(O, /obj/item) || istype(O, /obj/effect/plant)) && (volume > meltdose))
		var/obj/effect/debris/cleanable/molten_item/I = new/obj/effect/debris/cleanable/molten_item(O.loc)
		I.desc = "Looks like this was \an [O] some time ago."
		for(var/mob/M in viewers(5, O))
			to_chat(M, "<span class='warning'>\The [O] melts.</span>")
		qdel(O)
		remove_self(meltdose) // 10 units of acid will not melt EVERYTHING on the tile

/datum/reagent/silicon
	name = "Silicon"
	id = "silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	taste_mult = 0
	reagent_state = REAGENT_SOLID
	color = "#A8A8A8"

/datum/reagent/sodium
	name = "Sodium"
	id = "sodium"
	description = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	reagent_state = REAGENT_SOLID
	color = "#808080"

/datum/reagent/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	taste_description = "sugar"
	taste_mult = 1.8
	reagent_state = REAGENT_SOLID
	color = "#FFFFFF"

	glass_name = "sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	glass_icon = DRINK_ICON_NOISY

/datum/reagent/sugar/affect_blood(mob/living/carbon/M, alien, removed)
	M.nutrition += removed * 3

	var/effective_dose = dose
	if(issmall(M))
		effective_dose *= 2

	if(alien == IS_UNATHI)
		if(effective_dose < 2)
			if(effective_dose == metabolism * 2 || prob(5))
				M.emote("yawn")
		else if(effective_dose < 5)
			M.eye_blurry = max(M.eye_blurry, 10)
		else if(effective_dose < 20)
			if(prob(50))
				M.afflict_paralyze(20 * 2)
			M.drowsyness = max(M.drowsyness, 20)
		else
			M.afflict_sleeping(20 * 20)
			M.drowsyness = max(M.drowsyness, 60)

	if(alien == IS_ALRAUNE) //cit change - too much sugar isn't good for plants
		if(effective_dose < 2)
			if(prob(5))
				to_chat(M, "<span class='danger'>You feel an imbalance of energy.</span>")
			M.make_jittery(4)

/datum/reagent/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	reagent_state = REAGENT_SOLID
	color = "#BF8C00"

/datum/reagent/tungsten
	name = "Tungsten"
	id = "tungsten"
	description = "A chemical element, and a strong oxidising agent."
	taste_description = "metal"
	taste_mult = 0 //no taste
	reagent_state = REAGENT_SOLID
	color = "#DCDCDC"
