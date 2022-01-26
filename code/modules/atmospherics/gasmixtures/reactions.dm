//All defines used in reactions are located in ..\__DEFINES\reactions.dm

/proc/init_gas_reactions()
	. = list()

	for(var/r in subtypesof(/datum/gas_reaction))
		var/datum/gas_reaction/reaction = r
		if(initial(reaction.exclude))
			continue
		reaction = new r
		var/datum/gas/reaction_key
		for (var/req in reaction.min_requirements)
			if (ispath(req))
				var/datum/gas/req_gas = req
				if (!reaction_key || initial(reaction_key.rarity) > initial(req_gas.rarity))
					reaction_key = req_gas
		reaction.major_gas = reaction_key
		. += reaction

	//white
	. += get_gas_recipe_reactions()

	sortTim(., /proc/cmp_gas_reaction)

/proc/cmp_gas_reaction(datum/gas_reaction/a, datum/gas_reaction/b) // compares lists of reactions by the maximum priority contained within the list
	return b.priority - a.priority

/datum/gas_reaction
	//regarding the requirements lists: the minimum or maximum requirements must be non-zero.
	//when in doubt, use MINIMUM_MOLE_COUNT.
	var/list/min_requirements
	var/major_gas //the highest rarity gas used in the reaction.
	var/exclude = FALSE //do it this way to allow for addition/removal of reactions midmatch in the future
	var/priority = 100 //lower numbers are checked/react later than higher numbers. if two reactions have the same priority they may happen in either order
	var/name = "reaction"
	var/id = "r"

/datum/gas_reaction/New()
	init_reqs()

/datum/gas_reaction/proc/init_reqs()

/datum/gas_reaction/proc/react(datum/gas_mixture/air, atom/location)
	return NO_REACTION

/datum/gas_reaction/nobliumsupression
	priority = INFINITY
	name = "Hyper-Noblium Reaction Suppression"
	id = "nobstop"

/datum/gas_reaction/nobliumsupression/init_reqs()
	min_requirements = list(
		/datum/gas/hypernoblium = REACTION_OPPRESSION_THRESHOLD,
		"TEMP" = 20
	)

/datum/gas_reaction/nobliumsupression/react()
	return STOP_REACTIONS

//water vapor: puts out fires?
/datum/gas_reaction/water_vapor
	priority = 1
	name = "Water Vapor"
	id = "vapor"

/datum/gas_reaction/water_vapor/init_reqs()
	min_requirements = list(/datum/gas/water_vapor = MOLES_GAS_VISIBLE)

/datum/gas_reaction/water_vapor/react(datum/gas_mixture/air, datum/holder)
	var/turf/open/location = isturf(holder) ? holder : null
	. = NO_REACTION
	if (air.return_temperature() <= WATER_VAPOR_FREEZE)
		if(location?.freon_gas_act())
			. = REACTING
	else if(air.return_temperature() <= T20C + 10)
		if(location?.water_vapor_gas_act())
			air.adjust_moles(/datum/gas/water_vapor, -MOLES_GAS_VISIBLE)
			. = REACTING

//tritium combustion: combustion of oxygen and tritium (treated as hydrocarbons). creates hotspots. exothermic
/datum/gas_reaction/nitrous_decomp
	priority = 0
	name = "Nitrous Oxide Decomposition"
	id = "nitrous_decomp"

