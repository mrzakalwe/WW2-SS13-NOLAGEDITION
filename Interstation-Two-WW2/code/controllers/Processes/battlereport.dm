
var/datum/controller/process/battlereport/battlereport

/datum/controller/process/battlereport
	var/nextreport = -1

/datum/controller/process/battlereport/setup()
	name = "Battle Report"
	schedule_interval = 6000 // every 10 minutes
	battlereport = src

/datum/controller/process/battlereport/statProcess()
	..()
	if (nextreport == -1)
		nextreport = world.timeofday + 6000
	stat(null, "Next battle report: ~[round((nextreport - world.timeofday)/600)] minutes")

/datum/controller/process/battlereport/doWork()
	show_global_battle_report(null)
	nextreport = world.timeofday + 6000
	// SCHECK // disabled because I think it breaks the process