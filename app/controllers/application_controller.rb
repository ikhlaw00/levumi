# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_login, except: [:welcome, :login]
  before_action :check_accept, except: [:welcome, :login, :accept, :static, :logout]

  def login
    u = User.find_by_email(params[:email])
    if u != nil
      if u.authenticate(params[:password])
        session[:user_id] = u.id
        session[:student_id] = nil
        @login_student = nil
        @login_user = u
        news = News.new_items(u)
        u.last_login = Time.now
        u.save
        redirect_to user_groups_path(u), notice: news.empty? ? "Eingeloggt als #{u.email}" : news.join("<br/><br/>")
      else
        redirect_to root_url, notice: 'Benutzername oder Passwort falsch!'
      end
    else
      redirect_to root_url, notice: 'Benutzername oder Passwort falsch!'
    end
  end

  def logout
    if(!session[:user_id].nil?)
      session[:user_id] = nil
      @login_user = nil
    end
    redirect_to root_url
  end

  def welcome
    if params.has_key?(:page)
      render params[:page], :layout => 'bare'
    else
      render 'welcome', :layout => 'bare'
    end
  end

  def signup
    password = Digest::SHA1.hexdigest(rand(36**8).to_s(36))[1..6]
    @user = User.new(email: params[:email], name: params[:name], account_type: params[:account_type], password: password, password_confirmation: password)
    if (@user.account_type == 0 || @user.account_type == 1) && @user.save  #To prevent possible attacks by entering invalid account types in the post request
      UserMailer.registered(@user.email, @user.name, password).deliver_later
      render 'registered', layout: 'bare'
    else
      error = ''
      unless @user.errors['name'].blank?
        error = "Name darf nicht leer sein!"
      end
      unless @user.errors['email'].blank?
        error = 'E-Mail Adresse ungültig oder bereits registriert!'
      end
      flash['notice'] = error
      render 'signup', layout: 'bare'
    end
  end

  def accept
    @login_user.tcaccept = DateTime.now
    @login_user.save
    redirect_to user_groups_path(@login_user), notice: 'Viel Spaß bei der Benutzung von Levumi!'
  end

  def static
    render params[:page]
  end

  def export
    unless !@login_user.nil? && @login_user.hasCapability?('export')
      redirect_to root_url
    end
    @tests = Test.all
    @users = User.all
  end

  private
  #check if user is logged in
  def check_login
    if session[:user_id].nil? && session[:student_id].nil?
      redirect_to root_url, notice: 'Bitte einloggen!'
    elsif !session[:student_id].nil?
      @login_student = Student.find(session[:student_id])
     else
      @login_user = User.find(session[:user_id])
    end
  end

  #check if user accepted the letter of agreement
  def check_accept
    if !@login_user.nil? && @login_user.tcaccept.nil?
      render 'accept'
    end
  end

end
