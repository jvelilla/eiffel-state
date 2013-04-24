note
	description: "Mines that produce gold."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MINE

inherit
	PRODUCTION
		redefine
			make
		end

create {WORKER}
	make

feature -- Initialization
	make (p: POSITION; team: STRING) is
			-- creates mine at `p' position
		do
			Precursor {PRODUCTION} (p, team)
			exhausted_state := Weak_depreciation
		end

feature -- Access
	type: STRING is "Mine"

	creation_time: DOUBLE is 20.0

	gold_mined: INTEGER
			-- Gold portions which were mined there

feature -- State dependent: Access
	collecting_time: DOUBLE is
			-- Time required for collecting one gold bar
		do
			Result := sd_collecting_time.item([], exhausted_state)
		end

feature -- Basic operations
	produce: GOLD is
			-- Produce bar of gold and store it into `last_gold'
		do
			gold_mined := gold_mined + 1
			sd_produce.call ([], exhausted_state)
			create Result
		end

feature {NONE} -- Implementation
	exhausted_state: STATE
	Weak_depreciation: STATE is once create Result.make ("Weak depreciation") end
	Medium_depreciation: STATE is once create Result.make ("Medium depreciation") end
	Heavy_depreciation: STATE is once create Result.make ("Heavy depreciation") end

	middle_depreciation_level: INTEGER is 1000
			-- After this level mining needs additional time

	heavy_depreciation_level: INTEGER is 3000
			-- After this level mining needs much more time

	is_medium_depreciation: BOOLEAN is
		do
			Result := gold_mined >= middle_depreciation_level
		end

	is_heavy_depreciation: BOOLEAN is
		do
			Result := gold_mined >= heavy_depreciation_level
		end

	sd_collecting_time: STATE_DEPENDENT_FUNCTION [TUPLE, DOUBLE] is
			-- State-dependent function for `collecting_time'
		once
			create Result.make(3)
			Result.add_result (Weak_depreciation, agent: BOOLEAN do Result := True end, 1.0)
			Result.add_result (Medium_depreciation, agent: BOOLEAN do Result := True end, 3.0)
			Result.add_result (Heavy_depreciation, agent: BOOLEAN do Result := True end, 15.0)
		end

	sd_produce: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- State-dependent procedure for `produce'
		once
			create Result.make(2)
			Result.add_behavior (Weak_depreciation, agent is_medium_depreciation, agent do end, Medium_depreciation)
			Result.add_behavior (Medium_depreciation, agent is_heavy_depreciation, agent do end, Heavy_depreciation)
		end
invariant
	exhausted_state /= Void
	gold_mined >= 0
	not type.is_empty
end
