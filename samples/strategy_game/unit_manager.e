note
	description: "This class manages all units in game."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNIT_MANAGER

inherit
	ENVIRONMENT

create
	default_create

feature -- Access
	add_unit (unit: UNIT) is
			-- Let unit manager know about new unit
		do
			units.extend (unit)
		end

	all_units: LINEAR [UNIT] is
			-- Returns all units in `LINEAR', which allows only reading
		do
			Result := units
		end


	select_units (x, y: INTEGER_INTERVAL): LINEAR [UNIT] is
			-- Select units in given rectangle,
			-- return list containing all of them
		local
			list: LINKED_LIST [UNIT]
		do
			create list.make
			from
				units.start
			until
				units.after
			loop
				if (x.has (units.item.position.x) and y.has (units.item.position.y)) then
--					io.put_string ("unit=" + units.item.out)
--					io.put_string (", pos=" + units.item.position.out)
--					io.put_new_line
					list.extend (units.item)
				end
				if ((x.has (units.item.position.x) and y.has (units.item.position.y)) xor units.item.is_selected) then
					units.item.change_selected_state
				end
				units.forth
					-- Iterate over all units
			end
			Result := list
		end

	available_actions (list: LINEAR [UNIT]): LINEAR [STRING] is
			-- Returns actions which can be completed for given list of units
		local
			set: BINARY_SEARCH_TREE_SET [STRING]
			actions_list: LIST [ACTION [TUPLE]]
		do
			create set.make
			from
				list.start
			until
				list.after
			loop
				actions_list := list.item.actions
				from
					actions_list.start
				until
					actions_list.after
				loop
					set.extend (actions_list.item.out)
					actions_list.forth
				end
				list.forth
			end
			Result := set
		end

feature -- Initialization
	default_create is
			-- and execute list of actions
		do
			units := create {LINKED_LIST [UNIT]}.make
		end

feature -- Operations
	sample_units_script is
			-- Creation of several units as an example of manager's job
		local
			hall: HALL
			barrack: BARRACK
			mine: MINE
			storehouse: STOREHOUSE
			buildings: LIST [BUILDING]

			workers: ARRAY [WORKER]
			worker: WORKER
			soldiers: ARRAY [SOLDIER]
			soldier: SOLDIER
			powerful_hero: HERO
			doctor: DOCTOR
			resources: LINKED_LIST [RESOURCE]

			i: INTEGER

			list: LIST [ACTION [TUPLE]]
		do
			x_coordinate := 1
            create hall.make(map_manager.position (0, 0), "Red")
            process_unit (hall)

			hall.train_hero
            powerful_hero ?= hall.last_trained_being
			process_unit (powerful_hero)


			hall.train_doctor
            doctor ?= hall.last_trained_being
			process_unit (doctor)

            create workers.make (1, 3)
            from
                i := 1
            until
                i = workers.count + 1
            loop
            	hall.train_worker
            	worker ?= hall.last_trained_being
                workers.put (worker, i)
                process_unit (worker)
                i := i + 1
            end

			buildings := create {LINKED_LIST [BUILDING]}.make
			workers.item (1).build_barrack (map_manager.position (0, 1))
			barrack ?= workers.item (1).last_building
			buildings.extend (workers.item (1).last_building)
            process_unit (workers.item (1).last_building)

            create soldiers.make (1, 5)
            from
                i := 1
            until
                i = soldiers.count + 1
            loop
            	barrack.train_soldier
            	soldier := barrack.last_trained_soldier
                soldiers.put (soldier, i)
                list := soldier.actions
                process_unit (soldier)
                i := i + 1
            end

			workers.item (2).build_mine (map_manager.position (0, 2))
			mine ?= workers.item (2).last_building
			buildings.extend (workers.item (2).last_building)
            process_unit (workers.item (2).last_building)

			workers.item (3).build_sawmill (map_manager.position (0, 3))
			buildings.extend (workers.item (3).last_building)
            process_unit (workers.item (3).last_building)

           	workers.item (2).build_storehouse (map_manager.position (0, 4))
			storehouse ?= workers.item (2).last_building
			buildings.extend (workers.item (2).last_building)
            process_unit (workers.item (2).last_building)

			create resources.make
            from
                i := 1
            until
                i = workers.count + 1
            loop
            	workers.item (i).collect_gold (mine)
                resources.extend (workers.item (i).resource_in_knapsack)
                i := i + 1
            end

            from
            	i := 1
            until
            	i = workers.count + 1
            loop
            	workers.item (i).move (map_manager.position (i + 1, 0))
            	i := i + 1
            end

            powerful_hero.attack (workers.item (1))

            doctor.heal (powerful_hero)
		ensure
			units_created: units.count > 0
		end

feature {NONE} -- Implementation

	x_coordinate: INTEGER
			-- Current coordinate for unit in the row

	process_unit (unit: UNIT) is
			-- Adds `unit' in `units' list and moves it to the next position in the row.
			-- Example of moving units
		local
			being: BEING
				-- if `unit' is `BEING' then it can be moved
		do
			add_unit (unit)
			being ?= unit
			if (being /= Void) then
				being.move (map_manager.position (x_coordinate, 0))
				x_coordinate := x_coordinate + 1
			end
		end

	units: LIST [UNIT]
			-- All units in game are stored in this list

invariant
	units /= Void
end
