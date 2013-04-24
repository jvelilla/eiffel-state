indexing
	description	: "Main window for this application."
	author		: ""
	date		: "$Date$"
	revision	: "$Revision$"

class
	MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

create
	make

feature {NONE} -- Initialization

	make (w, h: INTEGER; widget: EV_WIDGET) is
		do
			main_widget := widget
			Window_width := w
			Window_height := h
			default_create
		end


	initialize is
			-- Build the interface for this window.
		do
			Precursor {EV_TITLED_WINDOW}

			build_main_container
			extend (main_container)

				-- Close window when the user clicks
				-- on the cross in the title bar.
			close_request_actions.extend (agent destroy_and_exit_if_last)

				-- Set the title of the window
			set_title (Window_title)

				-- Set the initial size of the window

			set_size (Window_width, Window_height)

			set_centered

			disable_user_resize
		end

	set_centered is
			-- Moves window to the center of the screen
		local
			screen: EV_SCREEN
		do
			create screen
			set_position ((screen.width - Window_width) // 2,
						  (screen.height - Window_height) // 2)
		end


	is_in_default_state: BOOLEAN is
			-- Is the window in its default state
			-- (as stated in `initialize')
		do
			Result := (width = Window_width) and then
				(height = Window_height) and then
				(title.is_equal (Window_title))
		end

feature {NONE} -- Implementation

	main_container: EV_FRAME
			-- Main container (contains all widgets displayed in this window)

	build_main_container is
			-- Create and populate `main_container'.
		require
			main_container_not_yet_created: main_container = Void
		do
			create main_container

			main_container.extend (main_widget)
		ensure
			main_container_created: main_container /= Void
		end

	main_widget: EV_WIDGET

feature {NONE} -- Implementation / Constants

	Window_title: STRING is "Strategy Game"
			-- Title of the window.

	Window_width: INTEGER
			-- Initial width for this window.

	Window_height: INTEGER
			-- Initial height for this window.

end -- class MAIN_WINDOW
