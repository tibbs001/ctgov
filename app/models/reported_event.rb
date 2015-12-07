class ReportedEvent < StudyRelationship

  def self.create_all_from(opts)
    nct_id=opts[:nct_id]
    opts[:xml]=opts[:xml].xpath("//reported_events")
    opts[:time_frame]=opts[:xml].xpath('time_frame').inner_html
    opts[:description]=opts[:xml].xpath('desc').inner_html
    group_xmls=opts[:xml].xpath("group_list").xpath('group')
    groups=[]
    xml=group_xmls.pop
    while xml
      groups << {xml.attribute('group_id').inner_html=>{:title=>xml.xpath('title').inner_html,:description=>xml.xpath('description').inner_html}}
      xml=group_xmls.pop
    end

    opts[:groups]=groups

    event_type='serious'
    opts[:type]=event_type
    outter_xml=opts[:xml].xpath("//#{event_type}_events")
    event_collection=[]
    outter_xml.collect{|xml|
      opts[:frequency_threshold]=xml.xpath('frequency_threshold').inner_html
      opts[:default_vocab]=xml.xpath('default_vocab').inner_html
      opts[:default_assessment]=xml.xpath('default_assessment').inner_html
      cat_xmls=outter_xml.xpath("category_list").xpath('category')
      c_xml=cat_xmls.pop
      if c_xml.nil?
	puts "TODO  need to account for no categories"
      else
        while c_xml
          opts[:category]=c_xml.xpath('title').inner_html
          event_xmls=c_xml.xpath("event_list").xpath('event')
          e_xml=event_xmls.pop
          if e_xml.nil?
	    puts "TODO  need to account for no events"
          else
            while e_xml
              opts[:title]=e_xml.xpath('sub_title').inner_html
              count_xmls=e_xml.xpath("counts")
              o_xml=count_xmls.pop
              if o_xml.nil?
	        puts "TODO  need to account for no counts"
              else
                while o_xml
                  opts[:group_id]=o_xml.attribute('group_id').try(:value)
                  opts[:event_count]=o_xml.attribute('events').try(:value)
                  opts[:subjects_affected]=o_xml.attribute('subjects_affected').try(:value)
                  opts[:subjects_at_risk]=o_xml.attribute('subjects_at_risk').try(:value)
                  event_collection << self.new.create_from(opts)
                  o_xml=count_xmls.pop
	        end
	      end
              e_xml=event_xmls.pop
	    end
	  end
          c_xml=cat_xmls.pop
        end
      end
    }
    opts[:type]='serious'
    serious=get_events(opts)
    opts[:type]='other'
    other=get_events(opts)
    (serious+other).flatten
  end

  # TODO  this can and should be refactored in 100 different ways, but it works for now.
  def self.get_events(opts)
    event_type=opts[:type]
    outter_xml=opts[:xml].xpath("//#{event_type}_events")
    event_collection=[]
    outter_xml.collect{|xml|
      opts[:frequency_threshold]=xml.xpath('frequency_threshold').inner_html
      opts[:default_vocab]=xml.xpath('default_vocab').inner_html
      opts[:default_assessment]=xml.xpath('default_assessment').inner_html
      cat_xmls=outter_xml.xpath("category_list").xpath('category')
      c_xml=cat_xmls.pop
      if c_xml.nil?
	puts "TODO  need to account for no categories"
      else
        while c_xml
          opts[:category]=c_xml.xpath('title').inner_html
          event_xmls=c_xml.xpath("event_list").xpath('event')
          e_xml=event_xmls.pop
          if e_xml.nil?
	    puts "TODO  need to account for no events"
          else
            while e_xml
              opts[:title]=e_xml.xpath('sub_title').inner_html
              count_xmls=e_xml.xpath("counts")
              o_xml=count_xmls.pop
              if o_xml.nil?
	        puts "TODO  need to account for no counts"
              else
                while o_xml
                  opts[:group_id]=o_xml.attribute('group_id').try(:value)
                  opts[:event_count]=o_xml.attribute('events').try(:value)
                  opts[:subjects_affected]=o_xml.attribute('subjects_affected').try(:value)
                  opts[:subjects_at_risk]=o_xml.attribute('subjects_at_risk').try(:value)
                  event_collection << self.new.create_from(opts)
                  o_xml=count_xmls.pop
	        end
	      end
              e_xml=event_xmls.pop
	    end
	  end
          c_xml=cat_xmls.pop
        end
      end
    }
    event_collection
  end

  def create_from(opts)
    gid=opts[:group_id]
    ginfo=(opts[:groups].first)[gid]
    self.group_title=ginfo[:title] if ginfo
    self.group_description=ginfo[:description] if ginfo
    self.ctgov_group_id=gid
    self.ctgov_group_enumerator=integer_in(gid)
    self.nct_id=opts[:nct_id]
    self.category=opts[:category]
    self.event_type=opts[:type]
    self.time_frame=opts[:time_frame]
    self.description=opts[:description]
    self.frequency_threshold=opts[:frequency_threshold]
    self.default_vocab=opts[:default_vocab]
    self.default_assessment=opts[:default_assessment]
    self.title=opts[:title]
    self.event_count=opts[:event_count]
    self.subjects_affected=opts[:subjects_affected]
    self.subjects_at_risk=opts[:subjects_at_risk]
    self
  end

  def type
    event_type
  end
end
