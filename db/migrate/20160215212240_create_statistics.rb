class CreateStatistics < ActiveRecord::Migration
  def change
		create_table :validation_checks do |t|
			t.string  :description
			t.string  :table_name
			t.string  :column_name
			t.string  :string_value
			t.integer :integer_value
      t.timestamps null: false
		end

    create_table :statistics do |t|
			t.date    :start_date
			t.date    :end_date
			t.string  :sponsor_type
			t.string  :stat_category
			t.string  :stat_value
			t.integer :number_of_studies
      t.timestamps null: false
    end
  end
end
