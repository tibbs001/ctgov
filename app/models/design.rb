class Design < StudyRelationship

  def attribs
    {:description=>xml.xpath("//study_design").try(:inner_html)}
  end

end
