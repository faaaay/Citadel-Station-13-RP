/datum/tgui_module_old/rcon
	name = "Power RCON"
	tgui_id = "RCON"

	var/list/known_SMESs = null
	var/list/known_breakers = null

/datum/tgui_module_old/rcon/ui_data(mob/user)
	FindDevices() // Update our devices list
	var/list/data = ..()

	// SMES DATA (simplified view)
	var/list/smeslist[0]
	for(var/obj/machinery/power/smes/buildable/SMES in known_SMESs)
		var/list/smes_data = SMES.ui_data()
		smes_data["RCON_tag"] = SMES.RCon_tag
		smeslist.Add(list(smes_data))

	data["smes_info"] = sortByKey(smeslist, "RCON_tag")

	// BREAKER DATA (simplified view)
	var/list/breakerlist[0]
	for(var/obj/machinery/power/breakerbox/BR in known_breakers)
		breakerlist.Add(list(list(
		"RCON_tag" = BR.RCon_tag,
		"enabled" = BR.on
		)))
	data["breaker_info"] = breakerlist

	return data

/datum/tgui_module_old/rcon/ui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("smes_in_toggle")
			var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(params["smes"])
			if(SMES)
				SMES.toggle_input()
			. = TRUE
		if("smes_out_toggle")
			var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(params["smes"])
			if(SMES)
				SMES.toggle_output()
			. = TRUE
		if("smes_in_set")
			var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(params["smes"])
			if(SMES)
				SMES.ui_set_io(SMES_UI_INPUT, params["target"], text2num(params["adjust"]))
				// var/inputset = (input(usr, "Enter new input level (0-[SMES.input_level_max/1000] kW)", "SMES Input Power Control", SMES.input_level/1000) as num) * 1000
				// SMES.set_input(inputset)
			. = TRUE
		if("smes_out_set")
			var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(params["smes"])
			if(SMES)
				SMES.ui_set_io(SMES_UI_OUTPUT, params["target"], text2num(params["adjust"]))
				// var/outputset = (input(usr, "Enter new output level (0-[SMES.output_level_max/1000] kW)", "SMES Output Power Control", SMES.output_level/1000) as num) * 1000
				// SMES.set_output(outputset)
			. = TRUE
		if("toggle_breaker")
			var/obj/machinery/power/breakerbox/toggle = null
			for(var/obj/machinery/power/breakerbox/breaker in known_breakers)
				if(breaker.RCon_tag == params["breaker"])
					toggle = breaker
			if(toggle)
				if(toggle.update_locked)
					to_chat(usr, "The breaker box was recently toggled. Please wait before toggling it again.")
				else
					toggle.auto_toggle()
			. = TRUE


// Proc: GetSMESByTag()
// Parameters: 1 (tag - RCON tag of SMES we want to look up)
// Description: Looks up and returns SMES which has matching RCON tag
/datum/tgui_module_old/rcon/proc/GetSMESByTag(var/tag)
	if(!tag)
		return

	for(var/obj/machinery/power/smes/buildable/S in known_SMESs)
		if(S.RCon_tag == tag)
			return S

// Proc: FindDevices()
// Parameters: None
// Description: Refreshes local list of known devices.
/datum/tgui_module_old/rcon/proc/FindDevices()
	known_SMESs = new /list()

	var/z = get_z(ui_host())
	var/list/map_levels = GLOB.using_map.get_map_levels(z)

	for(var/obj/machinery/power/smes/buildable/SMES in GLOB.smeses)
		if(!(SMES.z in map_levels))
			continue
		if(SMES.RCon_tag && (SMES.RCon_tag != "NO_TAG") && SMES.RCon)
			known_SMESs.Add(SMES)

	known_breakers = new /list()
	for(var/obj/machinery/power/breakerbox/breaker in GLOB.machines)
		if(!(breaker.z in map_levels))
			continue
		if(breaker.RCon_tag != "NO_TAG")
			known_breakers.Add(breaker)

/datum/tgui_module_old/rcon/ntos
	ntos = TRUE

/datum/tgui_module_old/rcon/robot
/datum/tgui_module_old/rcon/robot/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.self_state
