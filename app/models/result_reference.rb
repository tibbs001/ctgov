	class ResultReference < StudyReference

		def self.top_level_label
			'//results_reference'
		end

		def attribs
			{ :citation => get('citation'),
				:pmid => get('PMID'),
				:reference_type => 'result',
			}
		end

		def type
			reference_type
		end

	end
