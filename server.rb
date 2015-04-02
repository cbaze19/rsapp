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

	for i in 3..26
		stat = newTable.search('tr')[i]
		skillName = stat.search('a').text
		level = stat.search('td')[3].text
		skillName.slice! "\n"
		skillName.slice! "\n"
		level.slice! "\n"

		names.push skillName
		levels.push level
	end

	erb :index, :locals => {:skillNames => names, :skillLevels => levels}
end