  class Milestone < StudyRelationship
    belongs_to :group

    def self.create_all_from(opts)
      nested_pop_create(opts.merge(:name=>'milestone'))
    end

    def self.nested_pop_create(opts)
      name=opts[:name]
      all=opts[:study_xml].xpath("//#{name}_list").xpath(name)
      col=[]
      xml=all.pop
      while xml
	      opts[:xml]=xml
	      opts[:title]=xml.xpath('title').inner_html
			  opts[:period_title]=xml.parent.parent.xpath('title').inner_html
	      col << pop_create(opts.merge(:name=>'participants'))
	      xml=all.pop
      end
      col.flatten
    end

    def attribs
      {
       :ctgov_group_id => get_attribute('group_id'),
       :ctgov_group_enumerator => integer_in(get_attribute('group_id')),
       :participant_count => get_attribute('count').to_i,
       :description => xml.inner_html,
      }
    end

    def create_from(opts)
      @xml=opts[:xml]
      self.title=opts[:title]
			group_node=xml.attribute('group_id')
			gid=group_node.try(:value)
			self.period_title=opts[:period_title]
			opts[:groups].each{|g| self.group=g if g.ctgov_group_enumerator==integer_in(gid)}
      super
    end

  end
