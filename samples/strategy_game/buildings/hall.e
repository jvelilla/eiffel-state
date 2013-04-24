note
	description: "City halls that train workers, heroes and doctors."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HALL

inherit
	BUILDING

create
	make

feature -- Access
	type: STRING is "Hall"

	creation_time: DOUBLE is 50.0
			-- Time required to build hall

	actions: LIST [ACTION [TUPLE]] is
		do
			Result := create {LINKED_LIST [ACTION [TUPLE]]}.make
			Result.extend (create {ACTION [TUPLE]}.make (agent train_worker, "train worker"))
			Result.extend (create {ACTION [TUPLE]}.make (agent train_hero, "train hero"))
			Result.extend (create {ACTION [TUPLE]}.make (agent train_doctor, "train doctor"))
		end

	last_trained_being: BEING

feature -- Basic operations
	train_worker is
			-- Train worker
		local
			worker: WORKER
		do
			create worker.make (position, team_name)
--			unit_manager.add_unit (worker)
			last_trained_being := worker
			worker.draw
		ensure
			worker_created: last_trained_being /= Void
		end

	train_hero is
			-- Train hero
		local
			hero: HERO
		do
			create hero.make (position, team_name)
--			unit_manager.add_unit (hero)
			last_trained_being := hero
			hero.draw
		ensure
			hero_created: last_trained_being /= Void
		end

	train_doctor is
			-- Train doctor
		local
			doc: DOCTOR
		do
			create doc.make (position, team_name)
--			unit_manager.add_unit (doc)
			last_trained_being := doc
			doc.draw
		ensure
			doc_created: last_trained_being /= Void
		end
end
