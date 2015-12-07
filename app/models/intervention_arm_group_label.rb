class InterventionArmGroupLabel < StudyRelationship

  def self.top_level_label
    'arm_group_label'
  end

  def attribs
    {:label=>xml.inner_html}
  end

end