/datum/gas_reaction/nitrous_decomp/init_reqs()
	min_requirements = list(
		"TEMP" = N2O_DECOMPOSITION_MIN_ENERGY,
		/datum/gas/nitrous_oxide = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/nitrous_decomp/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	var/burned_fuel = 0


	burned_fuel = max(0,0.00002*(temperature-(0.00001*(temperature**2))))*air.get_moles(/datum/gas/nitrous_oxide)
	if(air.get_moles(/datum/gas/nitrous_oxide) - burned_fuel < 0)
		return NO_REACTION
	air.adjust_moles(/datum/gas/nitrous_oxide, -burned_fuel)

	if(burned_fuel)
		energy_released += (N2O_DECOMPOSITION_ENERGY_RELEASED * burned_fuel)

		air.adjust_moles(/datum/gas/oxygen, burned_fuel * 0.5)
		air.adjust_moles(/datum/gas/nitrogen, burned_fuel)

		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((temperature * old_heat_capacity + energy_released) / new_heat_capacity)
		return REACTING
	return NO_REACTION

//tritium combustion: combustion of oxygen and tritium (treated as hydrocarbons). creates hotspots. exothermic
/datum/gas_reaction/tritfire
	priority = -2 //fire should ALWAYS be last, but tritium fires happen before plasma fires
	name = "Tritium Combustion"
	id = "tritfire"

/datum/gas_reaction/tritfire/init_reqs()
	min_requirements = list(
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST,
		/datum/gas/tritium = MINIMUM_MOLE_COUNT,
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/tritfire/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	var/list/cached_results = air.reaction_results
	cached_results["fire"] = 0
	var/turf/open/location = isturf(holder) ? holder : null
	var/burned_fuel = 0
	var/initial_trit = air.get_moles(/datum/gas/tritium)// Yogs
	if(air.get_moles(/datum/gas/oxygen) < initial_trit || MINIMUM_TRIT_OXYBURN_ENERGY > (temperature * old_heat_capacity))
		burned_fuel = air.get_moles(/datum/gas/oxygen)/TRITIUM_BURN_OXY_FACTOR
		if(burned_fuel > initial_trit) burned_fuel = initial_trit //Yogs -- prevents negative moles of Tritium
		air.adjust_moles(/datum/gas/tritium, -burned_fuel)
	else
		burned_fuel = initial_trit // Yogs -- Conservation of Mass fix
		air.set_moles(/datum/gas/tritium, air.get_moles(/datum/gas/tritium) * (1 - 1/TRITIUM_BURN_TRIT_FACTOR)) // Yogs -- Maybe a tiny performance boost? I'unno
		air.adjust_moles(/datum/gas/oxygen, -air.get_moles(/datum/gas/tritium))
		energy_released += (FIRE_HYDROGEN_ENERGY_RELEASED * burned_fuel * (TRITIUM_BURN_TRIT_FACTOR - 1)) // Yogs -- Fixes low-energy tritium fires

	if(burned_fuel)
		energy_released += (FIRE_HYDROGEN_ENERGY_RELEASED * burned_fuel)
		if(location && prob(10) && burned_fuel > TRITIUM_MINIMUM_RADIATION_ENERGY) //woah there let's not crash the server
			radiation_pulse(location, energy_released / TRITIUM_BURN_RADIOACTIVITY_FACTOR)

		//oxygen+more-or-less hydrogen=H2O
		air.adjust_moles(/datum/gas/water_vapor, burned_fuel)// Yogs -- Conservation of Mass

		cached_results["fire"] += burned_fuel

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((temperature * old_heat_capacity + energy_released) / new_heat_capacity)

	//let the floor know a fire is happening
	if(istype(location))
		temperature = air.return_temperature()
		if(temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
			location.hotspot_expose(temperature, CELL_VOLUME)

	return cached_results["fire"] ? REACTING : NO_REACTION

//plasma combustion: combustion of oxygen and plasma (treated as hydrocarbons). creates hotspots. exothermic
/datum/gas_reaction/plasmafire
	priority = -4 //fire should ALWAYS be last, but plasma fires happen after tritium fires
	name = "Plasma Combustion"
	id = "plasmafire"

/datum/gas_reaction/plasmafire/init_reqs()
	min_requirements = list(
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST,
		/datum/gas/plasma = MINIMUM_MOLE_COUNT,
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/plasmafire/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	var/list/cached_results = air.reaction_results
	cached_results["fire"] = 0
	var/turf/open/location = isturf(holder) ? holder : null

	//Handle plasma burning
	var/plasma_burn_rate = 0
	var/oxygen_burn_rate = 0
	//more plasma released at higher temperatures
	var/temperature_scale = 0
	//to make tritium
	var/super_saturation = FALSE

	if(temperature > PLASMA_UPPER_TEMPERATURE)
		temperature_scale = 1
	else
		temperature_scale = (temperature - PLASMA_MINIMUM_BURN_TEMPERATURE) / (PLASMA_UPPER_TEMPERATURE-PLASMA_MINIMUM_BURN_TEMPERATURE)
	if(temperature_scale > 0)
		oxygen_burn_rate = OXYGEN_BURN_RATE_BASE - temperature_scale
		if(air.get_moles(/datum/gas/oxygen) / air.get_moles(/datum/gas/plasma) > SUPER_SATURATION_THRESHOLD) //supersaturation. Form Tritium.
			super_saturation = TRUE
		if(air.get_moles(/datum/gas/oxygen) > air.get_moles(/datum/gas/plasma) * PLASMA_OXYGEN_FULLBURN)
			plasma_burn_rate = (air.get_moles(/datum/gas/plasma) * temperature_scale) / PLASMA_BURN_RATE_DELTA
		else
			plasma_burn_rate = (temperature_scale * (air.get_moles(/datum/gas/oxygen) / PLASMA_OXYGEN_FULLBURN)) / PLASMA_BURN_RATE_DELTA

		if(plasma_burn_rate > MINIMUM_HEAT_CAPACITY)
			plasma_burn_rate = min(plasma_burn_rate,air.get_moles(/datum/gas/plasma), air.get_moles(/datum/gas/oxygen) / oxygen_burn_rate) //Ensures matter is conserved properly
			air.set_moles(/datum/gas/plasma, QUANTIZE(air.get_moles(/datum/gas/plasma) - plasma_burn_rate))
			air.set_moles(/datum/gas/oxygen, QUANTIZE(air.get_moles(/datum/gas/oxygen) - (plasma_burn_rate * oxygen_burn_rate)))
			if (super_saturation)
				air.adjust_moles(/datum/gas/tritium, plasma_burn_rate)
			else
				air.adjust_moles(/datum/gas/carbon_dioxide, plasma_burn_rate * 0.75)

				air.adjust_moles(/datum/gas/water_vapor, plasma_burn_rate * 0.25)


			energy_released += FIRE_PLASMA_ENERGY_RELEASED * (plasma_burn_rate)

			cached_results["fire"] += (plasma_burn_rate) * (1 + oxygen_burn_rate)

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((temperature * old_heat_capacity + energy_released) / new_heat_capacity)

	//let the floor know a fire is happening
	if(istype(location))
		temperature = air.return_temperature()
		if(temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
			location.hotspot_expose(temperature, CELL_VOLUME)

	return cached_results["fire"] ? REACTING : NO_REACTION

//freon reaction (is not a fire yet)
/datum/gas_reaction/freonfire
	priority = -5
	name = "Freon combustion"
	id = "freonfire"

/datum/gas_reaction/freonfire/init_reqs()
	min_requirements = list(
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT,
		/datum/gas/freon = MINIMUM_MOLE_COUNT,
		"TEMP" = FREON_LOWER_TEMPERATURE,
		"MAX_TEMP" = FREON_MAXIMUM_BURN_TEMPERATURE
		)

/datum/gas_reaction/freonfire/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	if(!isturf(holder))
		return NO_REACTION
	var/turf/open/location = holder

	//Handle freon burning (only reaction now)
	var/freon_burn_rate = 0
	var/oxygen_burn_rate = 0
	//more freon released at lower temperatures
	var/temperature_scale = 1

	if(temperature < FREON_LOWER_TEMPERATURE) //stop the reaction when too cold
		temperature_scale = 0
	else
		temperature_scale = (FREON_MAXIMUM_BURN_TEMPERATURE - temperature) / (FREON_MAXIMUM_BURN_TEMPERATURE - FREON_LOWER_TEMPERATURE) //calculate the scale based on the temperature
	if(temperature_scale >= 0)
		oxygen_burn_rate = OXYGEN_BURN_RATE_BASE - temperature_scale
		if(air.get_moles(/datum/gas/oxygen) > air.get_moles(/datum/gas/freon) * FREON_OXYGEN_FULLBURN)
			freon_burn_rate = (air.get_moles(/datum/gas/freon) * temperature_scale)/FREON_BURN_RATE_DELTA
		else
			freon_burn_rate = (temperature_scale * (air.get_moles(/datum/gas/oxygen) / FREON_OXYGEN_FULLBURN)) / FREON_BURN_RATE_DELTA

		if(freon_burn_rate > MINIMUM_HEAT_CAPACITY)
			freon_burn_rate = min(freon_burn_rate,air.get_moles(/datum/gas/freon),air.get_moles(/datum/gas/oxygen) / oxygen_burn_rate) //Ensures matter is conserved properly
			air.set_moles(/datum/gas/freon,  QUANTIZE(air.get_moles(/datum/gas/freon) - freon_burn_rate))
			air.set_moles(/datum/gas/oxygen, QUANTIZE(air.get_moles(/datum/gas/oxygen) - (freon_burn_rate * oxygen_burn_rate)))
			air.adjust_moles(/datum/gas/carbon_dioxide, freon_burn_rate)

			if(temperature < 160 && temperature > 120 && prob(2))
				new /obj/item/stack/sheet/hot_ice(location)

			energy_released += FIRE_FREON_ENERGY_RELEASED * (freon_burn_rate)

	if(energy_released < 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((temperature * old_heat_capacity + energy_released) / new_heat_capacity)

/datum/gas_reaction/h2fire
	priority = -3 //fire should ALWAYS be last, but tritium fires happen before plasma fires
	name = "Hydrogen Combustion"
	id = "h2fire"

/datum/gas_reaction/h2fire/init_reqs()
	min_requirements = list(
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST,
		/datum/gas/hydrogen = MINIMUM_MOLE_COUNT,
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/h2fire/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	var/list/cached_results = air.reaction_results
	cached_results["fire"] = 0
	var/turf/open/location = isturf(holder) ? holder : null
	var/burned_fuel = 0
	if(air.get_moles(/datum/gas/oxygen) < air.get_moles(/datum/gas/hydrogen) || MINIMUM_H2_OXYBURN_ENERGY > air.thermal_energy())
		burned_fuel = air.get_moles(/datum/gas/oxygen)/HYDROGEN_BURN_OXY_FACTOR
		air.adjust_moles(/datum/gas/hydrogen, -burned_fuel)
	else
		burned_fuel = air.get_moles(/datum/gas/hydrogen)*HYDROGEN_BURN_H2_FACTOR
		air.adjust_moles(/datum/gas/hydrogen, -air.get_moles(/datum/gas/hydrogen) / HYDROGEN_BURN_H2_FACTOR)
		air.adjust_moles(/datum/gas/oxygen, -air.get_moles(/datum/gas/hydrogen))

	if(burned_fuel)
		energy_released += (FIRE_HYDROGEN_ENERGY_RELEASED * burned_fuel)

		air.adjust_moles(/datum/gas/water_vapor, burned_fuel / HYDROGEN_BURN_OXY_FACTOR)

		cached_results["fire"] += burned_fuel

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((temperature*old_heat_capacity + energy_released) / new_heat_capacity)

	//let the floor know a fire is happening
	if(istype(location))
		temperature = air.return_temperature()
		if(temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
			location.hotspot_expose(temperature, CELL_VOLUME)

	return cached_results["fire"] ? REACTING : NO_REACTION

/datum/gas_reaction/nitrousformation //formationn of n2o, esothermic, requires bz as catalyst
	priority = 3
	name = "Nitrous Oxide formation"
	id = "nitrousformation"

/datum/gas_reaction/nitrousformation/init_reqs()
	min_requirements = list(
		/datum/gas/oxygen = 10,
		/datum/gas/nitrogen = 20,
		/datum/gas/bz = 5,
		"TEMP" = 200,
		"MAX_TEMP" = 250
	)

/datum/gas_reaction/nitrousformation/react(datum/gas_mixture/air)
	var/temperature = air.return_temperature()
	var/old_heat_capacity = air.heat_capacity()
	var/heat_efficency = min(air.get_moles(/datum/gas/oxygen), air.get_moles(/datum/gas/nitrogen))
	var/energy_used = heat_efficency * NITROUS_FORMATION_ENERGY
	if ((air.get_moles(/datum/gas/oxygen) - heat_efficency < 0 ) || (air.get_moles(/datum/gas/nitrogen) - heat_efficency * 2 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/oxygen, -heat_efficency)
	air.adjust_moles(/datum/gas/nitrogen, -heat_efficency * 2)
	air.adjust_moles(/datum/gas/nitrous_oxide, heat_efficency)

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature * old_heat_capacity + energy_used) / new_heat_capacity),TCMB)) //the air heats up when reacting
		return REACTING

/datum/gas_reaction/nitryl_decomposition //The decomposition of nitryl. Exothermic. Requires oxygen as catalyst.
	priority = 21
	name = "Nitryl Decomposition"
	id = "nitryl_decomp"

/datum/gas_reaction/nitryl_decomposition/init_reqs()
	min_requirements = list(
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT,
		/datum/gas/nitryl = MINIMUM_MOLE_COUNT,
		"MAX_TEMP" = 600
	)

/datum/gas_reaction/nitryl_decomposition/react(datum/gas_mixture/air)
	var/temperature = air.return_temperature()
	var/old_heat_capacity = air.heat_capacity()
	var/heat_efficency = min(temperature / (FIRE_MINIMUM_TEMPERATURE_TO_EXIST * 8), air.get_moles(/datum/gas/nitryl))
	var/energy_produced = heat_efficency * NITRYL_DECOMPOSITION_ENERGY
	if ((air.get_moles(/datum/gas/nitryl) - heat_efficency < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/nitryl, -heat_efficency)
	air.adjust_moles(/datum/gas/oxygen, heat_efficency)
	air.adjust_moles(/datum/gas/nitrogen, heat_efficency)

	if(energy_produced> 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature * old_heat_capacity + energy_produced) / new_heat_capacity), TCMB)) //the air heats up when reacting
		return REACTING

/datum/gas_reaction/nitrylformation //The formation of nitryl. Endothermic. Requires bz.
	priority = 3
	name = "Nitryl formation"
	id = "nitrylformation"

/datum/gas_reaction/nitrylformation/init_reqs()
	min_requirements = list(
		/datum/gas/oxygen = 10,
		/datum/gas/nitrogen = 10,
		/datum/gas/bz = 5,
		"TEMP" = 1500,
		"MAX_TEMP" = 10000
	)

/datum/gas_reaction/nitrylformation/react(datum/gas_mixture/air)
	var/temperature = air.return_temperature()

	var/old_heat_capacity = air.heat_capacity()
	var/heat_efficency = min(temperature/(FIRE_MINIMUM_TEMPERATURE_TO_EXIST * 8),air.get_moles(/datum/gas/oxygen),air.get_moles(/datum/gas/nitrogen))
	var/energy_used = heat_efficency * NITRYL_FORMATION_ENERGY
	if ((air.get_moles(/datum/gas/oxygen) - heat_efficency < 0 ) || (air.get_moles(/datum/gas/nitrogen) - heat_efficency < 0) || (air.get_moles(/datum/gas/bz) - heat_efficency * 0.05 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/oxygen, -heat_efficency)
	air.adjust_moles(/datum/gas/nitrogen, -heat_efficency)
	air.adjust_moles(/datum/gas/bz, -heat_efficency * 0.05) //bz gets consumed to balance the nitryl production and not make it too common and/or easy
	air.adjust_moles(/datum/gas/nitryl, heat_efficency)

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature * old_heat_capacity - energy_used) / new_heat_capacity),TCMB))
		return REACTING

