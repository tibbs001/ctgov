class Period < StudyRelationship

  has_many :milestones
  has_many :drop_withdrawals

  def self.create_all_from(opts)
    nct_id=opts[:nct_id]
    opts[:xml]=opts[:xml].xpath('//participant_flow')
    all_periods=opts[:xml].xpath("period_list").xpath('period')
    col=[]
    xml=all_periods.pop
    while xml
      opts[:xml]=xml
      opts[:title]=xml.xpath('title').inner_html
      col << create_from(opts)
      xml=all_periods.pop
    end
    col.flatten
  end

  def create_from(opts)
    @xml=opts[:xml]
    self.nct_id=opts[:nct_id]
    self.title=opts[:title]
    self.milestones << Milestone.create_all_from(opts.merge(:period=>self))
    self.drop_withdrawals << DropWithdrawal.create_all_from(opts.merge(:period=>self))
    save!
    self
  end

end
