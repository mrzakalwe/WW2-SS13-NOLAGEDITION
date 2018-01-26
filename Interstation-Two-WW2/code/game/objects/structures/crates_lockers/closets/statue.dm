/obj/structure/closet/statue
	name = "statue"
	desc = "An incredibly lifelike marble carving"
	icon = 'icons/obj/statue.dmi'
	icon_state = "human_male"
	density = TRUE
	anchored = TRUE
	health = FALSE //destroying the statue kills the mob within
	var/intialTox = FALSE 	//these are here to keep the mob from taking damage from things that logically wouldn't affect a rock
	var/intialFire = FALSE	//it's a little sloppy I know but it was this or the GODMODE flag. Lesser of two evils.
	var/intialBrute = FALSE
	var/intialOxy = FALSE
	var/timer = 240 //eventually the person will be freed

/obj/structure/closet/statue/New(loc, var/mob/living/L)
	if(L && (ishuman(L) || iscorgi(L)))
		if(L.buckled)
			L.buckled = FALSE
			L.anchored = FALSE
		if(L.client)
			L.client.perspective = EYE_PERSPECTIVE
			L.client.eye = src
		L.loc = src
		L.sdisabilities |= MUTE
		health = L.health + 100 //stoning damaged mobs will result in easier to shatter statues
		intialTox = L.getToxLoss()
		intialFire = L.getFireLoss()
		intialBrute = L.getBruteLoss()
		intialOxy = L.getOxyLoss()
		if(ishuman(L))
			name = "statue of [L.name]"
			if(L.gender == "female")
				icon_state = "human_female"
		else if(iscorgi(L))
			name = "statue of a corgi"
			icon_state = "corgi"
			desc = "If it takes forever, I will wait for you..."

	if(health == FALSE) //meaning if the statue didn't find a valid target
		qdel(src)
		return

	processing_objects.Add(src)
	..()

/obj/structure/closet/statue/process()
	timer--
	for(var/mob/living/M in src) //Go-go gadget stasis field
		M.setToxLoss(intialTox)
		M.adjustFireLoss(intialFire - M.getFireLoss())
		M.adjustBruteLoss(intialBrute - M.getBruteLoss())
		M.setOxyLoss(intialOxy)
	if (timer <= FALSE)
		dump_contents()
		processing_objects.Remove(src)
		qdel(src)

/obj/structure/closet/statue/dump_contents()

	for(var/obj/O in src)
		O.loc = loc

	for(var/mob/living/M in src)
		M.loc = loc
		M.sdisabilities &= ~MUTE
		M.take_overall_damage((M.health - health - 100),0) //any new damage the statue incurred is transfered to the mob
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/statue/open()
	return

/obj/structure/closet/statue/close()
	return

/obj/structure/closet/statue/toggle()
	return

/obj/structure/closet/statue/proc/check_health()
	if(health <= FALSE)
		for(var/mob/M in src)
			shatter(M)

/obj/structure/closet/statue/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	check_health()

	return

/obj/structure/closet/statue/attack_generic(var/mob/user, damage, attacktext, environment_smash)
	if(damage && environment_smash)
		for(var/mob/M in src)
			shatter(M)

/obj/structure/closet/statue/ex_act(severity)
	for(var/mob/M in src)
		M.ex_act(severity)
		health -= 60 / severity
		check_health()

/obj/structure/closet/statue/attackby(obj/item/I as obj, mob/user as mob)
	health -= I.force
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] strikes [src] with [I].</span>")
	check_health()

/obj/structure/closet/statue/MouseDrop_T()
	return

/obj/structure/closet/statue/relaymove()
	return

/obj/structure/closet/statue/attack_hand()
	return

/obj/structure/closet/statue/verb_toggleopen()
	return

/obj/structure/closet/statue/update_icon()
	return

/obj/structure/closet/statue/proc/shatter(mob/user as mob)
	if (user)
		user.dust()
	dump_contents()
	visible_message("<span class='warning'>[src] shatters!.</span>")
	qdel(src)