/datum/gas_reaction/bzformation //Formation of BZ by combining plasma and tritium at low pressures. Exothermic.
	priority = 4
	name = "BZ Gas formation"
	id = "bzformation"

/datum/gas_reaction/bzformation/init_reqs()
	min_requirements = list(
		/datum/gas/nitrous_oxide = 10,
		/datum/gas/plasma = 10
	)


/datum/gas_reaction/bzformation/react(datum/gas_mixture/air)
	var/temperature = air.return_temperature()
	var/pressure = air.return_pressure()
	var/old_heat_capacity = air.heat_capacity()
	var/reaction_efficency = min(1 / ((pressure / (0.1 * ONE_ATMOSPHERE)) * (max(air.get_moles(/datum/gas/plasma)/air.get_moles(/datum/gas/nitrous_oxide),1))),air.get_moles(/datum/gas/nitrous_oxide),air.get_moles(/datum/gas/plasma) * 0.5)
	var/energy_released = 2 * reaction_efficency * FIRE_CARBON_ENERGY_RELEASED
	if ((air.get_moles(/datum/gas/nitrous_oxide) - reaction_efficency < 0 )|| (air.get_moles(/datum/gas/plasma) - (2*reaction_efficency) < 0) || energy_released <= 0) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/bz, reaction_efficency * 2.5)
	if(reaction_efficency == air.get_moles(/datum/gas/nitrous_oxide))
		air.adjust_moles(/datum/gas/bz, -min(pressure,0.5))
		air.adjust_moles(/datum/gas/oxygen, min(pressure,0.5))
	air.adjust_moles(/datum/gas/nitrous_oxide, -reaction_efficency)
	air.adjust_moles(/datum/gas/plasma, -2 * reaction_efficency)

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature * old_heat_capacity + energy_released) / new_heat_capacity),TCMB))
		return REACTING

