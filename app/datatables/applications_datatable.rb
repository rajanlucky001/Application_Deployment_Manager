class ApplicationsDatatable
  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Application.count,
        iTotalDisplayRecords: applications.total_entries,
        aaData: data
    }
  end

  private
  def data
    applications.map do |application|
      [
          h(application.id),
          h(application.name),
          h(application.description),
          h(application.created_at),
          h(application.updated_at),
          link_to('Show',application)+link_to('Modify', controller: :applications, action: :edit, id: application)+
          link_to('Destroy', application, confirm: 'Are you sure?', method: :delete)+
          link_to('Manage version')

      ]
    end
  end

  def applications
    @applications ||= fetch_applications
  end

  def fetch_applications
    applications = Application.order("#{sort_column} #{sort_direction}")
    applications = applications.page(page).per_page(per_page)
    if params[:sSearch].present?
      applications = applications.where("name like :search or updated_at like :search or created_at like :search", search: "%#{params[:sSearch]}%")
    end
    applications
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id name created_at updated_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end