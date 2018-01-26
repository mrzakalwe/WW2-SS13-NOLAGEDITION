/obj/item/weapon/paper/carbon
	name = "paper"
	icon_state = "paper_stack"
	item_state = "paper"
	var copied = FALSE
	var iscopy = FALSE

/obj/item/weapon/paper/carbon/update_icon()
	if(iscopy)
		if(info)
			icon_state = "cpaper_words"
			return
		icon_state = "cpaper"
	else if (copied)
		if(info)
			icon_state = "paper_words"
			return
		icon_state = "paper"
	else
		if(info)
			icon_state = "paper_stack_words"
			return
		icon_state = "paper_stack"



/obj/item/weapon/paper/carbon/verb/removecopy()
	set name = "Remove carbon-copy"
	set category = "Object"
	set src in usr

	if (copied == FALSE)
		var/obj/item/weapon/paper/carbon/c = src
		var/copycontents = rhtml_decode(c.info)
		var/obj/item/weapon/paper/carbon/copy = new /obj/item/weapon/paper/carbon (usr.loc)
		// <font>
		copycontents = replacetext(copycontents, "<font face=\"[c.deffont]\" color=", "<font face=\"[c.deffont]\" nocolor=")	//state of the art techniques in action
		copycontents = replacetext(copycontents, "<font face=\"[c.crayonfont]\" color=", "<font face=\"[c.crayonfont]\" nocolor=")	//This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.
		copy.info += copycontents
		copy.info += "</font>"
		copy.name = "Copy - " + c.name
		copy.fields = c.fields
		copy.updateinfolinks()
		usr << "<span class='notice'>You tear off the carbon-copy!</span>"
		c.copied = TRUE
		copy.iscopy = TRUE
		copy.update_icon()
		c.update_icon()
	else
		usr << "There are no more carbon copies attached to this paper!"