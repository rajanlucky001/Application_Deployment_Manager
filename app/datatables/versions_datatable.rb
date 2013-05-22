class VersionsDatatable
  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Version.where(["application_id = ?", params[:application_id]]).count,
        iTotalDisplayRecords: versions.total_entries,
        aaData: data
    }
  end

  private
  def data
    @application = Application.find(params[:application_id])
    versions.map do |version|
      [
          h(version.id),
          h(version.version),
          h(version.created_at),
          h(version.updated_at),
          link_to('Show',[@application, version])+"|"+link_to('Modify', controller: :versions, action: :edit, application_id: @application, id: version)+"|"+link_to('Destroy', [@application, version], confirm: 'Are you sure?', method: :delete)
      ]
    end
  end

  def versions
    @versions ||= fetch_versions
  end

  def fetch_versions
    versions = Version.order("#{sort_column} #{sort_direction}").where(["application_id = ?", params[:application_id]])
    versions = versions.page(page).per_page(per_page)
    if params[:sSearch].present?
      versions = versions.where("version like :search or created_at like :search or updated_at like :search", search: "%#{params[:sSearch]}%")
    end
    versions
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id version created_at updated_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end