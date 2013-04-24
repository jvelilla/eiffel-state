indexing
	description: "Automated objects."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUTOMATED

feature {NONE} -- Implementation
	state: STATE
			-- Current control state

--	call (sdp: STATE_DEPENDENT_PROCEDURE; args: TUPLE) is
--			-- Call `sdp' with `args' and update the state
--		do
--			sdp.call (args, state)
--			state := sdp.next_state
--		end

	otherwise: BOOLEAN is
			-- Always true
		do
			Result := True
		ensure
			Result = True
		end

	is_in (states: ARRAY [STATE]): BOOLEAN is
			-- Indicator predicate
		do
			Result := states.has (state)
		ensure
			Result = (states.has (state))
		end
end
