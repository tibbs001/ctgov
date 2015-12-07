class DropWithdrawal < StudyRelationship
  belongs_to :period

  def self.create_all_from(opts)
    self.nested_pop_create(opts.merge(:name=>'drop_withdraw_reason'))
  end

  def self.nested_pop_create(opts)
    name=opts[:name]
    all=opts[:xml].xpath("#{name}_list").xpath(name)
    col=[]
    xml=all.pop
    while xml
      opts[:xml]=xml
      opts[:reason]=xml.xpath('title').inner_html
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
    }
  end

  def create_from(opts)
    self.reason=opts[:reason]
    super
  end

  def self.extract_summary
    column_headers= ['nct_id','period','group','participant_count','reason']

    CSV.open("#{self.name}_Summary.csv", "wb", :write_headers=> true, :headers => column_headers) {|csv|
      all.each{|x|
        csv << [x.nct_id,
		x.period.title,
		x.group.title,
		x.participant_count,
		x.reason]
      }
    }
  end

end
