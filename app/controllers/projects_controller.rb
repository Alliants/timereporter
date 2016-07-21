class ProjectsController < ApplicationController

  def index
    @projects = Project.active.ordered_by_title.group_by{|u| u.title[0]}
    @project_count = Project.active.count
  end

  def show
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html
      format.json
    end
  end

end
