class DevicesDatatable
  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Device.count,
        iTotalDisplayRecords: devices.total_entries,
        aaData: data
    }
  end

  private
  def data
    devices.map do |device|
      [
          h(device.id),
          h(device.affiliate),
          h(device.headend),
          h(device.deviceModel),
          h(device.ipAddress),
          h(device.osType),
          h(device.osVersion),
          h(device.biv),
          link_to('Show',device)+link_to('Modify', controller: :devices, action: :edit, id: device)+
              link_to('Destroy', device , confirm: 'Are you sure?', method: :delete)
      ]
    end
  end

  def devices
    @devices ||= fetch_devices
  end

  def fetch_devices
    devices = Device.order("#{sort_column} #{sort_direction}")
    devices = devices.page(page).per_page(per_page)
    if params[:sSearch].present?
      devices = devices.where("affiliate like :search", search: "%#{params[:sSearch]}%")
    end
    devices
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id affiliate headend deviceModel ipAddress osType osVersion biv]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end