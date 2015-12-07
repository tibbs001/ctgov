class StudyReference < StudyRelationship
  self.table_name='study_references'

  def self.top_level_label
    '//reference'
  end

  def attribs
    { :citation => get('citation'),
      :pmid => get('PMID'),
      :reference_type => 'study',
    }
  end

  def type
    reference_type
  end
end
