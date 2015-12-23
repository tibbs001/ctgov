	class Reference < StudyRelationship
  self.table_name='study_references'

		def self.nodes(opts)
			opts[:xml].xpath('//reference') + opts[:xml].xpath('//results_reference')
		end

		def self.create_all_from(opts)
			col=[]
			Reference.nodes(opts).each{|xml|
				opts[:xml]=xml
				col << create_from(opts)
			}
			col.compact
		end

		def create_from(opts)
      self.reference_type=opts[:xml].name
			super
			self
		end

		def attribs
			{ :citation => get('citation'),
				:pmid => get('PMID'),
			}
		end

		def type
			reference_type
		end

	end
