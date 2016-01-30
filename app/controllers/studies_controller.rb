class StudiesController < ApplicationController
  before_action :set_study, only: [:show, :edit]

  # GET /studies
  # GET /studies.json
  def index
    #sample_ids.each {|x| @studies << Study.find_by_nct_id(x)}
    #@studies
    #@studies=Study.completed_since(Date.today-100.days)
    @studies=Study.sponsored_by('Duke')
    @studies=Study.all
    @definitions=DataDefinition.all
    #@studies=[Study.find_by_nct_id('NCT01132846')]
    #@studies=Study.all
  end

  # GET /studies/1
  # GET /studies/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_study
      @study = Study.find_by_nct_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def study_params
      params[:study]
    end
end
