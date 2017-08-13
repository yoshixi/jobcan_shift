require 'nokogiri'
require 'mechanize'
require 'dotenv'
Dotenv.load

months = {"1": "January", "2": "February", "3": "March", "4": "April", "5": "May", "6": "June", "7": "July", "8": "August", "9": "September", "10": "October", "11": "November", "12": "December"}
member = {"user1" => "@user1","user2" => "@user2", "user3" => "@user3", "user4" => "@user4"}

puts "何月のシフト？"
month = gets.chomp.to_sym

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari 4'


base_url = "https://ssl.jobcan.jp/login/client/?client_login_id=#{ENV['CLIENT_ID']}"
in_url = "https://ssl.jobcan.jp/client/shift-schedule/?start_week=sunday&group_id=41&group_where_type=main&with_child_groups=1&work_kind%5B%5D=0&work_kind%5B%5D=-1&work_kind%5B%5D=-1&work_kind%5B%5D=-1&work_kind%5B%5D=-1&work_kind%5B%5D=-1&work_kind%5B%5D=-1&shift_group_id=41&display_type=all&search_type=month&from%5By%5D=2017&from%5Bm%5D=#{month}"
agent.get(base_url) do |page|
   mypage =  page.form_with(action: '/login/client') do |form|
    # ログインに必要な入力項目を設定していく
    # formオブジェクトが持っている変数名は入力項目(inputタグ)のname属性
    formdata = {
            login_id: ENV['LOGIN_ID'],
            password: ENV['PASS']
            }
    form.field_with(id: 'client_manager_login_id').value = formdata[:login_id]
    form.field_with(id: 'client_login_password').value = formdata[:password]
  end.submit

#  doc = Nokogiri::HTML(mypage.content.toutf8)
#  h1_text = doc.xpatr('//h1').text
end

 html = agent.get(in_url).content

data = Array.new(1){[]}
doc =  Nokogiri::HTML(html)
tr_list = doc.css('#month tr')

begin
  tr_list.each_with_index do |tr, i|
    tmp = []
    day_list = tr.css("th, td")
    day_list.each do |day|
      txt = day.text.gsub(" ", "").gsub("\n", "").gsub("御茶ノ水", "")
      raise if data[0][0] == txt
      tmp.push(txt)
    end
    data[i] = tmp
  end
rescue
end

num = data.count - 1

data[0].each_with_index do |day, i|
  if i.zero?
    txt = ""
    for j in 2..num  do
     txt += "#{member[data[j][0]]} #{data[j][i]}    "
    end
  else
    day = day.to_i
    txt = "/remind #チャンネル名 #{months[month]} #{day-1} at 5pm #{day} 日のシフトお願いします！ "
    for j in 2..num  do
     txt += "#{member[data[j][0]]} #{data[j][i]}    " if data[j][i] != "-"
    end
  end

 puts txt
end



