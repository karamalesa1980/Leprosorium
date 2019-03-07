#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new' do
	erb :new
end	

post '/new' do
	@textarea = params[:textarea]

	f = File.open './public/text.txt', 'a'
	f.write "Post: #{@textarea}\n"
	f.close
	erb :new


end	