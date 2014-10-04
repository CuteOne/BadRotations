Interrupts
The functionality that i would like to see in a interrupt module/handler is the following
Toggleable between modes
Manual Interrupts
Interrupt All
What to Interrupt According to filter
Whitelist, ie only interrupt this spells
Blacklist, ie interrupt all except this spells
Who to interupt according to filter/toogle
Current Target, UnitIDs(Focus, MouseOver, ToT etc)
With What
List of Spells that can be used to interrupt
Paladin(Rebuke, Fist of Justice, Blinding Light, Avengers Shield)
When to interrupt
Start or End
Normaly you will interrupt as quick as possible(channels for sure)
But sometimes we want to interrupt as lat as possible
React Time to make sure that we are hiding that we are botting
ie wait 0.x seconds before interrupting so we are acting human.
The functionality for the interrupt module could look something like this
Rotation checks if the user want us to interupt, it then calls a sub function that handles the class specific interrupt logic. The class specific funtion first checks what the config is and then do a call to a generic Interuppt handler that checks if there is someone casting something we should interrupt and returns a target if there is a valid one. The class specific then checks according to his config which spells to try to use

Rotation: 
Check if user wants us to Interrupt
If yes then call ClassInterrupt Function¨

ClassInterrupt function:
Read the Toggle values
Call InterruptHandler with config values

InterupptHandler:
Check who to interrupt(All, Target, etc)
For each applicable unit check if they cast spell according to filter(All, Whitelist, Blacklist) within the react time defined.
If true then return target

ClassInterrupt:
If return is a valid target then for each spell defined in the config check if it is possible to use spell to interrupt.

This design/functionality would be a very good interrupt function for the bot and cater for 90% of the need. Blacklist is perhaps good to have more then must have. If we are very ambitious we could even do a spell priority, ie what spell to itnerrupt instead of just stopping checking when we find a valid target(scenario if target cast a spell that are medium dangerous and our focus is casting a very dangerous spell we would want to interrupt the focus) IE the spell is used to select which target insead of target order.

Also it could be good to use events here to get a list of targets that are casting instead of looping through all units. So we could create an event handler that handles a list of units that are currently casting. For performance sake i mean.