/datum/gas_reaction/freonformation
	priority = 5
	name = "Freon formation"
	id = "freonformation"

/datum/gas_reaction/freonformation/init_reqs() //minimum requirements for freon formation
	min_requirements = list(
		/datum/gas/plasma = 40,
		/datum/gas/carbon_dioxide = 20,
		/datum/gas/bz = 20,
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST + 100
		)

/datum/gas_reaction/freonformation/react(datum/gas_mixture/air)
	var/temperature = air.return_temperature()
	var/old_heat_capacity = air.heat_capacity()
	var/heat_efficency = min(temperature/(FIRE_MINIMUM_TEMPERATURE_TO_EXIST * 10), air.get_moles(/datum/gas/plasma), air.get_moles(/datum/gas/carbon_dioxide), air.get_moles(/datum/gas/bz))
	var/energy_used = heat_efficency * 100
	if ((air.get_moles(/datum/gas/plasma) - heat_efficency * 1.5 < 0) || (air.get_moles(/datum/gas/carbon_dioxide) - heat_efficency * 0.75 < 0) || (air.get_moles(/datum/gas/bz) - heat_efficency * 0.25 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/plasma, -heat_efficency * 1.5)
	air.adjust_moles(/datum/gas/carbon_dioxide, -heat_efficency * 0.75)
	air.adjust_moles(/datum/gas/bz, -heat_efficency * 0.25)
	air.adjust_moles(/datum/gas/freon, heat_efficency * 2.5)

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature*old_heat_capacity - energy_used)/new_heat_capacity),TCMB))
		return REACTING

