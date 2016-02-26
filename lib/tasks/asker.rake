desc 'Create all studies'

task :load_studies => :environment do
	Asker.new.create_all_studies
end

task :pull_down_studies => :environment do
	Asker.new.pull_down_studies
end

task :load_1_files => :environment do
	Asker.new.monthly_loader('1')
end

task :load_2_files => :environment do
	Asker.new.monthly_loader('2')
end

task :load_3_files => :environment do
	Asker.new.monthly_loader('3')
end

task :load_4_files => :environment do
	Asker.new.monthly_loader('4')
end

task :load_5_files => :environment do
	Asker.new.monthly_loader('5')
end

task :load_6_files => :environment do
	Asker.new.monthly_loader('6')
end

task :load_7_files => :environment do
	Asker.new.monthly_loader('7')
end

task :load_8_files => :environment do
	Asker.new.monthly_loader('8')
end

task :load_9_files => :environment do
	Asker.new.monthly_loader('9')
end

task :load_0_files => :environment do
	Asker.new.monthly_loader('0')
end

task :create_one_study => :environment do
	Asker.new.create_study('NCT01381822')
end
