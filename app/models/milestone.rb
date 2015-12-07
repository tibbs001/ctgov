  class Milestone < StudyRelationship
    belongs_to :period

    def self.create_all_from(opts={})
      nested_pop_create(opts.merge(:name=>'milestone'))
    end

    def self.nested_pop_create(opts)
      name=opts[:name]
      all=opts[:xml].xpath("#{name}_list").xpath(name)
      col=[]
      xml=all.pop
      while xml
	      opts[:xml]=xml
	      opts[:title]=xml.xpath('title').inner_html
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

    def create_from(opts={})
      @xml=opts[:xml]
      self.period=opts[:period]
      self.title=opts[:title]
      super
    end

  end
