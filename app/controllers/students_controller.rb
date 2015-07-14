class StudentsController < ApplicationController
  before_action :set_user
  before_action :set_group
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new
    if (params.has_key?(:file))
      begin
        success = true
        Student.import(params[:file], @group)
      rescue
        success = false
      end
    else
      @student = @group.students.new(student_params)
      success = @student.save
      unless success
        @student.destroy
        @group.reload
      end
    end

    respond_to do |format|
      if success
        format.html { redirect_to new_user_group_student_path(@user, @group), notice: 'Schüler/-in erfolgreich angelegt.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end


    def set_user
      @user = User.find(params[:user_id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name, :firstname)
    end
end
