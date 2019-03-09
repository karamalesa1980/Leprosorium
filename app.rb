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
  @db.execute 'INSERT INTO post (title, content)
  VALUES (?, ?)', [@title, @content]
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
		"content"	TEXT
		
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

	hh = { 
		   :title => "Введите заголовок",
		   :content => "Введите текст"
		    
	}

	@error = hh.select {|key,_| params[key] == ""}.values.join(",  ")
	
		
	
    
	
	
	if @error != ""
		return erb :new
	end


    save_form_data_to_database
	erb "<h4>Ваша статья отправлена!</h4>"
		


end	