class InterventionOtherName < StudyRelationship

  def self.top_level_label
    'other_name'
  end

  def attribs
    {:name=>xml.inner_html}
  end

end
