class ServersController < ApplicationController
  include ServerRegistry::Servers::BaseLogic
  include ServerRegistry::Categories::BaseLogic

  # GET /servers
  # GET /servers.json
  def index
    @servers = all_servers

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @servers }
    end
  end

  # GET /servers/1
  # GET /servers/1.json
  def show
    @server = get_server(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @server }
    end
  end

  # GET /servers/new
  # GET /servers/new.json
  def new
    @server = Server.new
    @categories = all_category_names

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @server }
    end
  end

  # GET /servers/1/edit
  def edit
    @server = get_server(params[:id])
    @categories = all_category_names
  end

  # POST /servers
  # POST /servers.json
  def create
    category_names = extract_category_names_param

    @server = new_server_with_params(params[:server])
    associate_server_with_categories(@server, category_names)

    respond_to do |format|
      if @server.save
        format.html { redirect_to @server, notice: 'Server was successfully created.' }
        format.json { render json: @server, status: :created, location: @server }
      else
        format.html { render action: "new" }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /servers/1
  # PUT /servers/1.json
  def update
    category_names = extract_category_names_param

    @server = get_server(params[:id])
    associate_server_with_categories(@server, category_names)

    respond_to do |format|
      if @server.update_attributes(params[:server])
        format.html { redirect_to @server, notice: 'Server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1
  # DELETE /servers/1.json
  def destroy
    @server = get_server(params[:id])
    @server.destroy

    respond_to do |format|
      format.html { redirect_to servers_url }
      format.json { head :no_content }
    end
  end

  protected

  def extract_category_names_param
    category_names = params[:server].delete(:categories)
    category_names.reject! { |name| name.blank? }

    return category_names
  end
end
