require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers

	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'

		db.execute 'CREATE TABLE IF NOT EXISTS
			"Barbers"
			(
				"id" INTEGER PRIMARY KEY AUTOINCREMENT,
				"name" TEXT
			)'

		seed_db db, ['Jessie', 'Walter', 'Gus', 'Mike']
end

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

	db = get_db
	db.execute 'insert into
			Users
			(
				username,
				phone,
				datestamp,
				barber,
				color )
				values (?,?,?,?,?)', [@username, @phone, @datetime, @barber, @color]

	erb "Ok! username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"

end

get '/showusers' do
	db = get_db

	@results = db.execute 'select *from Users order by id desc'
	erb :showusers
end























post '/contacts' do

	@name = params[:name]
	@email = params[:email]
	@message_contacts = params[:message_contacts]

	hash = {:name => 'Ведите имя', :email => 'Ведите email адрес', :message_contacts => 'Введите сообщение'}

	@error = hash.select {|key,_| params[key] == ''}.values.join(", ")

	if @error !=''
		return erb :contacts
	end

	#Pony.mail(:to => 'rid7003482@gmail.com', :from => 'mishok_02@mail.ru', :subject => 'hi', :body => 'Hello there.')

end
