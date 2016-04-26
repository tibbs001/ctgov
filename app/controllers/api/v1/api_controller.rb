module Api
  class StudyController < ApplicationController

		def index
			serialize_options = {:dasherize => false}
			if params[:include] == 'outcomes'
				serialize_options.merge!(:include => :all_outcomes)
				@studies = Study.include(:outcomes)
			else
				@studies = Study.all
			end
			if @studies.empty?
				render :text => nil, :status => 404 and return
			end
			respond_to do |format|
				format.xml {render :xml => @studies.to_xml(serialize_options)}
				format.json do
					render :json => "{\"all_studies\":[#{@studies.collect{|p| p.to_json(serialize_options)}.join(",")}]}"
				end
			end
		end

		def create
			render json: params.to_json
		end

		def show
		end
	end
end

