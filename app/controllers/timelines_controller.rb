class TimelinesController < ApplicationController
  # GET /timelines
  # GET /timelines.json
  def index
    @timelines = Timeline.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @timelines }
    end
  end

  # GET /timelines/1
  # GET /timelines/1.json
  def show
    @timeline = Timeline.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @timeline }
    end
  end

  # GET /timelines/new
  # GET /timelines/new.json
  def new
    @timeline = Timeline.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @timeline }
    end
  end

  # GET /timelines/1/edit
  def edit
    @timeline = Timeline.find(params[:id])
  end

  # POST /timelines
  # POST /timelines.json
  def create
    uploaded_data = params[:timeline][:json_file]
    file_path = Rails.root.join('public', 'uploads', uploaded_data.original_filename)
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_data.read)
    end

    @timeline = Timeline.new(
        :device_name => params[:timeline][:device_name],
        :test_name => params[:timeline][:test_name],
        :json_digest => view_context.parse(file_path))

    respond_to do |format|
      if @timeline.save
        format.html { redirect_to @timeline, notice: 'Timeline was successfully created.' }
        format.json { render json: @timeline, status: :created, location: @timeline }
      else
        format.html { render action: "new" }
        format.json { render json: @timeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /timelines/1
  # PUT /timelines/1.json
  def update
    @timeline = Timeline.find(params[:id])

    respond_to do |format|
      if @timeline.update_attributes(params[:timeline])
        format.html { redirect_to @timeline, notice: 'Timeline was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @timeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timelines/1
  # DELETE /timelines/1.json
  def destroy
    @timeline = Timeline.find(params[:id])
    @timeline.destroy

    respond_to do |format|
      format.html { redirect_to timelines_url }
      format.json { head :no_content }
    end
  end

  # GET /timelines/devices
  def index_devices
    @devices  = Timeline.select(:device_name).uniq.order('device_name ASC')
  end

  # GET /timelines/devices/<device_name>
  def show_device
    @device_data = Timeline.where(:device_name => params['device_name']).order('test_name DESC')
  end

  # GET /timelines/tests
  def index_tests
    @tests = Timeline.select(:test_name).uniq.order('test_name ASC')
  end


  # GET /timelines/tests/<test_name>
  def show_test
    @test_data = Timeline.where(:test_name => params['test_name']).order('chart_order DESC')
  end


end
