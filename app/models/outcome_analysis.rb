class OutcomeAnalysis < StudyRelationship
  belongs_to :actual_outcome

  def self.create_all_from(options={})
    nested_pop_create(options.merge(:name=>'analysis'))
  end

  def self.nested_pop_create(options)
    opts=options
    name=options[:name]
    all=opts[:xml].xpath("analysis_list").xpath('analysis')
    col=[]
    xml=all.pop
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

  def create_from(options={})
    self.title=options[:title]
    self.non_inferiority=options[:non_inferiority]
    self.non_inferiority_description=options[:non_inferiority_description]
    self.p_value=options[:p_value]
    self.param_type=options[:param_type]
    self.param_value=options[:param_value]
    self.ci_percent=options[:ci_percent]
    self.ci_n_sides=options[:ci_n_sides]
    self.ci_lower_limit=options[:ci_lower_limit]
    self.ci_upper_limit=options[:ci_upper_limit]
    self.method=options[:method]
    self.group_description=options[:group_description]
    self.method_description=options[:method_description]
    self.estimate_description=options[:estimate_description]
    super
    self
  end

end
