class DesignGroup < StudyRelationship

  def self.top_level_label
    '//arm_group'
  end

  def attribs
    {
     :ctgov_group_id => get_attribute('group_id'),
     :ctgov_group_enumerator => integer_in(get_attribute('group_id')),
     :group_type => get('arm_group_type'),
     :label => get('arm_group_label'),
     :description => get('description'),
    }
  end

  def type
    group_type
  end

end
