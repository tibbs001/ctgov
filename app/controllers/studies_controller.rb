class StudiesController < ApplicationController
  before_action :set_study, only: [:show, :edit]

  def search
    if params[:search].present?
      @studies = Study.search(params[:search])
    else
      @studies=get_studies
    end
  end

  def show
    puts "=================================== Study Controller show params #{params}"
    set_study
  end

  # GET /studies
  # GET /studies.json
  def index
    #@studies=Study.sponsored_by('Duke')
    get_studies
    @definitions=DataDefinition.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def get_studies
      col=[]
      response = HTTParty.get('http://aact.ctti-clinicaltrials.org/api/v1/studies')
      response.each{|r|
        s=Study.new(r)
        puts s.inspect
        col << s
        puts "col size: #{col.size}"
      }
      puts "number collected is #{col.size}"
      @studies=col
    end

    def set_study
      id=params[:id]
      response = HTTParty.get("http://aact.ctti-clinicaltrials.org/api/v1/studies/#{id}")
      @study = Study.new(response.first.last)
    end

end

