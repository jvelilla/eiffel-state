note
	description: "Hero is more powerful in a battle."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HERO

inherit
	ARMY_BEING

create
	make

feature -- Access
	type: STRING is "Hero"

	creation_time: DOUBLE is 10.0
			-- Hero training time

	maximum_movement_speed: DOUBLE is 1.5

	maximum_accuracy: DOUBLE is 0.8

end
