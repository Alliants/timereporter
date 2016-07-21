class Project < ActiveRecord::Base
  FILTERABLE = [:billable, :utilised]

  has_many :time_entries

  validates :title, presence: true

  scope :ordered_by_title, -> { order(title: :asc) }
  scope :active, -> { where(status: 'Active') }

  def self.filter(key)
    where(key.to_sym => key.to_s.titleize) if FILTERABLE.include?(key)
  end

  def self.fetch_remote_projects(args = {})
    PodioProjectFetcher.new(args).fetch
  end

  def self.create_or_update(params={})
    project = self.find_by_title(params[:title]) || self.new
    project.update_attributes_no_raise(params)
  end

  def update_attributes_no_raise(attributes)
    attributes.each{ |k, v|  send("#{k}=", v) if respond_to?("#{k}=") }
    save
  end

  def name
    title
  end

  def client_name
    client_company || ""
  end

  def self.client_group
    clients = Project.active.all.map(&:client_name).uniq.sort
    collection = clients.map do |client|
      client_company = client if client.present?
      OpenStruct.new(name: client, projects: Project.active.where(client_company: client_company))
    end
  end

end
