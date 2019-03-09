#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
   @db =  SQLite3::Database.new 'test.sqlite3'
   @db.results_as_hash = true
  return @db
end

def save_form_data_to_database
  init_db
  @db.execute 'INSERT INTO post (title, content, datetime)
  VALUES (?, ?, datetime())', [@title, @content]
  @db.close
end

before do
  init_db
  
end

configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS
	"post"
	  (
		"id"	INTEGER PRIMARY KEY AUTOINCREMENT,
		"title"		TEXT,
		"content"	TEXT,
		"datetime"	DATE
	  )'
	  
end

get '/' do
	init_db

    @results = @db.execute 'SELECT * FROM post ORDER BY id DESC'
    @db.close
	erb :index			
end

get '/new' do
	erb :new
end	

post '/new' do
	@title = params[:title]
	@content = params[:content]


	# Проверка введен ли текст в поля заголовок и тело статьи
	# хеш вывода текста в случае ошибки
	hh = { 
		   :title => "Введите заголовок",
		   :content => "Введите текст"
		    
	}

	@error = hh.select {|key,_| params[key] == ""}.values.join(",  ")
	
	if @error != ""
		return erb :new
	end
	# сохранение в базу данных

    save_form_data_to_database
	
	# перенапровление на главную страницу	
	redirect "/"

end	

get '/details/:post_id' do
	post_id = params[:post_id]
	results = @db.execute 'SELECT * FROM post where id = ?', [post_id]
	@row = results[0]
	erb :details
end	