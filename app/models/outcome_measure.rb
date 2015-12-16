class OutcomeMeasure < StudyRelationship
  belongs_to :outcome
  belongs_to :group
  attr_accessor :category_xml

  def self.create_all_from(opts)
    all=opts[:xml].xpath("measure_list").xpath('measure')
    col=[]
    xml=all.pop
    if xml.blank?
      col << self.create_from(opts)
    else
      while xml
        opts[:title]=xml.xpath('title').inner_html
        opts[:units]=xml.xpath('units').inner_html
        opts[:param]=xml.xpath('param').inner_html
        opts[:dispersion]=xml.xpath('dispersion').inner_html
        opts[:description]=xml.xpath('description').inner_html
        categories=xml.xpath("category_list").xpath('category')
	      category=categories.pop
	      if category.blank?
          col << create_from(opts)
	      else
	        while category
            opts[:category]=category.xpath('sub_title').inner_html
            groups=category.xpath("measurement_list").xpath('measurement')
	          group=groups.pop
	          if group.blank?
              col << create_from(opts)
	          else
	            while group
                opts[:group_id]=group.attribute('group_id').try(:value)
                opts[:value]=group.attribute('value').try(:value)
                opts[:spread]=group.attribute('spread').try(:value)
                col << create_from(opts)
                group=groups.pop
              end
            end
            category=categories.pop
	        end
	      end
        xml=all.pop
      end
    end
    col.flatten.compact
  end

  def attribs
    {
     :lower_limit => get_attribute('lower_limit'),
     :upper_limit => get_attribute('upper_limit'),
    }
  end

  def create_from(opts)
    return nil if opts[:group_id] != opts[:group_id_of_interest]
    self.outcome=opts[:outcome]
		self.group=self.outcome.group
    self.title=opts[:title]
    self.units=opts[:units]
    self.param=opts[:param]
    self.ctgov_group_id=opts[:group_id]
    self.ctgov_group_enumerator=integer_in(opts[:group_id])
    self.category=opts[:category]
    self.measure_value=opts[:value]
    self.spread=opts[:spread]
    self.dispersion=opts[:dispersion]
    self.description=opts[:description]
    super
    self
  end

end
