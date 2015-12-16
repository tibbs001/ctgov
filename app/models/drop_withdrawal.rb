class DropWithdrawal < StudyRelationship
  belongs_to :group

  def self.create_all_from(opts)
    self.nested_pop_create(opts.merge(:name=>'drop_withdraw_reason'))
  end

  def self.nested_pop_create(opts)
    name=opts[:name]
    all=opts[:xml].xpath("//#{name}_list").xpath(name)
    col=[]
    xml=all.pop
    while xml
      opts[:reason]=xml.xpath('title').inner_html
		  opts[:period_title]=xml.parent.parent.xpath('title').inner_html
      groups=xml.xpath("participants_list").xpath('participants')
      group=groups.pop
			while group
        col << create_from(opts.merge(:xml=>group))
        group=groups.pop
			end
      xml=all.pop
    end
    col.flatten
  end

  def create_from(opts)
		@xml=opts[:xml]
		gid=get_attribute('group_id')
    self.nct_id=opts[:nct_id]
    self.reason=opts[:reason]
    self.period_title=opts[:period_title]
    self.participant_count=get_attribute('count').to_i
		self.ctgov_group_id=gid
		self.ctgov_group_enumerator=integer_in(gid)
		opts[:groups].each{|g|
		  self.group=g if g.ctgov_group_enumerator==self.ctgov_group_enumerator
		}
		self.save!
		self
  end

  def self.extract_summary
    column_headers= ['nct_id','period','group','participant_count','reason']

    CSV.open("#{self.name}_Summary.csv", "wb", :write_headers=> true, :headers => column_headers) {|csv|
      all.each{|x|
        csv << [x.nct_id,
		    x.period_title,
		    x.group.title,
		    x.participant_count,
		    x.reason]
      }
    }
  end

end
