class DataDefinitionsController < ApplicationController

  def index
		@studies=Study.all
    @definitions=DataDefinition.all
  end

end

