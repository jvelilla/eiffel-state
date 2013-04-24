note
	description: "Automated objects."
	author: "Author"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUTOMATED

feature {NONE} -- Implementation
	state: STATE
			-- Current control state

	is_in (states: ARRAY [STATE]): BOOLEAN 
			-- Indicator predicate
		do
			Result := states.has (state)
		ensure
			Result = (states.has (state))
		end
end
