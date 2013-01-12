class HomeController < ApplicationController
  def index
  end

  def login
    if session[:token].nil?
      redirect_to get_request_token_uri(), :status => 303
    else
      redirect_to :secure_home
    end
  end

  def logout
    reset_session
    redirect_to :root
  end

  def oauth
    if session[:token].nil?
      session[:token] = get_access_token(params['code'])
    end

    redirect_to :secure_home
  end

  def secure
    if session[:token].nil?
      redirect_to :root
    end

    json = SlcResource.fetch_students(session[:token])

    @token = session[:token]

    build_json_display(json)
  end

  def browse
    if session[:token].nil?
      redirect_to :root
    end

    params[:path] ||= '/home'

    json = SlcResource.fetch_resource(params[:path], session[:token])

    @token = session[:token]

    build_json_display(json)
  end

  def some_students
    params[:path] = SlcResource.STUDENTS_URI
    browse
  end

  private

  def build_json_display(json)
    if !json.is_a? Array
      json = [json]
    end

    @display_objects = []

    json.each do |item|
      saved_links = item['links']
      item['links'] = nil
      display_object = {json:JSON.pretty_generate(item), links: saved_links}
      @display_objects << display_object

      saved_links.each do |l|
        puts l['href']
      end
    end

    @json = json
  end

end