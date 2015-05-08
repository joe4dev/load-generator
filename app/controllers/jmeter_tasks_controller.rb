class JmeterTasksController < ApplicationController
  before_action :set_jmeter_task, only: [:show, :edit, :update, :destroy]
  API_METHODS = [:create]
  protect_from_forgery except: API_METHODS

  # GET /jmeter_tasks
  # GET /jmeter_tasks.json
  def index
    @jmeter_tasks = JmeterTask.all
  end

  # GET /jmeter_tasks/1
  # GET /jmeter_tasks/1.json
  def show
  end

  # GET /jmeter_tasks/new
  def new
    @jmeter_task = JmeterTask.new
  end

  # GET /jmeter_tasks/1/edit
  def edit
  end

  # POST /jmeter_tasks
  # POST /jmeter_tasks.json
  def create
    @jmeter_task = JmeterTask.create_from_files!(jmeter_task_params)

    respond_to do |format|
      # format.html { redirect_to @jmeter_task, notice: 'Jmeter task was successfully created.' }
      format.json { render :show, status: :created, location: @jmeter_task }
    end
  rescue => e
    respond_to do |format|
      # format.html { render :new }
      format.json { render json: e.message, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /jmeter_tasks/1
  # PATCH/PUT /jmeter_tasks/1.json
  def update
    respond_to do |format|
      if @jmeter_task.update(jmeter_task_params)
        format.html { redirect_to @jmeter_task, notice: 'Jmeter task was successfully updated.' }
        format.json { render :show, status: :ok, location: @jmeter_task }
      else
        format.html { render :edit }
        format.json { render json: @jmeter_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jmeter_tasks/1
  # DELETE /jmeter_tasks/1.json
  def destroy
    @jmeter_task.destroy
    respond_to do |format|
      format.html { redirect_to jmeter_tasks_url, notice: 'Jmeter task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jmeter_task
      @jmeter_task = JmeterTask.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jmeter_task_params
      params.require(:jmeter_task).permit(:test_plan_file, :benchmark_file, :node_file, :status, :file)
    end
end
