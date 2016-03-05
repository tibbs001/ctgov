class AddLinkToStudyData < ActiveRecord::Migration
  def change
		add_column :studies, :link_to_data, :string
  end
end
