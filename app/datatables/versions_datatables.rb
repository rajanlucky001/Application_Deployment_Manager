class VersionsDatatable
  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Version.count,
        iTotalDisplayRecords: version.total_entries,
        aaData: data
    }
  end

  private
  def data
    Versions.map do |version|
      [
          h(version.id),
          h(version.version),
          h(version.created_at),
          h.(version.updated_at),
          link_to('Show',version),
          link_to('Modify', controller: :applications, action: :edit, id: version),
          link_to('Destroy', version, confirm: 'Are you sure?', method: :delete),
          link_to('Profile')

      ]
    end
  end

  def versions
    @versions ||= fetch_versions
  end

  def fetch_versions
    versions = version.order("#{sort_column} #{sort_direction}")
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
    columns = %w[version created_at updated_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end