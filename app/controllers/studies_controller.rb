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
    set_study
  end

  def index
    get_studies
    @definitions=DataDefinition.all
  end

  private
    def get_studies
      col=[]
      response = HTTParty.get('http://aact-dev.herokuapp.com/api/v1/studies?page=10&per_page=100')
      response.each{|r| col << instantiate_from(r)} if response
      @studies=col
    end

    def set_study
      id=params[:id]
      response = HTTParty.get("http://aact-dev.herokuapp.com/api/v1/studies/#{id}?with_related_records")
      instantiate_from(response.first.last)
   end

    def instantiate_from(hash)
      brief_summary=BriefSummary.new(hash['brief_summary'])
      design=Design.new(hash['design'])
      participant_flow=ParticipantFlow.new(hash['participant_flow'])
      detailed_description=DetailedDescription.new(hash['detailed_description'])
      eligibility=Eligibility.new(hash['eligibility'])
      sponsors  =(hash['sponsors']   ?  hash['sponsors'].collect{|s|Sponsor.new(s)} : [])
      facilities=(hash['facilities'] ?  hash['facilities'].collect{|f|Facility.new(f)} : [])
      outcomes  =(hash['outcomes']   ?  hash['outcomes'].collect{|f|Outcomes.new(f)}  : [])
      hash['brief_summary']=brief_summary
      hash['design']=design
      hash['participant_flow']=participant_flow
      hash['detailed_description']=detailed_description
      hash['eligibility']=eligibility
      hash['sponsors']=sponsors
      hash['facilities']=facilities
      @study = Study.new(hash)
    end

end

