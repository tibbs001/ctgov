	class Sponsor < StudyRelationship

		scope :named, lambda {|agency| where("agency LIKE ?", "#{agency}%" )}

		def self.create_all_from(opts)
			leads(opts) + collaborators(opts)
		end

		def self.leads(opts)
			opts[:xml].xpath("//lead_sponsor").collect{|xml|
				Sponsor.new.create_from({:xml=>xml,:type=>'lead',:nct_id=>opts[:nct_id]}) }
		end

		def self.collaborators(opts)
			opts[:xml].xpath("//collaborator").collect {|xml|
		Sponsor.new.create_from({:xml=>xml,:type=>'collaborator',:nct_id=>opts[:nct_id]}) }
		end

		def create_from(opts)
			@xml=opts[:xml]
			self.sponsor_type= opts[:type]
			self.agency = get('agency')
			self.agency_class = get('agency_class')
			self.nct_id = opts[:nct_id]
			self
		end

	end
