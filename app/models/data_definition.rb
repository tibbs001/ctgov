require 'csv'
class DataDefinition < ActiveRecord::Base

  def self.nlm_info_for(column_name)
    find_by_column_name(column_name).nlm_definition
  end

  def self.ctti_info_for(column_name)
    find_by_column_name(column_name).ctti_notes
  end

  def self.load
    csv_text = File.read('csv/DataDictionary.csv', :encoding => 'windows-1251:utf-8')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each {|row|
      self.create!(row.to_hash)
    }
  end
end
