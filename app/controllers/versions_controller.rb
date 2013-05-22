class VersionsController < ApplicationController
  before_filter :setup
  # GET /versions
  # GET /versions.json
  def index
    @versions = @application.versions.all
    respond_to do |format|
      format.html
      format.json { render json: VersionsDatatable.new(view_context) }
    end
  end

  # GET /versions/1
  # GET /versions/1.json
  def show
    @version = Version.find(params[:id])
    @versionconfig= @version.version_configurations.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @version }
    end
  end

  # GET /versions/new
  # GET /versions/new.json
  def new
    @version = Version.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @version }
    end
  end

  # GET /versions/1/edit
  def edit
    @version = @application.versions.find(params[:id])
    @versionconfig= @version.version_configurations.all
  end

  # POST /versions
  # POST /versions.json
  def create
    count = params[:version]['param_count'].to_i
    @version = Version.new({version: params[:version]['version'], application_id: params[:application_id]})
    @version.save!
    version_id = @version.id
    i=1
    while(i<=count)
      @configuration = VersionConfiguration.new({key: params[:version]['key'+i.to_s], value: params[:version]['value'+i.to_s], version_id: version_id})
      @configuration.save!
      i=i+1
    end

    respond_to do |format|
      if @version.save
        format.html { redirect_to [@application, @version], notice: 'Version was successfully created.' }
        format.json { render json: @version, status: :created, location: @version }
      else
        format.html { render action: "new" }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /versions/1
  # PUT /versions/1.json
  def update
    @version = @application.versions.find(params[:id])
    count = params['param_count'].to_i
    i=1
    saved=false
    error =""
    @version.version_configurations.destroy_all
    begin
      while(i<=count)
        @configuration = VersionConfiguration.new({key: params[:version]['key'+i.to_s], value: params[:version]['value'+i.to_s], version_id: params[:id]})
        saved = @configuration.save!
        i=i+1
      end
    rescue => ex
      saved = false
      error=ex.backtrace.join('\n')
    end


    respond_to do |format|
      if saved
        format.html { redirect_to [@application, @version], notice: 'Version was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        #@version.errors[]=error;
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /versions/1
  # DELETE /versions/1.json
  def destroy
    @version = Version.find(params[:id])
    @versionconfig = @version.version_configurations.destroy_all
    @version.destroy

    respond_to do |format|
      format.html { redirect_to [@application, @version] }
      format.json { head :no_content }
    end
  end

  def setup
    @application = Application.find(params[:application_id])
  end
end
