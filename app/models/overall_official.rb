class OverallOfficial < StudyRelationship

  def self.top_level_label
    '//overall_official'
  end

  def attribs
    {:name => get('last_name'),
     :role => get('role'),
     :affiliation => get('affiliation')}
  end

end
