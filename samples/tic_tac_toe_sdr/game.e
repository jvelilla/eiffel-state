indexing
	description: "Tic-Tac-Toe games."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

inherit
	AUTOMATED

create
	make_first_cross,
	make_first_circle

feature {NONE} -- Initialization
	make_first_cross is
			-- Create a new game with first turn of crosses
		do
			create_empty_field
			build_sd_make_turn
			state := Cross_turn
		ensure
			field_empty: field.for_all (agent {FIELD_CELL}.is_empty)
		end

	make_first_circle is
			-- Create a new game with first turn of circles
		do
			create_empty_field
			build_sd_make_turn
			state := Circle_turn
		ensure
			field_empty: field.for_all (agent {FIELD_CELL}.is_empty)
		end

	create_empty_field is
			-- Create field with empty cells
		local
			i, j: INTEGER
		do
			create field.make (Dimension, Dimension)
			from
				i := 1
			until
				i > Dimension
			loop
				from
					j := 1
				until
					j > Dimension
				loop
					field.put (create {FIELD_CELL}, i, j)
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- Constants
	Dimension: INTEGER is 3
			-- Number of rows and columns on the field

feature -- Access
	item (i, j: INTEGER): FIELD_CELL  is
			-- Value of (`i', `j') cell
		require
			i_not_too_small: i >= 1
			i_not_too_large: i <= Dimension
			j_not_too_small: j >= 1
			j_not_too_large: j <= Dimension
		do
			Result := field.item (i, j)
		end

feature -- State-dependent: indicators
	is_over: BOOLEAN is
			-- Is game over?
		do
			Result := is_in (<<Cross_win, Circle_win, Draw>>)
		end

	cross_won: BOOLEAN is
			-- Did the crosses win?
		do
			Result := is_in (<<Cross_win>>)
		end

	circle_won: BOOLEAN is
			-- Did the crosses win?
		do
			Result := is_in (<<Circle_win>>)
		end

feature -- State dependent: basic operations
	make_turn (i, j: INTEGER) is
			-- Make turn, filling cell (`i', `j')
		require
			i_not_too_small: i >= 1
			i_not_too_large: i <= Dimension
			j_not_too_small: j >= 1
			j_not_too_large: j <= Dimension
		do
			sd_make_turn.call ([i, j], state)
			state := sd_make_turn.next_state
		end

feature {NONE} -- Predicates
	has_empty (i, j: INTEGER): BOOLEAN is
			-- Will there be any empty cells left after (`i', `j') is set?
		local
			k, l:INTEGER
		do
			from
				k := 1
			until
				k > Dimension or Result
			loop
				from
					l := 1
				until
					l > Dimension or Result
				loop
					Result := not (k = i and l = j) and item (k, l).is_empty
					l := l + 1
				end
				k := k + 1
			end
		end

	has_horizontal_cross (i, j: INTEGER): BOOLEAN is
			-- Will there be a winning combination for crosses on `i' horizontal with `j' set?
		local
			k: INTEGER
		do
			from
				Result := True
				k := 1
			until
				k > Dimension or not Result
			loop
				Result := (k /= j) implies item (i, k).is_cross
				k := k + 1
			end
		end

	has_horizontal_circle (i, j: INTEGER): BOOLEAN is
			-- Will there be a winning combination for circles on `i' horizontal with `j' set?
		local
			k: INTEGER
		do
			from
				Result := True
				k := 1
			until
				k > Dimension or not Result
			loop
				Result := (k /= j) implies item (i, k).is_circle
				k := k + 1
			end
		end

	has_vertical_cross (i, j: INTEGER): BOOLEAN is
			-- Will there be a winning combination for crosses on `j' vertical with `i' set?
		local
			k: INTEGER
		do
			from
				Result := True
				k := 1
			until
				k > Dimension or not Result
			loop
				Result := (k /= i) implies item (k, j).is_cross
				k := k + 1
			end
		end

	has_vertical_circle (i, j: INTEGER): BOOLEAN is
			-- Will there be a winning combination for circles on `j' vertical with `i' set?
		local
			k: INTEGER
		do
			from
				Result := True
				k := 1
			until
				k > Dimension or not Result
			loop
				Result := (k /= i) implies item (k, j).is_circle
				k := k + 1
			end
		end

	has_diagonal_cross (i, j: INTEGER): BOOLEAN is
			-- Will there be a winning combination for crosses on any diagonal with (`i', `j') set?
		local
			k: INTEGER
		do
			if i = j then
				from
					Result := True
					k := 1
				until
					k > Dimension or not Result
				loop
					Result := (k /= i) implies item (k, k).is_cross
					k := k + 1
				end
			end
			if not Result and i = Dimension + 1 - j then
				from
					Result := True
					k := 1
				until
					k > Dimension or not Result
				loop
					Result := (k /= i) implies item (k, Dimension + 1 - k).is_cross
					k := k + 1
				end
			end
		end

	has_diagonal_circle (i, j: INTEGER): BOOLEAN is
			-- Will there be a winning combination for circles on any diagonal with (`i', `j') set?
		local
			k: INTEGER
		do
			if i = j then
				from
					Result := True
					k := 1
				until
					k > Dimension or not Result
				loop
					Result := (k /= i) implies item (k, k).is_circle
					k := k + 1
				end
			end
			if not Result and i = Dimension + 1 - j then
				from
					Result := True
					k := 1
				until
					k > Dimension or not Result
				loop
					Result := (k /= i) implies item (k, Dimension + 1 - k).is_circle
					k := k + 1
				end
			end
		end

feature {NONE} -- Automaton
	Cross_turn: STATE is once create Result.make ("Cross turn") end
	Circle_turn: STATE is once create Result.make ("Circle turn") end
	Cross_win: STATE is once create Result.make ("Cross win") end
	Circle_win: STATE is once create Result.make ("Circle win") end
	Draw: STATE is once create Result.make ("Draw") end

	sd_make_turn: STATE_DEPENDENT_PROCEDURE [TUPLE[INTEGER, INTEGER]]
			-- State-dependent procedure for `make_turn'

	build_sd_make_turn is
			-- Build `sd_make_turn'
		do
			create sd_make_turn.make (6)
			sd_make_turn.add_behavior (Cross_turn,
				agent (i, j: INTEGER): BOOLEAN
					do
						Result := has_horizontal_cross (i, j) or has_vertical_cross (i, j) or has_diagonal_cross (i, j)
					end,
				agent (i, j: INTEGER)
					do
						item (i, j).put_cross
					end,
				Cross_win)
			sd_make_turn.add_behavior (Cross_turn,
				agent (i, j: INTEGER): BOOLEAN
					do
						Result := not has_empty (i, j)
					end,
				agent (i, j: INTEGER)
					do
						item (i, j).put_cross
					end,
				Draw)
			sd_make_turn.add_behavior (Cross_turn,
				agent otherwise,
				agent (i, j: INTEGER)
					do
						item (i, j).put_cross
					end,
				Circle_turn)
			sd_make_turn.add_behavior (Circle_turn,
				agent (i, j: INTEGER): BOOLEAN
					do
						Result := has_horizontal_circle (i, j) or has_vertical_circle (i, j) or has_diagonal_circle (i, j)
					end,
				agent (i, j: INTEGER)
					do
						item (i, j).put_circle
					end,
				Circle_win)
			sd_make_turn.add_behavior (Circle_turn,
				agent (i, j: INTEGER): BOOLEAN
					do
						Result := not has_empty (i, j)
					end,
				agent (i, j: INTEGER)
					do
						item (i, j).put_circle
					end,
				Draw)
			sd_make_turn.add_behavior (Circle_turn,
				agent otherwise,
				agent (i, j: INTEGER)
					do
						item (i, j).put_circle
					end,
				Cross_turn)
		end

feature {NONE} -- Implementation
	field : ARRAY2 [FIELD_CELL]

invariant
	field_exists: field /= Void
	field_width_correct: field.width = Dimension
	field_height_correct: field.height = Dimension
end
