desc 'Create all studies'

task :load_studies => :environment do
	Asker.new.create_all_studies
end

task :load_files => :environment do
	Asker.new.load_files
end

task :create_one_study => :environment do
	Asker.new.create_study('NCT01381822')
end
