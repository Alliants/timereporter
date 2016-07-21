class TimeEntriesController < ApplicationController

  before_filter :load_resources, except: [:index, :create]

  def index
    date_param
    @time_entries = current_user.time_entries.for_date(@date).to_a
    respond_with(@time_entries)
  end

  def create
    if time_entries_params.present?
      @time_entries = current_user.time_entries.create(time_entries_params.fetch(:time_entries).values)
    elsif time_entry_params.present?
      @time_entry = current_user.time_entries.create(time_entry_params)
    end
  end

  def update
    @time_entry.update_attributes(time_entry_params)
  end

  def update_many
    byebug
    # if time_entry.fetch(:project_id).blank?
    #   time_entry.project_id = nil
    # end
    #
    # TimeEntry
    #   .where(id: time_entries_params)
    #   .update_all(project_id: time_entry.fetch(:project_id), comment: time_entry.fetch(:comment))
    #
    # @time_entries = TimeEntry.find(time_entries_params)
  end

  def destroy
    @time_entry.destroy
  end

  def destroy_many
    @time_entries = TimeEntry.find(params[:time_entries])
    TimeEntry.where(id: params[:time_entries]).delete_all
  end

  def edit
  end

  private

  def time_entry
    params.fetch(:time_entry)
  end

  def time_entries_params
    params.permit(time_entries: [:id, :entry_datetime, :duration])
  end

  def time_entry_params
    params.require(:time_entry)
      .permit(:id, :entry_datetime, :duration, :project_id, :comment)
  end

end