/datum/gas_reaction/stimformation //Stimulum formation follows a strange pattern of how effective it will be at a given temperature, having some multiple peaks and some large dropoffs. Exo and endo thermic.
	priority = 6
	name = "Stimulum formation"
	id = "stimformation"

/datum/gas_reaction/stimformation/init_reqs()
	min_requirements = list(
		/datum/gas/tritium = 30,
		/datum/gas/bz = 20,
		/datum/gas/nitryl = 30,
		"TEMP" = 1500)

/datum/gas_reaction/stimformation/react(datum/gas_mixture/air)
	var/old_heat_capacity = air.heat_capacity()
	var/heat_scale = min(air.return_temperature()/STIMULUM_HEAT_SCALE,air.get_moles(/datum/gas/plasma),air.get_moles(/datum/gas/nitryl))
	var/stim_energy_change = heat_scale + STIMULUM_FIRST_RISE*(heat_scale**2) - STIMULUM_FIRST_DROP*(heat_scale**3) + STIMULUM_SECOND_RISE*(heat_scale**4) - STIMULUM_ABSOLUTE_DROP*(heat_scale**5)

	if ((air.get_moles(/datum/gas/plasma) - heat_scale < 0) || (air.get_moles(/datum/gas/nitryl) - heat_scale < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/stimulum, heat_scale * 0.75)
	air.adjust_moles(/datum/gas/tritium, -heat_scale)
	air.adjust_moles(/datum/gas/nitryl, -heat_scale)
	if(stim_energy_change)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((air.return_temperature() * old_heat_capacity + stim_energy_change) / new_heat_capacity),TCMB))
		return REACTING

/datum/gas_reaction/nobliumformation //Hyper-Noblium formation is extrememly endothermic, but requires high temperatures to start. Due to its high mass, hyper-nobelium uses large amounts of nitrogen and tritium. BZ can be used as a catalyst to make it less endothermic.
	priority = 7
	name = "Hyper-Noblium condensation"
	id = "nobformation"

/datum/gas_reaction/nobliumformation/init_reqs()
	min_requirements = list(
		/datum/gas/nitrogen = 10,
		/datum/gas/tritium = 5,
		"TEMP" = TCMB,
		"MAX_TEMP" = 15
		)

