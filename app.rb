#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
   @db =  SQLite3::Database.new 'test.sqlite3'
   @db.results_as_hash = true
  return @db
end

def save_form_data_to_database
  @db = get_db
  @db.execute 'INSERT INTO post (content)
  VALUES (?)', [@content]
  @db.close
end

before do
  @db = get_db
  
end

configure do
	@db = get_db
	@db.execute 'CREATE TABLE IF NOT EXISTS
	"post"
	  (
		"id"	INTEGER PRIMARY KEY AUTOINCREMENT,
		"content"	TEXT
		
	  )'
	  
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new' do
	erb :new
end	

post '/new' do
	@content = params[:content]


    save_form_data_to_database
	erb "<h4>Ваша статья отправлена!</h4>"
		


end	