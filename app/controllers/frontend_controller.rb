# -*- encoding : utf-8 -*-
class FrontendController < ApplicationController
  #Festlegen des Allgemeinen Layout: siehe view/layouts/*
  layout 'bare'

  skip_before_filter :check_login, :check_accept

  before_filter :check_student, except: [:welcome, :login]

  def welcome
  end

  def login
    s = Student.find_by_login(params[:login])
    if s != nil
=begin
      if s.password_digest == params[:password]
          session[:student_id] = s.id
      redirect_to '/frontend'
      else
        redirect_to '/student', notice: "Benutzername oder Password falsch!"
      end
=end
      session[:student_id] = s.id
      redirect_to '/frontend'
    else
      redirect_to '/student', notice: "Benutzername oder Password falsch!"
    end
  end

  def index
    @measurements = @student.get_open_measurements
  end

  def start
    @measurement = Measurement.find(params[:id])
    @test = @measurement.assessment.test
    @result = @student.getCurrentResult(@measurement.id)
    if (@test.student_access) #...ggf mehr Tests
      render "results/tests/#{@test.view_info}_student"
    else
      redirect_to '/student'
    end
  end

  private

  def check_student
    if session[:student_id].nil?
      redirect_to '/student', notice: "Bitte einloggen!"
    else
      @student = Student.find(session[:student_id])
    end
  end
end
