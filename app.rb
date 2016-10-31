require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'

get '/' do
	erb "Hello! Welcom!"
end

get '/about' do
	@error = 'something wrong!'
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hh = {:username => 'Ведите имя', :phone => 'Ведите телефон',
		:datetime => 'Ведите дату и время'}

	@error = hh.select {|key,_| params[key] == ''}.values.join(", ")

	if @error !=''
		return erb :visit
	end

	erb "Ok! username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"
end

post '/contacts' do

	@name = params[:name]
	@email = params[:email]
	@message_contacts = params[:message_contacts]

	hh1 = {:name => 'Ведите имя', :email => 'Ведите email адрес', :message_contacts => 'Введите сообщение'}

	@error = hh1.select {|key,_| params[key] == ''}.values.join(", ")

	if @error !=''
		return erb :contacts
	end

	#Pony.mail(:to => 'rid7003482@gmail.com', :from => 'mishok_02@mail.ru', :subject => 'hi', :body => 'Hello there.')

end