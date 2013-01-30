class TimeEntriesController < ApplicationController

  before_filter :load_resources, except: :index

  def index
    @date = params[:date] || Date.today
    @time_entries = TimeEntry.for_user(current_user).for_date(@date)

    respond_with { @time_entries }
  end

  def create
    @time_entry.user = current_user
    @time_entry.save
  end

  def update
    @time_entry.update_attributes(params[:time_entry])
  end

  def destroy
    @time_entry.destroy
  end

end

