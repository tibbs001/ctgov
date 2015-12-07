	class BaselineMeasure < StudyRelationship

		def self.create_all_from(options={})
			opts=options
			all=options[:xml].xpath('//baseline').xpath("measure_list").xpath('measure')
			col=[]
			xml=all.pop
			while xml
				opts[:description]=xml.xpath('description').inner_html
				opts[:title]=xml.xpath('title').inner_html
				opts[:units]=xml.xpath('units').inner_html
				opts[:param]=xml.xpath('param').inner_html
				opts[:dispersion]=xml.xpath('dispersion').inner_html
				opts[:name]='category'
				opts[:xml]=xml
				col << nested_pop_create(opts)
				xml=all.pop
			end
			col.flatten
		end

		def self.nested_pop_create(options)
			opts=options
			name=options[:name]
			all=options[:xml].xpath("#{name}_list").xpath(name)
			col=[]
			xml=all.pop
			while xml
				opts[:category]=xml.xpath('sub_title').inner_html
				opts[:xml]=xml
				opts[:name]='measurement'
				col << pop_create(opts)
				xml=all.pop
			end
			col.flatten
		end

		def attribs
			{
			 :ctgov_group_id => get_attribute('group_id'),
			 :ctgov_group_enumerator => integer_in(get_attribute('group_id')),
			 :measure_value => get_attribute('value'),
			 :lower_limit => get_attribute('lower_limit'),
			 :upper_limit => get_attribute('upper_limit'),
			 :spread => get_attribute('spread'),
			 :measure_description => xml.inner_html
			}
		end

		def create_from(options={})
			self.category=options[:category]
			self.title=options[:title]
			self.description=options[:description]
			self.units=options[:units]
			self.param=options[:param]
			self.dispersion=options[:dispersion]
			super
		end

	end
