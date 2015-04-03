require 'sinatra'
require 'thin'
require 'mechanize'

get '/' do

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

	erb :index, :locals => {:skillNames => names, :skillLevels => levels, :skillExps => exps}
end