class CreateClinicalCategories < ActiveRecord::Migration
  def change
    create_table :clinical_categories do |t|
			t.string  :unique_id
			t.string  :domain_name
      t.timestamps null: false
    end

    create_table :clinical_domains do |t|
			t.string  :comment
      t.timestamps null: false
    end
		add_column :clinical_domains, :nct_id, :string, references: :studies
  	add_column :clinical_domains, :clinical_category_id, :integer, references: :clinical_categories
  	add_column :clinical_domains, :user_id, :string, references: :users
	end
end