/datum/gas_reaction/nobliumformation/react(datum/gas_mixture/air)
	var/old_heat_capacity = air.heat_capacity()
	var/nob_formed = min((air.get_moles(/datum/gas/nitrogen) + air.get_moles(/datum/gas/tritium)) * 0.01,air.get_moles(/datum/gas/tritium) * 0.1,air.get_moles(/datum/gas/nitrogen) * 0.2)
	var/energy_produced = nob_formed * (NOBLIUM_FORMATION_ENERGY / (max(air.get_moles(/datum/gas/bz),1)))
	if ((air.get_moles(/datum/gas/tritium) - 5 * nob_formed < 0) || (air.get_moles(/datum/gas/nitrogen) - 10 * nob_formed < 0))
		return NO_REACTION
	air.adjust_moles(/datum/gas/tritium, -nob_formed * 5)
	air.adjust_moles(/datum/gas/nitrogen, -nob_formed * 10)
	air.adjust_moles(/datum/gas/hypernoblium, nob_formed)
	if (nob_formed)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((air.return_temperature() * old_heat_capacity + energy_produced) / new_heat_capacity),TCMB))


/datum/gas_reaction/miaster	//dry heat sterilization: clears out pathogens in the air
	priority = -10 //after all the heating from fires etc. is done
	name = "Dry Heat Sterilization"
	id = "sterilization"

