require 'sinatra'
require 'thin'
require 'mechanize'

get '/' do
	redirect '/rs'
end

get '/rs' do
	rsCalc()
end

get '/wot' do
	wotCalc()
end

def rsCalc()
	agent = Mechanize.new

	page = agent.get "http://services.runescape.com/m=hiscore_oldschool/overall.ws"
	search_form = page.form_with :action => "hiscorepersonal.ws"
	search_form.field_with(:name => "user1").value = "Droptine"

	search_results = agent.submit search_form
	newTable = search_results.search('div.hiscoresHiddenBG')

	names = Array.new
	levels = Array.new
	exps = Array.new

	for i in 3..26
		stat = newTable.search('tr')[i]
		skillName = stat.search('a').text
		level = stat.search('td')[3].text
		exp = stat.search('td')[4].text

		names.push skillName
		levels.push level
		exps.push exp
	end

	erb :rs, :locals => {:skillNames => names, :skillLevels => levels, :skillExps => exps}
end

def wotCalc()
	agent = Mechanize.new

	page = agent.get "http://worldoftanks.com/community/accounts/1001630827-c_dizzle/"

	names = Array.new
	values = Array.new

	names.push 'Personal Rating'
	names.push 'Win/Loss'
	names.push 'Battles Fought'
	names.push 'Experience Per Battle'
	names.push 'Damage Per Battle'
	names.push 'Kill/Death'
	names.push 'Damage Caused/Received'
	names.push 'Achievements'

	values.push page.search('p.t-personal-data_value__pr')[0].text

	for i in 0..3
		val = page.search('td.t-personal-data_value')[i].text.strip
		values.push val
	end

	values.push page.search('p.b-speedometer-weight')[0].text
	values.push page.search('p.b-speedometer-weight')[1].text
	values.push page.search('h3.js-achievements-header')[0].text.slice(13,100)

	erb :wot, :locals => {:names => names, :values => values}
end