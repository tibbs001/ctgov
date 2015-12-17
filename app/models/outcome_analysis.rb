class OutcomeAnalysis < StudyRelationship
  belongs_to :outcome
  belongs_to :group

  def self.create_all_from(opts)
    all=opts[:xml].xpath("analysis_list").xpath('analysis')
    col=[]
    xml=all.pop
		return col if xml.blank?
    while xml
			opts[:xml]=xml
			opts[:title]=xml.xpath('title')
			opts[:non_inferiority]=xml.xpath('non_inferiority').inner_html
			opts[:non_inferiority_description]=xml.xpath('non_inferiority_desc').inner_html
			opts[:p_value]=xml.xpath('p_value').inner_html
			opts[:param_type]=xml.xpath('param_type').inner_html
			opts[:param_value]=xml.xpath('param_value').inner_html
			opts[:ci_percent]=xml.xpath('ci_percent').inner_html
			opts[:ci_n_sides]=xml.xpath('ci_n_sides').inner_html
			opts[:ci_lower_limit]=xml.xpath('ci_lower_limit').inner_html
			opts[:ci_upper_limit]=xml.xpath('ci_upper_limit').inner_html
			opts[:method]=xml.xpath('method').inner_html
			opts[:group_description]=xml.xpath('groups_desc').inner_html
			opts[:method_description]=xml.xpath('method_desc').inner_html
			opts[:estimate_description]=xml.xpath('estimate_desc').inner_html
			col << pop_create(opts.merge(:name=>'group_id'))
		  xml=all.pop
		end
    col.flatten
  end

  def attribs
    {
     :ctgov_group_id => xml.inner_html,
     :ctgov_group_enumerator => integer_in(xml.inner_html),
    }
  end

  def create_from(opts)
    return nil if opts[:outcome].group.ctgov_group_enumerator != integer_in(opts[:group_id_of_interest])
    self.outcome=opts[:outcome]
    self.group=self.outcome.group
    self.title=opts[:title]
    self.non_inferiority=opts[:non_inferiority]
    self.non_inferiority_description=opts[:non_inferiority_description]
    self.p_value=opts[:p_value]
    self.param_type=opts[:param_type]
    self.param_value=opts[:param_value]
    self.ci_percent=opts[:ci_percent]
    self.ci_n_sides=opts[:ci_n_sides]
    self.ci_lower_limit=opts[:ci_lower_limit]
    self.ci_upper_limit=opts[:ci_upper_limit]
    self.method=opts[:method]
    self.group_description=opts[:group_description]
    self.method_description=opts[:method_description]
    self.estimate_description=opts[:estimate_description]
    super
    self
  end

end