/datum/gas_reaction/miaster/init_reqs()
	min_requirements = list(
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST+70,
		/datum/gas/miasma = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/miaster/react(datum/gas_mixture/air, datum/holder)
	// As the name says it, it needs to be dry
	if(air.get_moles(/datum/gas/water_vapor)/air.total_moles() > 0.1) // Yogs --Fixes runtime in Sterilization
		return

	//Replace miasma with oxygen
	var/cleaned_air = min(air.get_moles(/datum/gas/miasma), 20 + (air.return_temperature() - FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 70) / 20)
	air.adjust_moles(/datum/gas/miasma, -cleaned_air)
	air.adjust_moles(/datum/gas/oxygen, cleaned_air)

	//Possibly burning a bit of organic matter through maillard reaction, so a *tiny* bit more heat would be understandable
	air.set_temperature(air.return_temperature() + cleaned_air * 0.002)

/datum/gas_reaction/halon_formation
	priority = 12
	name = "Halon formation"
	id = "halon_formation"

/datum/gas_reaction/halon_formation/init_reqs()
	min_requirements = list(
		/datum/gas/bz = MINIMUM_MOLE_COUNT,
		/datum/gas/tritium = MINIMUM_MOLE_COUNT,
		"TEMP" = 30,
		"MAX_TEMP" = 55
	)

/datum/gas_reaction/halon_formation/react(datum/gas_mixture/air, datum/holder)
	var/temperature = air.return_temperature()
	var/old_heat_capacity = air.heat_capacity()
	var/heat_efficency = min(temperature * 0.01, air.get_moles(/datum/gas/tritium), air.get_moles(/datum/gas/bz))
	var/energy_used = heat_efficency * 300
	if ((air.get_moles(/datum/gas/tritium) - heat_efficency * 4 < 0 ) || (air.get_moles(/datum/gas/bz) - heat_efficency * 0.25 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/tritium, -heat_efficency * 4)
	air.adjust_moles(/datum/gas/bz, -heat_efficency * 0.25)
	air.adjust_moles(/datum/gas/halon, heat_efficency * 4.25)

	if(energy_used)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature * old_heat_capacity + energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/healium_formation
	priority = 9
	name = "Healium formation"
	id = "healium_formation"

/datum/gas_reaction/healium_formation/init_reqs()
	min_requirements = list(
		/datum/gas/bz = MINIMUM_MOLE_COUNT,
		/datum/gas/freon = MINIMUM_MOLE_COUNT,
		"TEMP" = 25,
		"MAX_TEMP" = 300
	)

/datum/gas_reaction/healium_formation/react(datum/gas_mixture/air, datum/holder)
	var/temperature = air.return_temperature()
	var/old_heat_capacity = air.heat_capacity()
	var/heat_efficency = min(temperature * 0.3, air.get_moles(/datum/gas/freon), air.get_moles(/datum/gas/bz))
	var/energy_used = heat_efficency * 9000
	if ((air.get_moles(/datum/gas/freon) - heat_efficency * 2.75 < 0 ) || (air.get_moles(/datum/gas/bz) - heat_efficency * 0.25 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/freon, -heat_efficency * 2.75)
	air.adjust_moles(/datum/gas/bz, -heat_efficency * 0.25)
	air.adjust_moles(/datum/gas/healium, heat_efficency * 3)

	if(energy_used)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature * old_heat_capacity + energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/proto_nitrate_formation
	priority = 10
	name = "Proto Nitrate formation"
	id = "proto_nitrate_formation"

/datum/gas_reaction/proto_nitrate_formation/init_reqs()
	min_requirements = list(
		/datum/gas/pluoxium = MINIMUM_MOLE_COUNT,
		/datum/gas/hydrogen = MINIMUM_MOLE_COUNT,
		"TEMP" = 5000,
		"MAX_TEMP" = 10000
	)

/datum/gas_reaction/proto_nitrate_formation/react(datum/gas_mixture/air, datum/holder)
	var/temperature = air.return_temperature()
	var/old_heat_capacity = air.heat_capacity()
	var/heat_efficency = min(temperature * 0.005, air.get_moles(/datum/gas/pluoxium), air.get_moles(/datum/gas/hydrogen))
	var/energy_used = heat_efficency * 650
	if ((air.get_moles(/datum/gas/pluoxium) - heat_efficency * 0.2 < 0 ) || (air.get_moles(/datum/gas/hydrogen) - heat_efficency * 2 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/hydrogen, -heat_efficency * 2)
	air.adjust_moles(/datum/gas/pluoxium, -heat_efficency * 0.2)
	air.adjust_moles(/datum/gas/proto_nitrate, heat_efficency * 2.2)

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature * old_heat_capacity + energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/zauker_formation
	priority = 11
	name = "Zauker formation"
	id = "zauker_formation"

/datum/gas_reaction/zauker_formation/init_reqs()
	min_requirements = list(
		/datum/gas/hypernoblium = MINIMUM_MOLE_COUNT,
		/datum/gas/stimulum = MINIMUM_MOLE_COUNT,
		"TEMP" = 50000,
		"MAX_TEMP" = 75000
	)

/datum/gas_reaction/zauker_formation/react(datum/gas_mixture/air, datum/holder)
	var/temperature = air.return_temperature()
	var/old_heat_capacity = air.heat_capacity()
	var/heat_efficency = min(temperature * 0.000005, air.get_moles(/datum/gas/hypernoblium), air.get_moles(/datum/gas/stimulum))
	var/energy_used = heat_efficency * 5000
	if ((air.get_moles(/datum/gas/hypernoblium) - heat_efficency * 0.01 < 0 ) || (air.get_moles(/datum/gas/stimulum) - heat_efficency * 0.5 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/hypernoblium, -(heat_efficency * 0.01))
	air.adjust_moles(/datum/gas/stimulum, -(heat_efficency * 0.5))
	air.adjust_moles(/datum/gas/zauker, heat_efficency * 0.5)

	if(energy_used)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature * old_heat_capacity - energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/halon_o2removal
	priority = -1
	name = "Halon o2 removal"
	id = "halon_o2removal"

/datum/gas_reaction/halon_o2removal/init_reqs()
	min_requirements = list(
		/datum/gas/halon = MINIMUM_MOLE_COUNT,
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT,
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST
	)

/datum/gas_reaction/halon_o2removal/react(datum/gas_mixture/air, datum/holder)
	var/temperature = air.return_temperature()
	var/old_heat_capacity = air.heat_capacity()
	var/heat_efficency = min(temperature / ( FIRE_MINIMUM_TEMPERATURE_TO_EXIST * 10), air.get_moles(/datum/gas/halon), air.get_moles(/datum/gas/oxygen))
	var/energy_used = heat_efficency * 2500
	if ((air.get_moles(/datum/gas/halon) - heat_efficency < 0 ) || (air.get_moles(/datum/gas/oxygen) - heat_efficency * 20 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/halon, -heat_efficency)
	air.adjust_moles(/datum/gas/oxygen, -heat_efficency * 20)
	air.adjust_moles(/datum/gas/carbon_dioxide, heat_efficency * 5)

	if(energy_used)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature * old_heat_capacity - energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/zauker_decomp
	priority = 8
	name = "Zauker decomposition"
	id = "zauker_decomp"

/datum/gas_reaction/zauker_decomp/init_reqs()
	min_requirements = list(
		/datum/gas/nitrogen = MINIMUM_MOLE_COUNT,
		/datum/gas/zauker = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/zauker_decomp/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	var/burned_fuel = 0
	burned_fuel = min(20, air.get_moles(/datum/gas/nitrogen), air.get_moles(/datum/gas/zauker))
	if(air.get_moles(/datum/gas/zauker) - burned_fuel < 0)
		return NO_REACTION
	air.adjust_moles(/datum/gas/zauker, -burned_fuel)

	if(burned_fuel)
		energy_released += (460 * burned_fuel)

		air.adjust_moles(/datum/gas/oxygen, burned_fuel * 0.3)
		air.adjust_moles(/datum/gas/nitrogen, burned_fuel * 0.7)

		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max((temperature * old_heat_capacity + energy_released) / new_heat_capacity, TCMB))
		return REACTING
	return NO_REACTION

/datum/gas_reaction/proto_nitrate_bz_response
	priority = 13
	name = "Proto Nitrate bz response"
	id = "proto_nitrate_bz_response"

/datum/gas_reaction/proto_nitrate_bz_response/init_reqs()
	min_requirements = list(
		/datum/gas/proto_nitrate = MINIMUM_MOLE_COUNT,
		/datum/gas/bz = MINIMUM_MOLE_COUNT,
		"TEMP" = 260,
		"MAX_TEMP" = 280
	)

/datum/gas_reaction/proto_nitrate_bz_response/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	var/turf/open/location
	if(istype(holder,/datum/pipeline)) //Find the tile the reaction is occuring on, or a random part of the network if it's a pipenet.
		var/datum/pipeline/pipenet = holder
		location = get_turf(pick(pipenet.members))
	else
		location = get_turf(holder)
	var consumed_amount = min(5, air.get_moles(/datum/gas/bz), air.get_moles(/datum/gas/proto_nitrate))
	if(air.get_moles(/datum/gas/bz) - consumed_amount < 0)
		return NO_REACTION
	if(air.get_moles(/datum/gas/bz) < 30)
		radiation_pulse(location, consumed_amount * 20, 2.5, TRUE, FALSE)
		air.adjust_moles(/datum/gas/bz, -consumed_amount)
	else
		for(var/mob/living/carbon/L in location)
			L.hallucination += air.get_moles(/datum/gas/bz) * 0.7
	energy_released += 100
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max((temperature * old_heat_capacity + energy_released) / new_heat_capacity, TCMB))
	return REACTING

/datum/gas_reaction/proto_nitrate_tritium_response
	priority = 16
	name = "Proto Nitrate tritium response"
	id = "proto_nitrate_tritium_response"

/datum/gas_reaction/proto_nitrate_tritium_response/init_reqs()
	min_requirements = list(
		/datum/gas/proto_nitrate = MINIMUM_MOLE_COUNT,
		/datum/gas/tritium = MINIMUM_MOLE_COUNT,
		"TEMP" = 150,
		"MAX_TEMP" = 340
	)

/datum/gas_reaction/proto_nitrate_tritium_response/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	var/turf/open/location = isturf(holder) ? holder : null
	if(location == null)
		return NO_REACTION
	var produced_amount = min(5, air.get_moles(/datum/gas/tritium), air.get_moles(/datum/gas/proto_nitrate))
	if(air.get_moles(/datum/gas/tritium) - produced_amount < 0 || air.get_moles(/datum/gas/proto_nitrate) - produced_amount * 0.01 < 0)
		return NO_REACTION
	location.rad_act(produced_amount * 2.4)
	air.adjust_moles(/datum/gas/tritium, -produced_amount)
	air.adjust_moles(/datum/gas/hydrogen, produced_amount)
	air.adjust_moles(/datum/gas/proto_nitrate, -produced_amount * 0.01)
	energy_released += 50
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max((temperature * old_heat_capacity + energy_released) / new_heat_capacity, TCMB))
	return REACTING

/datum/gas_reaction/proto_nitrate_hydrogen_response
	priority = 17
	name = "Proto Nitrate hydrogen response"
	id = "proto_nitrate_hydrogen_response"

/datum/gas_reaction/proto_nitrate_hydrogen_response/init_reqs()
	min_requirements = list(
		/datum/gas/proto_nitrate = MINIMUM_MOLE_COUNT,
		/datum/gas/hydrogen = 150,
	)

/datum/gas_reaction/proto_nitrate_hydrogen_response/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	var produced_amount = min(5, air.get_moles(/datum/gas/hydrogen), air.get_moles(/datum/gas/proto_nitrate))
	if(air.get_moles(/datum/gas/hydrogen) - produced_amount < 0)
		return NO_REACTION
	air.adjust_moles(/datum/gas/hydrogen, -produced_amount)
	air.adjust_moles(/datum/gas/proto_nitrate, produced_amount * 0.5)
	energy_released = produced_amount * 2500
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max((temperature * old_heat_capacity - energy_released) / new_heat_capacity, TCMB))
	return REACTING

/datum/gas_reaction/pluox_formation
	priority = 2
	name = "Pluoxium formation"
	id = "pluox_formation"

/datum/gas_reaction/pluox_formation/init_reqs()
	min_requirements = list(
		/datum/gas/carbon_dioxide = MINIMUM_MOLE_COUNT,
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT,
		/datum/gas/tritium = MINIMUM_MOLE_COUNT,
		"TEMP" = 50,
		"MAX_TEMP" = T0C
	)

/datum/gas_reaction/pluox_formation/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	var produced_amount = min(5, air.get_moles(/datum/gas/carbon_dioxide), air.get_moles(/datum/gas/oxygen))
	if(air.get_moles(/datum/gas/carbon_dioxide) - produced_amount < 0 || air.get_moles(/datum/gas/oxygen) - produced_amount * 0.5 < 0 || air.get_moles(/datum/gas/tritium) - produced_amount * 0.01 < 0)
		return NO_REACTION
	air.adjust_moles(/datum/gas/carbon_dioxide, -produced_amount)
	air.adjust_moles(/datum/gas/oxygen, -produced_amount * 0.5)
	air.adjust_moles(/datum/gas/tritium, -produced_amount * 0.01)
	air.adjust_moles(/datum/gas/pluoxium, produced_amount)
	air.adjust_moles(/datum/gas/hydrogen, produced_amount * 0.01)
	energy_released += produced_amount * 250
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max((temperature * old_heat_capacity + energy_released) / new_heat_capacity, TCMB))
	return REACTING
