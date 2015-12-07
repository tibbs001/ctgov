	class LoadEvent < ActiveRecord::Base
		establish_connection "ctgov_#{Rails.env}".to_sym if Rails.env != 'test'
	end
