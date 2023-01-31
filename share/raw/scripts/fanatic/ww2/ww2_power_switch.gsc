#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;

#precache("xanim", "circuit_breaker_dial_standby");
#precache("xanim", "circuit_breaker_dial_turn_on");
#using_animtree("ww2_power_switch_anims");

#namespace ww2_power_switch;

function init()
{
	PowerSwitch = GetEnt("ww2_power_switch", "targetname");

	PowerSwitch HidePart("tag_green_on");
	PowerSwitch HidePart("tag_red_off");

	PowerSwitch UseAnimTree(#animtree);
	PowerSwitch AnimScripted("SwitchStandby", PowerSwitch.origin, PowerSwitch.angles, %circuit_breaker_dial_standby);

	thread power_switch();
	thread power_on_wait();
	thread red_light_flash();
}

function power_switch()
{
	PowerSwitchTrig = GetEnt("ww2_power_switch_trigger", "targetname");
	PowerSwitchTrig SetHintString("Hold ^3[{+activate}]^7 to turn on the Power");
	PowerSwitchTrig SetCursorHint("HINT_NOICON");

	PowerSwitchTrig waittill("trigger", player);
	PowerSwitchTrig Hide();

	level flag::set("power_on");
}

function power_on_wait()
{
	level flag::wait_till("power_on");

	PowerSwitch = GetEnt("ww2_power_switch", "targetname");

	PowerSwitch UseAnimTree(#animtree);
	PowerSwitch AnimScripted("SwitchOn", PowerSwitch.origin, PowerSwitch.angles, %circuit_breaker_dial_turn_on);

	PowerSwitch PlaySoundOnTag("ww2_power_switch_on", "tag_origin");
	PowerSwitch PlaySoundOnTag("ww2_power_on", "tag_origin");
	PowerSwitch PlaySoundOnTag("ww2_power_on_mus", "tag_origin");

	wait 0.30;

	PowerSwitch HidePart("tag_red_on");
	PowerSwitch ShowPart("tag_red_off");

	PowerSwitch ShowPart("tag_green_on");
	PowerSwitch HidePart("tag_green_off");

	PowerSwitch ShowPart("tag_power_on");
	PowerSwitch HidePart("tag_power_off");
}

function red_light_flash()
{
	PowerSwitch = GetEnt("ww2_power_switch", "targetname");

	level flag::wait_till("initial_blackscreen_passed");

	while(1)
	{
		PowerSwitch ShowPart("tag_power_off");
		PowerSwitch HidePart("tag_power_on");
		wait 0.30;
		PowerSwitch ShowPart("tag_power_on");
		PowerSwitch HidePart("tag_power_off");
		if(level flag::get("power_on")) {
			break;
		}
		else {
			wait 0.30;
		}
	}
}