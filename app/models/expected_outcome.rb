class ExpectedOutcome < StudyRelationship
  attr_accessor :type

  def self.create_all_from(options={})
    nct_id=options[:nct_id]
    primary=options[:xml].xpath("//primary_outcome").collect{|xml|
	    create_from({:xml=>xml,:type=>'primary',:nct_id=>nct_id})}

    secondary=options[:xml].xpath("//secondary_outcome").collect{|xml|
	    create_from({:xml=>xml,:type=>'secondary',:nct_id=>nct_id})}
    primary + secondary
  end

  def attribs
    {
      :measure => get('measure'),
      :title => get('measure'),
      :time_frame => get('time_frame'),
      :safety_issue => get('safety_issue'),
      :description => get('description'),
      :population => get('population'),
    }
  end

  def create_from(opts={})
    @xml=opts[:xml]
    self.outcome_type=opts[:type]
    super
  end

  def self.summary
    column_headers= ['nct_id','outcome_type','time_frame','population']
    CSV.open("expected_outcome_report.csv", "wb", :write_headers=> true, :headers => column_headers) {|csv|
      all.each{|g| csv << [g.nct_id,g.outcome_type,g.time_frame,g.population] }
    }
  end

end
