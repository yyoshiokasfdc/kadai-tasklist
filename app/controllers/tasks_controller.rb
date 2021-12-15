class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :destroy]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    if logged_in?
      @tasks = Task.all
      @task = current_user.tasks.build
      @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
    end
  end
  
  def show
    set_task
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
      
    if @task.save
      flash[:success] = 'タスクが作成されました'
      redirect_to root_url
    else
      @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
      flash[:danger] = 'タスクが作成できません'
      render 'tasks/index'
    end
  end
  
  def edit
  end
  
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = 'タスクが編集されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが編集されませんでした'
      render :edit
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:success] = 'タスクが削除されました'
    redirect_to root_url
    #redirect_back(fallback_location: root_path)
  end

  private 
  
  def set_task
    @task = Task.find(params[:id])
  end
    
  def task_params
    params.require(:task).permit(:content, :status, :user)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end