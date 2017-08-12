require 'nokogiri'
require 'mechanize'
require 'dotenv'
Dotenv.load

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari 4'

base_url = "https://ssl.jobcan.jp/login/client/?client_login_id=#{ENV['CLIENT_ID']}"
in_url = 'https://ssl.jobcan.jp/client/shift-schedule/?start_week=sunday&-1=start_week2&name=&group_id=41&group_where_type=main&witr_child_groups=1&work_kind%5B%5D=0&work_kind%5B%5D=-1&work_kind%5B%5D=-1&work_kind%5B%5D=-1&work_kind%5B%5D=-1&work_kind%5B%5D=-1&work_kind%5B%5D=-1&work_kind%5B%5D=-1&tags=&sort_order=no&number_par_page=50&shift_group_id=41&display_type=all&search_type=montr&from%5By%5D=2017&from%5Bm%5D=8&to=&shift_only_show='
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
      txt = day.text.gsub(" ", "").gsub("\n", "")
      raise if data[0][0] == txt
      tmp.push(txt)
    end
    data[i] = tmp
  end
rescue
end
p data





File.open("sample.txt", "w") do |f|
  f.puts(data)
end
