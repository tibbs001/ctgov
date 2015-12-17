require 'csv'
require 'active_support/all'
	class StudyRelationship < ActiveRecord::Base

		self.abstract_class = true;
	  establish_connection "ctgov_#{Rails.env}".to_sym if Rails.env != 'test'
		attr_accessor :xml, :wrapper1_xml, :is_new
		belongs_to :study, :foreign_key=> 'nct_id'

		def self.create_all_from(opts)
			xml_entries(opts).collect{|xml|
				opts[:xml]=xml
				create_from(opts)
			}.compact
		end

		def self.pop_create(opts)
			name=opts[:name]
			list=opts[:xml].xpath("#{name}_list") if opts[:xml]
			all=(list ? list.xpath(name) : [])
			col=[]
			xml=all.pop
			while xml
				opts[:xml]=xml
				col << create_from(opts)
				xml=all.pop
			end
			col
		end

		def self.top_level_label
			puts '#top_level_label: subclass responsibility!'
		end

		def self.xml_entries(opts)
			opts[:xml].xpath(top_level_label)
		end

		def self.create_from(opts)
			new.create_from(opts)
		end

		def self.remove_existing(nct_id)
			existing=self.where(nct_id: nct_id)
			existing.each{|x|x.destroy!}
		end

		def wrapper1_xml
			@wrapper1_xml ||= Nokogiri::XML('')
		end

		def create_from(opts={})
			@xml=opts[:xml]
			@wrapper1_xml=opts[:wrapper1_xml]
			self.nct_id=opts[:nct_id]
			update_attributes(attribs) if !attribs.blank?
			save!
			self
		end

		def opts
			{
			 :xml=>xml,
			 :nct_id=>nct_id,
			 :is_new=>true,
			}
		end

		def get_from_wrapper1(label)
			wrapper1_xml.xpath("#{label}").inner_html
		end

		def get(label)
			xml.xpath("#{label}").inner_html
		end

		def get_text(label)
			str=''
			nodes=xml.xpath("//#{label}")
			nodes.each {|node| str << node.xpath("textblock").inner_html}
			str
		end

		def get_child(label)
			xml.children.collect{|child| child.text if child.name==label}.compact.first
		end

		def get_attribute(label)
			xml.attribute(label).try(:value) if !xml.blank?
		end

		def integer_in(str)
			str.scan(/[0-9]/).join.to_i if !str.blank?
		end

		def self.integer_in(str)
			str.scan(/[0-9]/).join.to_i if !str.blank?
		end

		def self.trim(str)
			str.tr("\n\t ", "")
		end

	end
