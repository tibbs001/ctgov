class ValidationCheck < ActiveRecord::Base

	def self.run
		destroy_all
		count_table_rows
		get_max_column_widths
		create_enumerations
	end

	def self.table_prefix
		''
	end

	def self.count_table_rows
		connection = ActiveRecord::Base.connection
		ActiveRecord::Base.connection.tables.each{|table_name|
			val=connection.execute("select count(*) from #{table_prefix}#{table_name}").first.first
			ValidationCheck.new(:table_name=>table_name,:integer_value=>val,:description=>'number of rows in table').save!
		}
	end

	def self.get_max_column_widths
		connection = ActiveRecord::Base.connection
		col_width_specs.each{|pair|
			c=pair[:column_name]
			t=pair[:table_name]
			val=connection.execute("select max(length(#{c})) from #{table_prefix}#{t}").first.first
			ValidationCheck.new(:table_name=>t,:column_name=>c,:integer_value=>val,:description=>'max column width').save!
		}
	end

	def self.create_enumerations
		connection = ActiveRecord::Base.connection
		enumeration_specs.each{|pair|
			c=pair[:column_name]
			t=pair[:table_name]
			vals=connection.execute("select distinct #{c} from #{table_prefix}#{t}")
			vals.each{|v|
				ValidationCheck.new(:table_name=>t,:column_name=>c,:string_value=>v.first,:description=>'enumeration').save!
			}
		}
	end

	def self.get_old_max_column_widths
		connection = ActiveRecord::Base.connection
		OldCrap.col_width_specs.each{|pair|
			c=pair[:column_name]
			t=pair[:table_name]
			val=connection.execute("select max(length(#{c})) from clintrialsgov.#{t}").first.first
			ValidationCheck.new(:table_name=>t,:column_name=>c,:string_value=>val,:description=>'max column width').save!
		}
	end

	def self.enumeration_specs
		[
			{:column_name=>'study_type',				:table_name=>'studies'},
			{:column_name=>'biospec_retention',	:table_name=>'studies'},
			{:column_name=>'dispersion_type',		:table_name=>'outcome_analyses'},
			{:column_name=>'method',						:table_name=>'outcome_analyses'},
			{:column_name=>'group_type',				:table_name=>'groups'},
			{:column_name=>'dispersion',				:table_name=>'baseline_measures'},
			]
	end

	def self.col_width_specs
		[
			{:column_name=>'pmid',:table_name=>'study_references'},
			{:column_name=>'citation',:table_name=>'study_references'},
			{:column_name=>'acronym',:table_name=>'studies'},
			{:column_name=>'affiliation',:table_name=>'responsible_parties'},
			{:column_name=>'affiliation',:table_name=>'overall_officials'},
			{:column_name=>'agency',:table_name=>'sponsors'},
			{:column_name=>'agency_class',:table_name=>'sponsors'},
			{:column_name=>'name',:table_name=>'oversight_authorities'},
			{:column_name=>'brief_title',:table_name=>'studies'},
			{:column_name=>'description',:table_name=>'brief_summaries'},
			{:column_name=>'biospec_description',:table_name=>'studies'},
			{:column_name=>'biospec_retention',:table_name=>'studies'},
			{:column_name=>'description',:table_name=>'groups'},
			{:column_name=>'title',:table_name=>'groups'},
			{:column_name=>'group_type',:table_name=>'groups'},
			{:column_name=>'default_assessment',:table_name=>'reported_events'},
			{:column_name=>'description',:table_name=>'reported_events'},
		]
	end

end
