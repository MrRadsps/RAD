bot = dofile('./utils.lua')
json = dofile('./JSON.lua')
URL = require "socket.url"
serpent = require("serpent")
http = require "socket.http"
https = require "ssl.https"
redis = require('redis')
tdcli = dofile("tdcli.lua")
database = redis.connect('127.0.0.1', 6379)
BASE = '/home/api/Api/'

local NumberReturn = 12
local color = {
  black = {30, 40},
  red = {31, 41},
  green = {32, 42},
  yellow = {33, 43},
  blue = {34, 44},
  magenta = {35, 45},
  cyan = {36, 46},
  white = {37, 47}
}
----------------------------------------------------------------------------
realm_id = -1001311064293 --Realm ID
----------------------------------------------------------------------------
SUDO = 495059735 --Sudo ID
----------------------------------------------------------------------------
sudo_users = {495059735,166674282} --Sudo ID
----------------------------------------------------------------------------
BOTS = 587847161 --Bot ID
----------------------------------------------------------------------------
bot_id = 587847161 --Bot ID
----------------------------------------------------------------------------
botname = 'Rad Free Bot'
----------------------------------------------------------------------------
sudoid = '@MinuteMen'
----------------------------------------------------------------------------
botuser = '@RadFreeBot'
----------------------------------------------------------------------------
botchannel = '@Source_Search'
----------------------------------------------------------------------------
sudophone = '+9809036091185'
----------------------------------------------------------------------------
pvresan = '@ActionSup_Bot'
----------------------------------------------------------------------------
supportgp = 'https://t.me/joinchat/HYIDF0WNf6SwrepJA7j4Rg'
----------------------------------------------------------------------------
function vardump(value)
print(serpent.block(value, {comment=false}))
end
----------------------------------------------------------------------------
function dl_cb(arg, data)
end
----------------------------------------------------------------------------
function is_ultrasudo(msg)
local var = false
for k,v in pairs(sudo_users) do
if msg.sender_user_id_ == v then
var = true
end
end
return var
end
----------------------------------------------------------------------------
function is_sudo(msg)
local hash = database:sismember(SUDO..'sudo:',msg.sender_user_id_)
if hash or is_ultrasudo(msg)  then
return true
else
return false
end
end
----------------------------------------------------------------------------
function is_bot(msg)
if tonumber(BOTS) == 587847161 then
return true
else
return false
end
end
----------------------------------------------------------------------------
function check_user(msg)
local var = true
if database:get(SUDO.."forcejoin") then
local channel = 't.me/Source_Search'
local url , res = https.request('https://api.telegram.org/bot587847161:AAG6YgW6U0JcMrUh2Rnj_bmzpIfGwxZg5R0/getchatmember?chat_id='..channel..'&user_id='..msg.sender_user_id_)
data = json:decode(url)
if res ~= 200 or data.result.status == "left" or data.result.status == "kicked" then
var = false
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» برای استفاده از ربات ابتدا وارد کانال ( '..channel..' ) شوید.', 1, 'html')
elseif data.ok then
return var
end
else
return var
end
end
----------------------------------------------------------------------------
function is_owner(msg)
local hash = database:sismember(SUDO..'owners:'..msg.chat_id_,msg.sender_user_id_)
if hash or  is_ultrasudo(msg) or is_sudo(msg) then
return true
else
return false
end
end
----------------------------------------------------------------------------
function sleep(n)
os.execute("sleep " .. tonumber(n))
end
----------------------------------------------------------------------------
function is_mod(msg)
local hash = database:sismember(SUDO..'mods:'..msg.chat_id_,msg.sender_user_id_)
if hash or  is_ultrasudo(msg) or is_sudo(msg) or is_owner(msg) then
return true
else
return false
end
end
----------------------------------------------------------------------------
function is_vip(msg)
local hash = database:sismember(SUDO..'vips:'..msg.chat_id_,msg.sender_user_id_)
if hash or  is_ultrasudo(msg) or is_sudo(msg) or is_owner(msg) or is_mod(msg) then
return true
else
return false
end
end
----------------------------------------------------------------------------
function is_banned(chat,user)
local hash =  database:sismember(SUDO..'banned'..chat,user)
if hash then
return true
else
return false
end
end
----------------------------------------------------------------------------
function is_gban(chat,user)
local hash =  database:sismember(SUDO..'gbaned',user)
if hash then
return true
else
return false
end
end
----------------------------------------------------------------------------
function deleteMessagesFromUser(chat_id, user_id)
tdcli_function ({
ID = "DeleteMessagesFromUser",
chat_id_ = chat_id,
user_id_ = user_id
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function addChatMember(chat_id, user_id, forward_limit)
tdcli_function ({
ID = "AddChatMember",
chat_id_ = chat_id,
user_id_ = user_id,
forward_limit_ = forward_limit
}, dl_cb, nil)
end
----------------------------------------------------------------------------
local function UpTime()
local uptime = io.popen("uptime -p"):read("*all")
days = uptime:match("up %d+ days")
hours = uptime:match(", %d+ hour") or uptime:match(", %d+ hours")
minutes = uptime:match(", %d+ minutes") or uptime:match(", %d+ minute")
if hours then
hours = hours
else
hours = ""
end
if days then
days = days
else
days = ""
end
if minutes then
minutes = minutes
else
minutes = ""
end
days = days:gsub("up", "")
local a_ = string.match(days, "%d+")
local b_ = string.match(hours, "%d+")
local c_ = string.match(minutes, "%d+")
if a_ then
a = a_
else
a = 0
end
if b_ then
b = b_
else
b = 0
end
if c_ then
c = c_
else
c = 0
end
return a..' days '..b..' hour '..c..' minute'
end
----------------------------------------------------------------------------
function is_filter(msg, value)
local hash = database:smembers(SUDO..'filters:'..msg.chat_id_)
if hash then
local names = database:smembers(SUDO..'filters:'..msg.chat_id_)
local text = ''
for i=1, #names do
if string.match(value:lower(), names[i]:lower()) and not is_mod(msg) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
delete_msg(chat,msgs)
end
end
end
end
----------------------------------------------------------------------------
function is_muted(chat,user)
local hash =  database:sismember(SUDO..'mutes'..chat,user)
if hash then
return true
else
return false
end
end
----------------------------------------------------------------------------
function pin(channel_id, message_id, disable_notification)
tdcli_function ({
ID = "PinChannelMessage",
channel_id_ = getChatId(channel_id).ID,
message_id_ = message_id,
disable_notification_ = disable_notification
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function unpin(channel_id)
tdcli_function ({
ID = "UnpinChannelMessage",
channel_id_ = getChatId(channel_id).ID
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function pin(channel_id, message_id, disable_notification)
tdcli_function ({
ID = "PinChannelMessage",
channel_id_ = getChatId(channel_id).ID,
message_id_ = message_id,
disable_notification_ = disable_notification
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function SendMetion(chat_id, user_id, msg_id, text, offset, length)
local tt = database:get('endmsg') or ''
tdcli_function ({
ID = "SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = msg_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID = "InputMessageText",
text_ = text..'\n\n'..tt,
disable_web_page_preview_ = 1,
clear_draft_ = 0,
entities_ = {[0]={
ID="MessageEntityMentionName",
offset_=offset,
length_=length,
user_id_=user_id
},
},
},
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function resolve_username(username,cb)
  tdcli_function ({
ID = "SearchPublicChat",
username_ = username
  }, cb, nil)
end
---------------------------------------------------------------------------
function del_all_msgs(chat_id, user_id)
  tdcli_function ({
ID = "DeleteMessagesFromUser",
chat_id_ = chat_id,
user_id_ = user_id
  }, dl_cb, nil)
end
----------------------------------------------------------------------------
function priv(chat,user)
local khash = database:sismember(SUDO..'sudo:',user)
local vhash = database:sismember(SUDO..'vips:'..chat,user)
local ohash = database:sismember(SUDO..'owners:'..chat,user)
local mhash = database:sismember(SUDO..'mods:'..chat,user)
if tonumber(SUDO) == tonumber(user) or khash or mhash or ohash or vhash then
return true
else
return false
end
end
----------------------------------------------------------------------------
function getInputFile(file)
local input = tostring(file)
if file:match('/') then
infile = {ID = "InputFileLocal", path_ = file}
elseif file:match('^%d+$') then
infile = {ID = "InputFileId", id_ = file}
else
infile = {ID = "InputFilePersistentId", persistent_id_ = file}
end
return infile
end
----------------------------------------------------------------------------
function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
tdcli_function ({
ID = "SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_to_message_id,
disable_notification_ = disable_notification,
from_background_ = from_background,
reply_markup_ = reply_markup,
input_message_content_ = {
ID = "InputMessagePhoto",
photo_ = getInputFile(photo),
added_sticker_file_ids_ = {},
width_ = 0,
height_ = 0,
caption_ = caption
},
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function getChatId(id)
local chat = {}
local id = tostring(id)
if id:match('^-100') then
local channel_id = id:gsub('-100', '')
chat = {ID = channel_id, type = 'channel'}
else
local group_id = id:gsub('-', '')
chat = {ID = group_id, type = 'group'}
end
return chat
end
----------------------------------------------------------------------------
function getChannelMembers(channel_id, offset, filter, limit)
if not limit or limit > 200 then
limit = 200
end
tdcli_function ({
ID = "GetChannelMembers",
channel_id_ = getChatId(channel_id).ID,
filter_ = {
ID = "ChannelMembers" .. filter
},
offset_ = offset,
limit_ = limit
}, dl_cb, nil)
end
----------------------------------------------------------------------------
function adduser(chat_id, user_id, forward_limit)
tdcli_function ({
ID = "AddChatMember",
chat_id_ = chat_id,
user_id_ = user_id,
forward_limit_ = forward_limit or 50
}, dl_cb, nil)
end
----------------------------------------------------------------------------

----------------------------------------------------------------------------
function sendContact(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, phone_number, first_name, last_name, user_id)
  tdcli_function ({
ID = "SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_to_message_id,
disable_notification_ = disable_notification,
from_background_ = from_background,
reply_markup_ = reply_markup,
input_message_content_ = {
ID = "InputMessageContact",
contact_ = {
  ID = "Contact",
  phone_number_ = phone_number,
  first_name_ = first_name,
  last_name_ = last_name,
  user_id_ = user_id
},
},
  }, dl_cb, nil)
end
-------------
----------------------------------------------------------------------------
function banall(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, 'تو بودی خودتو سوپر بن میکردی ؟ 😐', 1, 'md')
return false
end
if priv(chat,user) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ کاربر مورد نظر جزو ( مالکین | سازندگان ) ربات میباشد!', 1, 'md')
else
bot.changeChatMemberStatus(chat, user, "Kicked")
database:sadd(SUDO..'gbaned',user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Successfully Sicked !' , 9, string.len(user)) 
else
SendMetion(msg.chat_id_, user, msg.id_, '» کاربر ( '..user..' ) از تمامی گروه های ربات بن شد.' , 10, string.len(user))
end
end
end
--------------------------------------------------------------------------
local calc = function(exp)
  url = "http://api.mathjs.org/v1/"
  url = url .. "?expr=" .. URL.escape(exp)
  data, res = http.request(url)
  text = nil
  if res == 200 then
    text = data
  elseif res == 400 then
    text = data
  else
    text = "ERR"
  end
  return text
end

----------------------------------------------------------------------------------------------
function kick(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
return false
end
if priv(chat,user) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ کاربر مورد نظر جزو ( مالکین | سازندگان ) ربات میباشد!', 1, 'md')
else
bot.changeChatMemberStatus(chat, user, "Kicked")
end
end
----------------------------------------------------------------------------
function ban(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, 'تو بودی خودتو بن میکردی ؟ 😐', 1, 'md')
return false
end
if priv(chat,user) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ کاربر مورد نظر جزو ( مالکین | سازندگان ) ربات میباشد!', 1, 'md')
else
bot.changeChatMemberStatus(chat, user, "Kicked")
database:sadd(SUDO..'banned'..chat,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Successfully Baned !' , 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '» کاربر ( '..user..' ) از گروه بن شد.' , 10, string.len(user))
end
end
end
----------------------------------------------------------------------------
function mute(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, 'تو بودی خودتو سایلنت میکردی ؟ 😐', 1, 'md')
return false
end
if priv(chat,user) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ کاربر مورد نظر جزو ( مالکین | سازندگان ) ربات میباشد!', 1, 'md')
else
database:sadd(SUDO..'mutes'..chat,user)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*• You Can Not Remove The Ability To Chat In Groups From Other Managers !*', 1, 'md')
else
SendMetion(msg.chat_id_, user, msg.id_, '↫ کاربر ( '..user..' ) در حالت سایلنت قرار گرفت.' , 10, string.len(user))
end
end
end
--------------------------{inline}-------------------------------------------
function edit(message_id, text, keyboard)
	local urlk = url .. "/editMessageText?&inline_message_id=" .. message_id .. "&text=" .. URL.escape(text)
	urlk = urlk .. "&parse_mode=html"
	if keyboard then
		urlk = urlk .. "&reply_markup=" .. URL.escape(json.encode(keyboard))
	end
	return https.request(urlk)
end
function Canswer(callback_query_id, text, show_alert)
	local urlk = url .. "/answerCallbackQuery?callback_query_id=" .. callback_query_id .. "&text=" .. URL.escape(text)
	if show_alert then
		urlk = urlk .. "&show_alert=true"
	end
	https.request(urlk)
end
function answer(inline_query_id, query_id, title, description, text, keyboard)
	local results = {
		{}
	}
	results[1].id = query_id
	results[1].type = "article"
	results[1].description = description
	results[1].title = title
	results[1].message_text = text
	urlk = url .. "/answerInlineQuery?inline_query_id=" .. inline_query_id .. "&results=" .. URL.escape(json.encode(results)) .. "&parse_mode=Markdown&cache_time=" .. 1
	if keyboard then
    results[1].reply_markup = keyboard
    urlk = url .. "/answerInlineQuery?inline_query_id=" .. inline_query_id .. "&results=" .. URL.escape(json.encode(results)) .. "&parse_mode=Markdown&cache_time=" .. 1
  end
  https.request(urlk)
end
---------------------------------------------------------------------------
local having_access = function(user_id, chat, Q_id)
  local var = false
  if is_mod(user_id, chat) and is_ReqMenu(user_id, chat) then
    var = true
  end
  if not is_ReqMenu(user_id, chat) and is_mod(user_id, chat) then
    if database:get("lang:gp:" .. chat) then
      Canswer(Q_id, "[•• You Have Not Requested This Menu ••]")
    else
      Canswer(Q_id, "[•• شما این فهرست را درخواست نکرده اید ••]")
    end
  end
  if not is_mod(user_id, chat) then
    if database:get("lang:gp:" .. chat) then
      Canswer(Q_id, "[•• You Do Not Have Access To Make Changes ••]")
    else
      Canswer(Q_id, "[•• شما دسترسی به انجام تغییرات ندارید ••]")
    end
  end
  return var
end
----------------------------------------------------------------------------
function unbanall(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
return false
end
database:srem(SUDO..'gbaned',user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Successfully UnSicked !' , 9, string.len(user)) 
else
SendMetion(msg.chat_id_, user, msg.id_, '↫ کاربر ( '..user..' ) از تمامی گروه های ربات ان بن شد.' , 10, string.len(user))
end
end
----------------------------------------------------------------------------
function unban(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
return false
end
database:srem(SUDO..'banned'..chat,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Removed From The List Of Baned Users !' , 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '↫ کاربر ( '..user..' ) از گروه ان بن شد.' , 10, string.len(user))
end
end
----------------------------------------------------------------------------
function unmute(msg,chat,user)
if tonumber(user) == tonumber(bot_id) then
return false
end
database:srem(SUDO..'mutes'..chat,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Removed From The Silent List !' , 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '↫ کاربر ( '..user..' ) از حالت سایلنت خارج شد.' , 10, string.len(user))
end
end
----------------------------------------------------------------------------
function delete_msg(chatid,mid)
tdcli_function ({ID="DeleteMessages", chat_id_=chatid, message_ids_=mid}, dl_cb, nil)
end
----------------------------------------------------------------------------
function settings(msg,value,lock) 
local hash = SUDO..'settings:'..msg.chat_id_..':'..value
if value == 'file' then
text = 'فایل'
elseif value == 'inline' then
text = 'دکمه شیشه ای'
elseif value == 'link' then
text = 'لینک'
elseif value == 'game' then
text = 'بازی'
elseif value == 'username' then
text = 'یوزرنیم'
elseif value == 'tag' then
text = 'هشتگ'
elseif value == 'pin' then
text = 'سنجاق'
elseif value == 'photo' then
text = 'عکس'
elseif value == 'gif' then
text = 'گیف'
elseif value == 'video' then
text = 'فیلم'
elseif value == 'audio' then
text = 'صدا'
elseif value == 'music' then
text = 'موزیک'
elseif value == 'text' then
text = 'متن'
elseif value == 'sticker' then
text = 'استیکر'
elseif value == 'contact' then
text = 'مخاطب'
elseif value == 'forward' then
text = 'فوروارد'
elseif value == 'persian' then
text = 'فارسی'
elseif value == 'english' then
text = 'انگیلیسی'
elseif value == 'bot' then
text = 'ربات'
elseif value == 'tgservice' then
text = 'پیام سرویسی'
elseif value == 'fosh' then
text = 'فحش'
elseif value == 'selfivideo' then
text = 'فیلم سلفی'
elseif value == 'emoji' then
text = 'ایموجی'
elseif value == 'cmd' then
text = 'دستورات'
elseif value == 'join' then
text = 'ورودی گروه'
elseif value == 'reply' then
text = 'پاسخ'
else return false
end
if lock then
database:set(hash,true)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '✪ قفل  ( `'..text..'` ) ↫ با موفقیت فعال شد ! \n از این پس پیام های حاوی  ( `'..text..'` ) حذف خواهند شد ! \n ',1,'md')
else
database:del(hash)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '✪ قفل ( `'..text..'` ) ↫ با موفقیت غیر فعال شد ! \n از این پس پیام های حاوی ( `'..text..'` ) حذف نخواهند شد ! \n ',1,'md')
end
end
------------------------------------------------------------
function is_lock(msg,value)
local hash = SUDO..'settings:'..msg.chat_id_..':'..value
if database:get(hash) then
return true
else
return false
end
end
----------------------------------------------------------------------------
function warn(msg,chat,user)
local type = database:hget("warn:"..msg.chat_id_,"swarn")
if type == "kick" then
kick(msg,chat,user)
local text = '↫ کاربر ( '..user..' ) به دلیل اخطار بیش از حد اخراج شد'
SendMetion(msg.chat_id_, user, msg.id_, text, 8, string.len(user))
end
if type == "ban" then
local text = '↫ کاربر ( '..user..' ) به دلیل اخطار بیش از حد بن شد'
SendMetion(msg.chat_id_, user, msg.id_, text, 8, string.len(user))
changeChatMemberStatus(chat, user, "Kicked")
database:sadd(SUDO..'banned'..chat,user)
end
if type == "mute" then
local text = '↫ کاربر ( '..user..' ) به دلیل اخطار بیش از حد سایلنت شد'
SendMetion(msg.chat_id_, user, msg.id_, text, 8, string.len(user))
database:sadd(SUDO..'mutes'..msg.chat_id_,user)
end
end
----------------------------------------------------------------------------
function trigger_anti_spam(msg,type)
if type == 'kick' then
kick(msg,msg.chat_id_,msg.sender_user_id_)
end
if type == 'ban' then
if is_banned(msg.chat_id_,msg.sender_user_id_) then else
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, msg.sender_user_id_, msg.id_, 'The User [ '..msg.sender_user_id_..' ] Was Baned From The Group Because Of A Repeated (over-the-message) Message And Its Connection To The Group Was Disconnected.' , 11, string.len(msg.sender_user_id_))
else
SendMetion(msg.chat_id_, msg.sender_user_id_, msg.id_, '↫ کاربر ( '..msg.sender_user_id_..' ) به دلیل ارسال پیام مکرر از گروه بن شد.' , 10, string.len(msg.sender_user_id_))
end
end
bot.changeChatMemberStatus(msg.chat_id_, msg.sender_user_id_, "Kicked")
database:sadd(SUDO..'banned'..msg.chat_id_,msg.sender_user_id_)
end
if type == 'mute' then
if is_muted(msg.chat_id_,msg.sender_user_id_) then else
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, msg.sender_user_id_, msg.id_, 'User [ '..msg.sender_user_id_..' ]  Was Moved To SilentList Because Of Repeated (over-repeated) Message Sending.' , 7, string.len(msg.sender_user_id_))
else
SendMetion(msg.chat_id_, msg.sender_user_id_, msg.id_, '↫ کاربر ( '..msg.sender_user_id_..' ) به دلیل ارسال پیام مکرر سایلنت شد.' , 10, string.len(msg.sender_user_id_))
end
end
database:sadd(SUDO..'mutes'..msg.chat_id_,msg.sender_user_id_)
end
end
----------------------------------------------------------------------------
function televardump(msg,value)
local text = json:encode(value)
bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 'html')
end
----------------------------------------------------------------------------
function run(msg,data)
----------------------------------------------------------------------------
if msg.chat_id_ then
local id = tostring(msg.chat_id_)
if id:match('-100(%d+)') then
database:incr(SUDO..'sgpsmessage:')
if not database:sismember(SUDO.."botgps",msg.chat_id_) then
database:sadd(SUDO.."botgps",msg.chat_id_)
end
elseif id:match('^(%d+)') then
database:incr(SUDO..'pvmessage:')
if not database:sismember(SUDO.."usersbot",msg.chat_id_) then
database:sadd(SUDO.."usersbot",msg.chat_id_)
end
else
database:incr(SUDO..'gpsmessage:')
if not database:sismember(SUDO.."botgp",msg.chat_id_) then
database:sadd(SUDO.."botgp",msg.chat_id_)
end
end
end
if msg then
database:incr(SUDO..'groupmsgkk:'..msg.chat_id_..':')
database:incr(SUDO..'total:messages:'..msg.chat_id_..':'..msg.sender_user_id_)
if msg.send_state_.ID == "MessageIsSuccessfullySent" then
return false
end
end
----------------------------------------------------------------------------
if msg.chat_id_ then
local id = tostring(msg.chat_id_)
if id:match('-100(%d+)') then
chat_type = 'super'
elseif id:match('^(%d+)') then
chat_type = 'user'
else
chat_type = 'group'
end
end
----------------------------------------------------------------------------
local text = msg.content_.text_
local text1 = msg.content_.text_
if text and text:match('[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM]') then
text = text
end
----------------------------------------------------------------------------
if msg.content_.ID == "MessageText" then
msg_type = 'text'
end
if msg.content_.ID == "MessageChatAddMembers" then
msg_type = 'add'
end
if msg.content_.ID == "MessageChatJoinByLink" then
msg_type = 'join'
end
if msg.content_.ID == "MessagePhoto" then
msg_type = 'photo'
end
----------------------------------------------------------------------------
if msg_type == 'text' and text then
if text:match('^[/!]') then
text = text:gsub('^[/!]','')
end
end
----------------------------------------------------------------------------
if text then
if not database:get(SUDO..'bot_id') then
function cb(a,b,c)
database:set(SUDO..'bot_id',b.id_)
end
bot.getMe(cb)
end
end
-------------------------------------------------StartBot-------------------------------------------------
if text == 'start' and not database:get(SUDO.."timeactivee:"..msg.chat_id_) and chat_type == 'user' and check_user(msg) then
function pv_start(extra, result, success)
SendMetion(msg.chat_id_, result.id_, msg.id_, 'درود ( '..result.id_..' | '..result.first_name_..' ) \n\nبرای استفاده از این ربات کافی است این ربات را به گروه خود اضافه کنید .\n\nو سپس دستور زیر را در گروه وارد کنید :\n\n/active\n\nبا زدن این دستور ربات در گروه شما فعال میشود .\n\nلطفا برای حمایت از ما ربات رو به اشتراک بزارید.\n\n✑ '..botchannel..'' , 7, string.len(result.id_))
end
tdcli.getUser(msg.sender_user_id_, pv_start)
database:setex(SUDO.."timeactivee:"..msg.chat_id_, 73200, true)
end
----------------------------------------------------------------------------
if chat_type == 'super' then
local user_id = msg.sender_user_id_
floods = database:hget("flooding:settings:"..msg.chat_id_,"flood") or  'nil'
NUM_MSG_MAX = database:hget("flooding:settings:"..msg.chat_id_,"floodmax") or 5
TIME_CHECK = database:hget("flooding:settings:"..msg.chat_id_,"floodtime") or 5
if database:hget("flooding:settings:"..msg.chat_id_,"flood") then
if not is_mod(msg) then
if msg.content_.ID == "MessageChatAddMembers" then
return
else
local post_count = tonumber(database:get('floodc:'..msg.sender_user_id_..':'..msg.chat_id_) or 0)
if post_count > tonumber(database:hget("flooding:settings:"..msg.chat_id_,"floodmax") or 5) then
local ch = msg.chat_id_
local type = database:hget("flooding:settings:"..msg.chat_id_,"flood")
trigger_anti_spam(msg,type)
end
database:setex('floodc:'..msg.sender_user_id_..':'..msg.chat_id_, tonumber(database:hget("flooding:settings:"..msg.chat_id_,"floodtime") or 3), post_count+1)
end
end
local edit_id = data.text_ or 'nil'
NUM_MSG_MAX = 5
if database:hget("flooding:settings:"..msg.chat_id_,"floodmax") then
NUM_MSG_MAX = database:hget("flooding:settings:"..msg.chat_id_,"floodmax")
end
if database:hget("flooding:settings:"..msg.chat_id_,"floodtime") then
TIME_CHECK = database:hget("flooding:settings:"..msg.chat_id_,"floodtime")
end
end
----------------------------------------------------------------------------
-- save pin message id
if msg.content_.ID == 'MessagePinMessage' then
if is_lock(msg,'pin') and is_owner(msg) then
database:set(SUDO..'pinned'..msg.chat_id_, msg.content_.message_id_)
elseif not is_lock(msg,'pin') then
database:set(SUDO..'pinned'..msg.chat_id_, msg.content_.message_id_)
end
end
----------------------------------------------------------------------------
-- check filters
if text and not is_mod(msg) and not is_vip(msg) then
if is_filter(msg,text) then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- check settings
----------------------------------------------------------------------------
-- lock tgservice
if is_lock(msg,'tgservice') then
if msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" or msg.content_.ID == "MessageChatDeleteMember" then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock pin
if is_owner(msg) then else
if is_lock(msg,'pin') then
if msg.content_.ID == 'MessagePinMessage' then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Pin Lock Is Active*\n*You Do Not Have Any Authority You Can Not Pin A Message*',1, 'md')
bot.unpinChannelMessage(msg.chat_id_)
local PinnedMessage = database:get(SUDO..'pinned'..msg.chat_id_)
if PinnedMessage then
bot.pinChannelMessage(msg.chat_id_, tonumber(PinnedMessage), 0)
end
end
end
end
----------------------------------------------------------------------------
if database:get(SUDO..'automuteall'..msg.chat_id_)  then
if database:get(SUDO.."automutestart"..msg.chat_id_ ) then
if database:get(SUDO.."automuteend"..msg.chat_id_)  then
local time = os.date("%H%M")
local start = database:get(SUDO.."automutestart"..msg.chat_id_)
local endtime = database:get(SUDO.."automuteend"..msg.chat_id_)
if tonumber(endtime) < tonumber(start) then
if tonumber(time) <= 2359 and tonumber(time) >= tonumber(start) then
if not database:get(SUDO..'muteall'..msg.chat_id_) then
database:set(SUDO..'muteall'..msg.chat_id_,true)
end
elseif tonumber(time) >= 0000 and tonumber(time) < tonumber(endtime) then
if not database:get(SUDO..'muteall'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ با توجه به ساعت تنظیم شده قفل خودکار گروه قفل میشود.\n\n❊ از ارسال پیام خوداری کنید پیام شما حذف میشود.', 1, 'md')
database:set(SUDO..'muteall'..msg.chat_id_,true)
end
else
if database:get(SUDO..'muteall'..msg.chat_id_)then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ قفل خودکار گروه غیرفعال شد.\n\n❊ کاربران میتوانند مطالب خود را ارسال کنند.', 1, 'md')
database:del(SUDO..'muteall'..msg.chat_id_)
end
end
elseif tonumber(endtime) > tonumber(start) then
if tonumber(time) >= tonumber(start) and tonumber(time) < tonumber(endtime) then
if not database:get(SUDO..'muteall'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ با توجه به ساعت تنظیم شده قفل خودکار گروه قفل میشود.\n\n❊ از ارسال پیام خوداری کنید پیام شما حذف میشود.', 1, 'md')
database:set(SUDO..'muteall'..msg.chat_id_,true)
end
else
if database:get(SUDO..'muteall'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ قفل خودکار گروه غیرفعال شد.\n\n❊ کاربران میتوانند مطالب خود را ارسال کنند.', 1, 'md')
database:del(SUDO..'muteall'..msg.chat_id_)
end
end
end
end
end
end
----------------------------------------------------------------------------
if is_vip(msg) then
else
----------------------------------------------------------------------------
-- lock link
if is_lock(msg,'link') then
if text then
if msg.content_.entities_ and msg.content_.entities_[0] and msg.content_.entities_[0].ID == 'MessageEntityUrl' or msg.content_.text_.web_page_ then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
if msg.content_.caption_ then
local text = msg.content_.caption_
local is_link = text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or text:match("[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/") or text:match("[Tt].[Mm][Ee]/")
if is_link then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
----------------------------------------------------------------------------
-- lock username
if is_lock(msg,'username') then
if text then
local is_username = text:match("@[%a%d]")
if is_username then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
if msg.content_.caption_ then
local text = msg.content_.caption_
local is_username = text:match("@[%a%d]")
if is_username then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
----------------------------------------------------------------------------
-- lock hashtag
if is_lock(msg,'tag') then
if text then
local is_hashtag = text:match("#")
if is_hashtag then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
if msg.content_.caption_ then
local text = msg.content_.caption_
local is_hashtag = text:match("#")
if is_hashtag then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
----------------------------------------------------------------------------
-- lock rep
if is_lock(msg,'reply') then
if msg.reply_to_message_id_ ~= 0 then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock sticker
if is_lock(msg,'sticker') then
if msg.content_.ID == 'MessageSticker' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock join
if is_lock(msg,'join') then
if msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" then
bot.changeChatMemberStatus(msg.chat_id_, msg.sender_user_id_, "Kicked")
end
end
----------------------------------------------------------------------------
-- lock forward
if is_lock(msg,'forward') then
if msg.forward_info_ then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock photo
if is_lock(msg,'photo') then
if msg.content_.ID == 'MessagePhoto' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock file
if is_lock(msg,'file') then
if msg.content_.ID == 'MessageDocument' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock file
if is_lock(msg,'inline') then
if msg.reply_markup_ and msg.reply_markup_.ID == 'ReplyMarkupInlineKeyboard' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock game
if is_lock(msg,'game') then
if msg.content_.game_ then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock music
if is_lock(msg,'music') then
if msg.content_.ID == 'MessageAudio' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock voice
if is_lock(msg,'audio') then
if msg.content_.ID == 'MessageVoice' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock gif
if is_lock(msg,'gif') then
if msg.content_.ID == 'MessageAnimation' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock contact
if is_lock(msg,'contact') then
if msg.content_.ID == 'MessageContact' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock video
if is_lock(msg,'video') then
if msg.content_.ID == 'MessageVideo' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock text
if is_lock(msg,'text') then
if msg.content_.ID == 'MessageText' then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock persian
if is_lock(msg,'persian') then
if text and text:match('[\216-\219][\128-\191]') then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
if msg.content_.caption_ then
local text = msg.content_.caption_
local is_persian = text:match("[\216-\219][\128-\191]")
if is_persian then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
----------------------------------------------------------------------------
-- lock english
if is_lock(msg,'english') then
if text then
if text:match('[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM]') then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
if msg.content_.caption_ then
local text = msg.content_.caption_
local is_english = text:match("[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM]")
if is_english then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
end
----------------------------------------------------------------------------
-- lock fosh
if is_lock(msg,'fosh') then
if text then
if text:match("کیر") or text:match("کس") or text:match("تخم") or text:match("جینده") or  text:match("کص") or text:match("کونی") or text:match("جندع") or text:match("کیری") or text:match("کصده") or text:match("کون")  or text:match("جنده") or text:match("ننه") or text:match("ننت") or  text:match("کیرم") or text:match("تخمم") or text:match("تخم") or text:match("ننع") or text:match("مادر") or text:match("قهبه") or text:match("گاییدی") or text:match("گاییدم") or text:match("میگام") or text:match("میگامت") or text:match("سکس") or text:match("kir") or text:match("kos") or text:match("kon") or text:match("nne") or text:match("nnt")  then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end

----------------------------------------------------------------------------
-- lock Tabch
if is_lock(msg,'tabchi') then
if text then
if text:match("اددی") or text:match("اددی گلم") or text:match("بیا پیوی عشقم") or text:match("کصم") or  text:match("یه نفر بیاد پیوی") then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end

----------------------------------------------------------------------------
-- lock emoji
if is_lock(msg,'emoji') then
if text then
local is_emoji_msg = text:match("😀") or text:match("😬") or text:match("😁") or text:match("😂") or  text:match("😃") or text:match("😄") or text:match("😅") or text:match("☺️") or text:match("🙃") or text:match("🙂") or text:match("😊") or text:match("😉") or text:match("😇") or text:match("😆") or text:match("😋") or text:match("😌") or text:match("😍") or text:match("😘") or text:match("😗") or text:match("😙") or text:match("😚") or text:match("🤗") or text:match("😎") or text:match("🤓") or text:match("🤑") or text:match("😛") or text:match("😏") or text:match("😶") or text:match("😐") or text:match("😑") or text:match("😒") or text:match("🙄") or text:match("🤔") or text:match("😕") or text:match("😔") or text:match("😡") or text:match("😠") or text:match("😟") or text:match("😞") or text:match("😳") or text:match("🙁") or text:match("☹️") or text:match("😣") or text:match("😖") or text:match("😫") or text:match("😩") or text:match("😤") or text:match("😲") or text:match("😵") or text:match("😭") or text:match("😓") or text:match("😪") or text:match("😥") or text:match("😢") or text:match("🤐") or text:match("😷") or text:match("🤒") or text:match("🤕") or text:match("😴") or text:match("💋") or text:match("❤️")
if is_emoji_msg then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
----------------------------------------------------------------------------
-- lock selfvideo
if is_lock(msg,'selfivideo') then
if msg.content_.ID == "MessageUnsupported" then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
----------------------------------------------------------------------------
-- lock bot
if is_lock(msg,'bot') then
if msg.content_.ID == "MessageChatAddMembers" then
if msg.content_.members_[0].type_.ID == 'UserTypeBot' then
bot.changeChatMemberStatus(msg.chat_id_, msg.content_.members_[0].id_, 'Kicked')
end
end
end
----------------------------------------------------------------------------
-- check mutes
local muteall = database:get(SUDO..'muteall'..msg.chat_id_)
if msg.sender_user_id_ and muteall and not is_mod(msg) then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
if msg.sender_user_id_ and is_muted(msg.chat_id_,msg.sender_user_id_) then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
----------------------------------------------------------------------------
-- check bans
if msg.sender_user_id_ and is_banned(msg.chat_id_,msg.sender_user_id_) then
kick(msg,msg.chat_id_,msg.sender_user_id_)
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
if msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and is_banned(msg.chat_id_,msg.content_.members_[0].id_) then
kick(msg,msg.chat_id_,msg.content_.members_[0].id_)
delete_msg(msg.chat_id_, {[0] = msg.id_})
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ کاربر از گروه بن شده است.',1, 'md')
end
----------------------------------------------------------------------------
--check Gbans
if msg.sender_user_id_ and is_gban(msg.chat_id_,msg.sender_user_id_) then
kick(msg,msg.chat_id_,msg.sender_user_id_)
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
if msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and is_gban(msg.chat_id_,msg.content_.members_[0].id_) then
kick(msg,msg.chat_id_,msg.content_.members_[0].id_)
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
----------------------------------------------------------------------------
if is_lock(msg,'cmd') then
if not is_mod(msg) then
return  false
end
end
end
----------------------------------------------------------------------------
-- welcome
local status_welcome = (database:get(SUDO..'status:welcome:'..msg.chat_id_) or 'disable')
if status_welcome == 'enable' then
if msg.content_.ID == "MessageChatJoinByLink" then
if not is_banned(msg.chat_id_,msg.sender_user_id_) then
function wlc(extra,result,success)
if database:get(SUDO..'welcome:'..msg.chat_id_) then
t = database:get(SUDO..'welcome:'..msg.chat_id_)
else
t = 'Hi {name}\nWelcome To This Group !'
end
local t = t:gsub('{name}',result.first_name_)
bot.sendMessage(msg.chat_id_, msg.id_, 1, t,0)
end
bot.getUser(msg.sender_user_id_,wlc)
end
end
if msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].type_.ID == 'UserTypeGeneral' then
if msg.content_.ID == "MessageChatAddMembers" then
if not is_banned(msg.chat_id_,msg.content_.members_[0].id_) then
if database:get(SUDO..'welcome:'..msg.chat_id_) then
t = database:get(SUDO..'welcome:'..msg.chat_id_)
else
t = 'Hi {name}\nWelcome To This Group !'
end
local t = t:gsub('{name}',msg.content_.members_[0].first_name_)
bot.sendMessage(msg.chat_id_, msg.id_, 1, t,0)
end
end
end
end
----------------------------------------------------------------------------
-- locks
if text and is_owner(msg) then
local lock = text:match('^lock pin$')
local unlock = text:match('^unlock pin$')
if lock then
settings(msg,'pin','lock')
end
if unlock then
settings(msg,'pin')
end
end
if text and is_mod(msg) then
local lock = text:match('^lock (.*)$') or text:match('^قفل (.*)$')
local unlock = text:match('^unlock (.*)$') or text:match('^باز کردن (.*)$')
local pin = text:match('^lock pin$') or text:match('^unlock pin$')
if pin and is_mod(msg) then
elseif pin and not is_mod(msg) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ شما دسترسی استفاده از این دستور را ندارید.',1, 'md')
elseif lock then
settings(msg,lock,'lock')
elseif unlock then
settings(msg,unlock)
end
end
----------------------------------------------------------------------------
-- lock flood settings
if text and is_owner(msg) then
if text == 'lock flood kick' then
database:hset("flooding:settings:"..msg.chat_id_ ,"flood",'kick')
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Lock Message Activation Repeatedly!*\n*Status :* [ `Kick User` ]',1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ قفل رگبار به حالت اخراج تنظیم شد.',1, 'md')
end
elseif text == 'lock flood ban' then
database:hset("flooding:settings:"..msg.chat_id_ ,"flood",'ban')
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Lock Message Activation Repeatedly!*\n*Status :* [ `Ban User` ]',1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ قفل رگبار به حالت بن تنظیم شد.',1, 'md')
end
elseif text == 'lock flood mute' then
database:hset("flooding:settings:"..msg.chat_id_ ,"flood",'mute')
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Lock Message Activation Repeatedly!*\n*Status :* [ `Mute User` ]',1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ قفل رگبار به حالت سایلنت تنظیم شد.',1, 'md')
end
elseif text == 'unlock flood' then
database:hdel("flooding:settings:"..msg.chat_id_ ,"flood")
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Lock Message Sending Has Been Disabled Repeatedly!*',1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ قفل رگبار غیرفعال شد.',1, 'md')
end
end
end
----------------------------------------------------------------------------
database:incr(SUDO.."allmsg")
if msg.content_.game_ then
print("------ G A M E ------")
elseif msg.content_.text_ then
print("------ T E X T ------")
elseif msg.content_.sticker_ then
print("------ S T I C K E R ------")
elseif msg.content_.animation_ then
print("------ G I F ------")
elseif msg.content_.voice_ then
print("------ V O I C E ------")
elseif msg.content_.video_ then
print("------ V I D E O ------")
elseif msg.content_.photo_ then
print("------ P H O T O ------")
elseif msg.content_.document_ then
print("------ D O C U M E N T ------")
elseif msg.content_.audio_  then
print("------ A U D I O ------")
elseif msg.content_.location_ then
print("------ L O C A T I O N ------")
elseif msg.content_.contact_ then
print("------ C O N T A C T ------")
end
----------------------------------------------------------------------------
if not database:get(SUDO.."timeclears:") then
io.popen("rm -rf ~/.telegram-cli/data/sticker/*")
io.popen("rm -rf ~/.telegram-cli/data/photo/*")
io.popen("rm -rf ~/.telegram-cli/data/animation/*")
io.popen("rm -rf ~/.telegram-cli/data/video/*")
io.popen("rm -rf ~/.telegram-cli/data/audio/*")
io.popen("rm -rf ~/.telegram-cli/data/voice/*")
io.popen("rm -rf ~/.telegram-cli/data/temp/*")
io.popen("rm -rf ~/.telegram-cli/data/thumb/*")
io.popen("rm -rf ~/.telegram-cli/data/document/*")
io.popen("rm -rf ~/.telegram-cli/data/profile_photo/*")
io.popen("rm -rf ~/.telegram-cli/data/encrypted/*")
database:setex(SUDO.."timeclears:", 7200, true)
bot.sendMessage(realm_id, 0, 1, '↫ تمامی فایل های اضافی ذخیره شده در سرور پاکسازی شدند.', 1, 'md')
print("------ All Cache Has Been Cleared ------")
end
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Ultrasudo
if text then
----------------------------------------------------------------------------
if is_ultrasudo(msg) then
----------------------------------------------------------------------------
if text:match("^[Tt][Aa][Gg]$") then
local function GetCreator(extra, result, success)
rank = '#TAG\n\n'
for p , t in pairs(result.members_) do
local function Mehdi(y , vahid)
if vahid.username_ then
user_name = '@'..vahid.username_
else
user_name = t.user_id_
end
rank_ = rank..''..user_name..' , '
end
tdcli.getUser(t.user_id_, Mehdi)
end
bot.sendMessage(msg.chat_id_, msg.id_, 1, rank_, 1, 'md')
end
bot.getChannelMembers(msg.chat_id_, 0, 'Recent', 200, GetCreator)
end
----------------------------------------------------------------------------
if text and text:match("^[lL][uU][aA] (.*)") and is_ultrasudo(msg) then
local text = text:match("^[lL][uU][aA] (.*)")
local output = loadstring(text)()
if output == nil then
output = ""
elseif type(output) == "table" then
output = serpent.block(output, {comment = false})
else
utput = "" .. tostring(output)
end
bot.sendMessage(msg.chat_id_, msg.sender_user_id_, 1,output, 1, 'html')
end
----------------------------------------------------------------------------
if text == 'join on' then
if not database:get(SUDO.."forcejoin") then
database:set(SUDO.."forcejoin", true)
bot.sendMessage(msg.chat_id_, msg.id_, 1, "↫ حالت جوین اجباری روشن شد.", 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, "↫ حالت جوین اجباری روشن بود.", 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'join off' then
if database:get(SUDO.."forcejoin") then
database:del(SUDO.."forcejoin")
bot.sendMessage(msg.chat_id_, msg.id_, 1, "↫ حالت جوین اجباری خاموش شد.", 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, "↫ حالت جوین اجباری خاموش بود.", 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'bc' then
function Broad(extra, result)
local txt = result.content_.text_
local list = database:smembers(SUDO.."botgps") or 0
for k,v in pairs(list) do
tdcli.sendText(v, 0, 0, 1, nil, txt, 1, 'md')
end
local kos = database:smembers(SUDO.."botgp") or 0
for k,v in pairs(kos) do
tdcli.sendText(v, 0, 0, 1, nil, txt, 1, 'md')
end
local kr = database:smembers(SUDO.."usersbot") or 0
for k,v in pairs(kr) do
tdcli.sendText(v, 0, 0, 1, nil, txt, 1, 'md')
end
tdcli.sendText(msg.chat_id_, msg.id_, 0, 1, nil, 'Done', 1, 'md')
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),Broad)
end
end
----------------------------------------------------------------------------
if text:match("^fwd (.*)") and msg.reply_to_message_id_ ~= 0 then
local action = text:match("^fwd (.*)")
if action == "sgps" then
local gp = database:smembers(SUDO.."botgps") or 0
local gps = database:scard(SUDO.."botgps") or 0
for i=1, #gp do
tdcli.forwardMessages(gp[i], msg.chat_id_,{[0] = msg.reply_to_message_id_ }, 0)
end
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ پیام شما به '..gps..' سوپر گروه فوروارد شد.', 1, 'md')
elseif action == "gps" then
local gp = database:smembers(SUDO.."botgp") or 0
local gps = database:scard(SUDO.."botgp") or 0
for i=1, #gp do
tdcli.forwardMessages(gp[i], msg.chat_id_,{[0] = msg.reply_to_message_id_ }, 0)
end
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ پیام شما به '..gps..' گروه فوروارد شد.', 1, 'md')
elseif action == "pv" then
local gp = database:smembers(SUDO.."usersbot") or 0
local gps = database:scard(SUDO.."usersbot") or 0
for i=1, #gp do
tdcli.forwardMessages(gp[i], msg.chat_id_,{[0] = msg.reply_to_message_id_ }, 0)
end
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ پیام شما به '..gps..' کاربر فوروارد شد.', 1, 'md')
elseif action == "all" then
local gp = database:smembers(SUDO.."usersbot") or 0
local gpspv = database:scard(SUDO.."usersbot") or 0
for i=1, #gp do
tdcli.forwardMessages(gp[i], msg.chat_id_,{[0] = msg.reply_to_message_id_ }, 0)
end
local gp = database:smembers(SUDO.."botgps") or 0
local gpss = database:scard(SUDO.."botgps") or 0
for i=1, #gp do
tdcli.forwardMessages(gp[i], msg.chat_id_,{[0] = msg.reply_to_message_id_ }, 0)
end
local gp = database:smembers(SUDO.."botgp") or 0
local gps = database:scard(SUDO.."botgp") or 0
for i=1, #gp do
tdcli.forwardMessages(gp[i], msg.chat_id_,{[0] = msg.reply_to_message_id_ }, 0)
end
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ پیام شما به '..gpss..' سوپر گروه , '..gps..' گروه و '..gpspv..' کاربر فوروارد شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'backup' then
tdcli.sendDocument(SUDO, 0, 0, 1, nil, './bot.lua', dl_cb, nil)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ آخرین نسخه سورس برای شما ارسال شد.', 1, 'md')
end
----------------------------------------------------------------------------
if text == 'setsudo' then
function prom_reply(extra, result, success)
database:sadd(SUDO..'sudo:',result.sender_user_id_)
local user = result.sender_user_id_
local text = '↫ کاربر ( '..user..' ) به برو بکس سودو اضاف شد.'
SendMetion(msg.chat_id_, user, msg.id_, text, 10, string.len(user))
end
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text == 'remsudo' then
function prom_reply(extra, result, success)
database:srem(SUDO..'sudo:',result.sender_user_id_)
local text = '↫ کاربر ( '..result.sender_user_id_..' ) از برو بکس سودو حذف شد.'
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, text, 10, string.len(result.sender_user_id_))
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text == 'banall' then
if msg.reply_to_message_id_ == 0 then
local user = msg.sender_user_id_
else
function banreply(extra, result, success)
banall(msg,msg.chat_id_,result.sender_user_id_)
end
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),banreply)
end
----------------------------------------------------------------------------
if text:match('^banall (%d+)') then
banall(msg,msg.chat_id_,text:match('banall (%d+)'))
end
----------------------------------------------------------------------------
if text == 'unbanall' then
if msg.reply_to_message_id_ == 0 then
local user = msg.sender_user_id_
else
function unbanreply(extra, result, success)
unbanall(msg,msg.chat_id_,result.sender_user_id_)
end
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unbanreply)
end
----------------------------------------------------------------------------
if text:match('^unbanall (%d+)') then
unbanall(msg,msg.chat_id_,text:match('unbanall (%d+)'))
end
----------------------------------------------------------------------------
if text == 'reset stats' then
database:del(SUDO.."allmsg")
database:del(SUDO.."botgps")
database:del(SUDO.."botgp")
database:del(SUDO.."usersbot")
database:del(SUDO..'sgpsmessage:')
database:del(SUDO..'gpsmessage:')
database:del(SUDO..'pvmessage:')
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» آمار ربات بروز شد.', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^reset sgps$') and is_ultrasudo(msg) then
database:del(SUDO.."botgps")
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» آمار سوپر گروه های ربات بروز شد !', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^gps$') and is_ultrasudo(msg) then
database:del(SUDO.."botgp")
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» آمار گروه های ربات بروز شد !', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^reset pv$') and is_ultrasudo(msg) then
database:del(SUDO.."usersbot")
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» آمار پیوی ربات بروز شد !', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^reset allmsgs$') and is_ultrasudo(msg) then
database:del(SUDO.."allmsg")
database:del(SUDO..'sgpsmessage:')
database:del(SUDO..'gpsmessage:')
database:del(SUDO..'pvmessage:')
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» آمار همه پیام های دریافتی ربات بروز شد !', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^reset spgsmsgs$') and is_ultrasudo(msg) then
database:del(SUDO..'sgpsmessage:')
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» آمار پیام های دریافتی از سوپر گروه ها بروز شد !', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^reset gpsmsgs$') and is_ultrasudo(msg) then
database:del(SUDO..'gpsmessage:')
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» آمار پیام های دریافتی از گروه های ربات بروز شد !', 1, 'html')
end
----------------------------------------------------------------------------
if text:match('^reset pvmsgs$') and is_ultrasudo(msg) then
database:del(SUDO..'pvmessage:')
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» آمار پیام های دریافتی از پیوی بروز شد !', 1, 'html')
end
----------------------------------------------------------------------------
if text == 'serverinfo' or text == 'وضعیت سرور' then
local cpu = io.popen("lscpu"):read("*all")
local ram = io.popen("free -m"):read("*all")
local uptime = io.popen("uptime"):read("*all")
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ Robot sever info :\n\n⇜ ram info :\n `'..ram..'` \n\n\n⇜ cpu usage :\n `'..cpu..'` \n\n\n⇜ uptime :\n `'..uptime..'` \n⇜  ', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, 'وضعیت سرور  :\n\n⇜ مشخصات و فضای مصرفی رم : \n\n\n `'..ram..'` \n⇜ مشخصات و فضای مصرفی سی پی یو : \n\n\n `'..cpu..'` \n\n⇜ آپتایم و مدت زمان آنلاین بودن و تعداد یوزر های سرور :\n `'..uptime..'` \n', 1, 'md')
end
end
----------------------------------------------------------------------------
end -- end is_ultrasudo msg
----------------------------------------------------------------------------
if is_sudo(msg) then
----------------------------------------------------------------------------
if text:match('^setrank (.*)') then
local rank = text:match('setrank (.*)')
function setrank(extra, result, success)
database:set('ranks:'..result.sender_user_id_, rank)
local text = '↫ لقب کاربر ( '..result.sender_user_id_..' ) به ( '..rank..' ) تنظیم شد.'
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, text, 14, string.len(result.sender_user_id_))
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),setrank)
end
end
----------------------------------------------------------------------------
if text == 'leave' then
bot.changeChatMemberStatus(msg.chat_id_, bot_id, "Left")
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ ربات با موفقیت از گروه خارج شد.', 1, 'md')
end
----------------------------------------------------------------------------
if text == 'setowner' then
function prom_reply(extra, result, success)
database:sadd(SUDO..'owners:'..msg.chat_id_,result.sender_user_id_)
local user = result.sender_user_id_
local text = '↫ کاربر ( '..user..' ) به مالک ربات تنظیم شد.'
SendMetion(msg.chat_id_, user, msg.id_, text, 10, string.len(user))
end
if tonumber(tonumber(msg.reply_to_message_id_)) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text and text:match('^setowner (%d+)') then
local user = text:match('setowner (%d+)')
database:sadd(SUDO..'owners:'..msg.chat_id_,user)
local text = '↫ کاربر ( '..user..' ) به مالک ربات تنظیم شد.'
SendMetion(msg.chat_id_, user, msg.id_, text, 10, string.len(user))
end
----------------------------------------------------------------------------
if text == 'remowner' then
function prom_reply(extra, result, success)
database:srem(SUDO..'owners:'..msg.chat_id_,result.sender_user_id_)
local text = '↫ کاربر ( '..result.sender_user_id_..' )  از مالکیت ربات حذف شد.'
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, text, 10, string.len(result.sender_user_id_))
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text and text:match('^remowner (%d+)') then
local user = text:match('remowner (%d+)')
database:srem(SUDO..'owners:'..msg.chat_id_,user)
local text = '↫ کاربر ( '..user..' )  از مالکیت ربات حذف شد.'
SendMetion(msg.chat_id_, user, msg.id_, text, 10, string.len(user))
end
----------------------------------------------------------------------------
if text == 'clean ownerlist' then
database:del(SUDO..'owners:'..msg.chat_id_)
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ لیست مالکین گروه پاکسازی شد.', 1, 'md')
end
----------------------------------------------------------------------------
if text == 'reload' or text == 'بروز' then
dofile('bot.lua')
io.popen("rm -rf ~/.telegram-cli/data/animation/*")
io.popen("rm -rf ~/.telegram-cli/data/audio/*")
io.popen("rm -rf ~/.telegram-cli/data/document/*")
io.popen("rm -rf ~/.telegram-cli/data/photo/*")
io.popen("rm -rf ~/.telegram-cli/data/sticker/*")
io.popen("rm -rf ~/.telegram-cli/data/temp/*")
io.popen("rm -rf ~/.telegram-cli/data/thumb/*")
io.popen("rm -rf ~/.telegram-cli/data/video/*")
io.popen("rm -rf ~/.telegram-cli/data/voice/*")
io.popen("rm -rf ~/.telegram-cli/data/profile_photo/*")
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, 'Done :)', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, 'انجام شد :)', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'stats' or text == 'آمار' then
local users = database:scard(SUDO.."usersbot") or 0
local sgpsm = database:get(SUDO..'sgpsmessage:') or 0
local gpsm = database:get(SUDO..'gpsmessage:') or 0
local pvm = database:get(SUDO..'pvmessage:') or 0
local gp = database:scard(SUDO.."botgp") or 0
local gps = database:scard(SUDO.."botgps") or 0
local allmgs = database:get(SUDO.."allmsg") or 0
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ Robot stats :\n\n⇜ sgps : [ `'..gps..'` ]\n⇜ sgps msg : [ `'..sgpsm..'` ]\n\n⇜ gps : [ `'..gp..'` ]\n⇜ gps msg : [ `'..gpsm..'` ]\n\n⇜ users : [ `'..users..'` ]\n⇜ users msg : [ `'..pvm..'` ]\n\n⇜ all msg : [ `'..allmgs..'` ]\n\n ', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ آمار ربات  : :\n\n⇜ تعداد سوپر گروه ها : [ `'..gps..'` ]\n⇜ تعداد پیام های دریافتی در سوپر گروه ها : [ `'..sgpsm..'` ]\n\n⇜ تعداد گروه ها : [ `'..gp..'` ]\n⇜ تعداد پیام های دریافتی در گروه ها : [ `'..gpsm..'` ]\n\n⇜ تعداد کاربران ربات : [ `'..users..'` ]\n⇜ تعداد پیام های دریافتی از کاربران : [ `'..pvm..'` ]\n\n⇜ تعداد تمامی پیام های دریافتی ربات : [ `'..allmgs..'` ]\n\n', 1, 'md')
end
end
----------------------------------------------------------------------------
end -- end is_sudo msg
----------------------------------------------------------------------------
-- owner
if is_owner(msg) then
----------------------------------------------------------------------------
if text:match("^[Ss]etlang (.*)$") or text:match("^تنظیم زبان (.*)$") then
local langs = {string.match(text, "^(.*) (.*)$")}
if langs[2] == "fa" or langs[2] == "فارسی" then
if not database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '> زبان ربات هم اکنون بر روی فارسی قرار دارد !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '> زبان ربات به فارسی تغییر پیدا کرد ! ', 1, 'md')
database:del('lang:gp:'..msg.chat_id_)
end
end
if langs[2] == "en" or langs[2] == "انگلیسی" then
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '> Language Bot is *already* English', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '> Language Bot has been changed to *English* !', 1, 'md')
database:set('lang:gp:'..msg.chat_id_,true)
end
end
end
----------------------------------------------------------------------------
if text == 'config' or text == 'ترفیع کلی' then
local function promote_admin(extra, result, success)
vardump(result)
local chat_id = msg.chat_id_
local admins = result.members_
for i=1 , #admins do
if database:sismember(SUDO..'mods:'..msg.chat_id_,admins[i].user_id_) then
else
database:sadd(SUDO..'mods:'..msg.chat_id_,admins[i].user_id_)
end
end
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• All Admins Have Been Successfully Promoted !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ ادمین های گروه در ربات ترفیع یافتند.', 1, 'md')
end
end
bot.getChannelMembers(msg.chat_id_, 0, 'Administrators', 200, promote_admin)
end
----------------------------------------------------------------------------
if text == 'clean bots' or text == 'پاکسازی ربات ها' then
local function cb(extra,result,success)
local bots = result.members_
for i=0 , #bots do
kick(msg,msg.chat_id_,bots[i].user_id_)
end
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• All Api Robots Were Kicked !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ تمامی ربات های (Api)🤖 اخراج شدند.', 1, 'md')
end
end
bot.channel_get_bots(msg.chat_id_,cb)
end
----------------------------------------------------------------------------
if text and text:match('^setlink (.*)') or text:match('^تنظیم لینک (.*)') then
local link = text:match('^setlink (.*)') or text:match('^تنظیم لینک (.*)')
database:set(SUDO..'grouplink'..msg.chat_id_, link)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• The New Link Was Successfully Saved And Changed !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ لینک درخواستی با موفقیت ثبت شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'remlink' or text == 'حذف لینک' then
database:del(SUDO..'grouplink'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• The Link Was Successfully Deleted !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ لینک ثبت شده حذف شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'remrules' or text == 'حذف قوانین' then
database:del(SUDO..'grouprules'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• Group Rules Have Been Successfully Deleted !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ قوانین ثبت شده حذف شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('^setrules (.*)') or text:match('^تنظیم قوانین (.*)') then
link = text:match('^setrules (.*)') or text:match('^تنظیم قوانین (.*)')
database:set(SUDO..'grouprules'..msg.chat_id_, link)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• Group Rules Were Successfully Registered !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ قوانین درخواستی با موفقیت ثبت شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'welcome enable' or text == 'پیام خوشامدگویی روشن' then
database:set(SUDO..'status:welcome:'..msg.chat_id_,'enable')
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• Welcome Message Was Activated !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ پیام خوشامد گویی فعال شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'welcome disable' or text == 'پیام خوشامدگویی خاموش' then
database:set(SUDO..'status:welcome:'..msg.chat_id_,'disable')
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• Sending Welcome Message Has Been Disabled !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ پیام خوشامد گویی غیرفعال شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('^setwelcome (.*)$') or text:match('^تنظیم ولکام (.*)$') then
local welcome = text:match('^setwelcome (.*)$') or text:match('^تنظیم ولکام (.*)$')
database:set(SUDO..'welcome:'..msg.chat_id_,welcome)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'<b>Welcome Message Was Successfully Saved And Changed</b>\n<b>Welcome Message Text :</b>\n{ '..welcome..' }', 1, 'html')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ پیام خوشامد گویی با موفقیت ثبت شد.\n\nپیام خوشامد گویی :\n{ '..welcome..' }', 1, 'html')
end
end
----------------------------------------------------------------------------
if text == 'rem welcome' or text == 'حذف خوشامدگویی' then
database:del(SUDO..'welcome:'..msg.chat_id_,welcome)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'• The Welcome Message Was Reset And Set To Default !', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ پیام خوشامد گویی به حالت اولیه بازگشت.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'ownerlist' or text == 'لیست مالکین' then
local list = database:smembers(SUDO..'owners:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
t = '↫ ownerlist :\n\n'
else
t = '↫ لیست مالکین گروه :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - `[ "..v.." ]`\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '_The List Of Owners Of The Group Is Empty_ !'
else
t = '↫ لیست مالکین گروه خالی است .'
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if text == 'promote' or text == 'ترفیع' then
function prom_reply(extra, result, success)
database:sadd(SUDO..'mods:'..msg.chat_id_,result.sender_user_id_)
local user = result.sender_user_id_
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Added To The Group Promote List !', 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '↫ کاربر  ( '..user..' ) به لیست مدیران گروه اضافه شد.', 11, string.len(user))
end
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text and text:match('^promote (%d+)') or text:match('^ترفیع (%d+)') then
user = text:match('promote (%d+)') or text:match('^ترفیع (%d+)')
database:sadd(SUDO..'mods:'..msg.chat_id_,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Added To The Group Promote List !', 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '↫ کاربر  ( '..user..' ) به لیست مدیران گروه اضافه شد.', 11, string.len(user))
end
end
----------------------------------------------------------------------------
if text == 'demote' or text == 'عزل' then
function prom_reply(extra, result, success)
database:srem(SUDO..'mods:'..msg.chat_id_,result.sender_user_id_)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '• User [ '..result.sender_user_id_..' ] Was Removed From The Group Promote List !', 9, string.len(result.sender_user_id_))
else
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '↫ کاربر  ( '..result.sender_user_id_..' ) از لیست مدیران گروه حذف شد.', 11, string.len(result.sender_user_id_))
end
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),prom_reply)
end
end
----------------------------------------------------------------------------
if text and text:match('^demote (%d+)') or text:match('^عزل (%d+)') then
local user = text:match('demote (%d+)') or text:match('^عزل (%d+)')
database:srem(SUDO..'mods:'..msg.chat_id_,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Removed From The Group Promote List !', 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '↫ کاربر  ( '..user..' ) از لیست مدیران گروه حذف شد.', 11, string.len(user))
end
end
----------------------------------------------------------------------------
if text == 'modlist' or text == 'لیست مدیران' then
local list = database:smembers(SUDO..'mods:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
local t = '↫ modlist :\n\n'
else
local t = '↫ لیست مدیران گروه :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - `"..v.."`\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '_The List Of Mods Of The Group Is Empty_ !'
else
t = '↫ لیست مدیران گروه خالی میباشد.'
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if text == 'clean modlist' or text == 'پاکسازی لیست مدیران' then
database:del(SUDO..'mods:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'Modlist has been cleaned!', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ لیست مدیران گروه پاکسازی شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'setvip' or text == 'تنظیم ویژه' then
function vip(extra, result, success)
database:sadd(SUDO..'vips:'..msg.chat_id_,result.sender_user_id_)
local user = result.sender_user_id_
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Added To The Group Vip List !', 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '↫ کاربر  ( '..user..' ) به لیست عضو ویژه گروه اضافه شد.', 11, string.len(user))
end
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),vip)
end
end
----------------------------------------------------------------------------
if text and text:match('^setvip (%d+)') or text:match('^تنظیم ویژه (%d+)') then
local user = text:match('setvip (%d+)') or text:match('^تنظیم ویژه (%d+)')
database:sadd(SUDO..'vips:'..msg.chat_id_,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ] Was Added To The Group Vip List !', 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '↫ کاربر  ( '..user..' ) به لیست عضو ویژه گروه اضافه شد.', 11, string.len(user))
end
end
----------------------------------------------------------------------------
if text == 'remvip' or text == 'حذف ویژه' then
function MrPokerWkoni(extra, result, success)
database:srem(SUDO..'vips:'..msg.chat_id_,result.sender_user_id_)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '• User [ '..result.sender_user_id_..' ]  ] Was Removed From The Group Vip List !', 9, string.len(result.sender_user_id_))
else
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '↫ کاربر  ( '..result.sender_user_id_..' ) از لیست عضو های ویژه گروه حذف شد.', 11, string.len(result.sender_user_id_))
end
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),MrPokerWkoni)
end
end
----------------------------------------------------------------------------
if text and text:match('^remvip (%d+)') or text:match('^حذف ویژه (%d+)') then
local user = text:match('remvip (%d+)') or text:match('^حذف ویژه (%d+)')
database:srem(SUDO..'vips:'..msg.chat_id_,user)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, user, msg.id_, '• User [ '..user..' ]  ] Was Removed From The Group Vip List !', 9, string.len(user))
else
SendMetion(msg.chat_id_, user, msg.id_, '↫ کاربر  ( '..user..' ) از لیست عضو های ویژه گروه حذف شد.', 11, string.len(user))
end
end
----------------------------------------------------------------------------
if text == 'viplist' or text == 'لیست ویژه' then
local list = database:smembers(SUDO..'vips:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
t = '↫ viplist :\n\n'
else
t = '↫ لیست کاربران ویژه :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - `"..v.."`\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '_The List Of vips Of The Group Is Empty_ !'
else
t = '↫ لیست کاربران ویژه خالی میباشد.'
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if text == 'clean viplist' or text == 'پاکسازی لیست ویژه' then
database:del(SUDO..'vips:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'Viplist has been cleaned!', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ لیست کاربران ویژه پاکسازی شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
end -- end is_owner msg
----------------------------------------------------------------------------
-- mods
if is_mod(msg) then
----------------------------------------------------------------------------
if text == 'automuteall enable' or text == 'قفل خودکار روشن' then
database:set(SUDO..'automuteall'..msg.chat_id_,true)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'Automuteall has been enabled.', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ قفل خودکار گروه با موفقیت فعال شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'automuteall disable' or text == 'قفل خودکار خاموش' then
database:del(SUDO..'automuteall'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'Automuteall has been disabled.', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ قفل خودکار گروه با موفقیت غیرفعال شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text1:match('^(automuteall) (%d+):(%d+)-(%d+):(%d+)$') then
local mehdi = {
string.match(text1, "^(automuteall) (%d+):(%d+)-(%d+):(%d+)$")
}
local endtime = mehdi[4]..mehdi[5]
local endtime1 = mehdi[4]..":"..mehdi[5]
local starttime2 = mehdi[2]..":"..mehdi[3]
database:set(SUDO..'EndTimeSee'..msg.chat_id_,endtime1)
database:set(SUDO..'StartTimeSee'..msg.chat_id_,starttime2)
local starttime = mehdi[2]..mehdi[3]
if endtime1 == starttime2 then
test = [[↫ زمان شروع قفل خودکار نمیتواند با زمان پایان آن برابر باشد.]]
bot.sendMessage(msg.chat_id_, msg.id_, 1,test, 1, 'md')
else
database:set(SUDO..'automutestart'..msg.chat_id_,starttime)
database:set(SUDO..'automuteend'..msg.chat_id_,endtime)
test= '↫ گروه شما به صورت خودکار از ساعت [ '..starttime2..' ] قفل و در ساعت [ '..endtime1 ..' ] باز میشود.'
bot.sendMessage(msg.chat_id_, msg.id_, 1,test, 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('^warnmax (%d+)') or text:match('^تنظیم اخطار (%d+)') then
local num = text:match('^warnmax (%d+)') or text:match('^تنظیم اخطار (%d+)')
if 2 > tonumber(num) or tonumber(num) > 10 then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ عددی بین 2 تا 10 وارد کنید.', 1, 'md')
else
database:hset("warn:"..msg.chat_id_ ,"warnmax" ,num)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'warn has been set to [ '..num..' ] number', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ اخطار به ( '..num..' ) عدد تنظیم شد.', 1, 'md')
end
end
end
----------------------------------------------------------------------------
if text == 'setwarn kick' then
database:hset("warn:"..msg.chat_id_ ,"swarn",'kick')
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ وضعیت اخطار به حالت اخراج تنظیم شد.', 1, 'html')
elseif text == 'setwarn ban' then
database:hset("warn:"..msg.chat_id_ ,"swarn",'ban')
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ وضعیت اخطار به حالت بن تنظیم شد.', 1, 'html')
elseif text == 'setwarn mute' then
database:hset("warn:"..msg.chat_id_ ,"swarn",'mute')
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ وضعیت اخطار به حالت سایلنت تنظیم شد.', 1, 'html')
end
----------------------------------------------------------------------------
if (text == 'warn' or text == 'اخطار') and tonumber(msg.reply_to_message_id_) > 0 then
function warn_by_reply(extra, result, success)
if tonumber(result.sender_user_id_) == tonumber(bot_id) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'باشه باعی', 1, 'md')
return false
end
if priv(msg.chat_id_,result.sender_user_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ کاربر مورد نظر جزو ( مالکین | سازندگان ) ربات میباشد!', 1, 'md')
else
local nwarn = tonumber(database:hget("warn:"..result.chat_id_,result.sender_user_id_) or 0)
local wmax = tonumber(database:hget("warn:"..result.chat_id_ ,"warnmax") or 3)
if nwarn == wmax then
database:hset("warn:"..result.chat_id_,result.sender_user_id_,0)
warn(msg,msg.chat_id_,result.sender_user_id_)
else
database:hset("warn:"..result.chat_id_,result.sender_user_id_,nwarn + 1)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'warn has been set to [ '..num..' ] number', 1, 'md')
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '↫ User ( '..result.sender_user_id_..' )  Due to non-observance of the rules, you received a warning from the robot management regarding the number of your warns :  '..(nwarn + 1)..'/'..wmax..'', 9, string.len(result.sender_user_id_))
else
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '↫ کاربر ( '..result.sender_user_id_..' )  به دلیل رعایت نکردن قوانین از مدیریت ربات اخطار دریافت کردید تعداد اخطار های شما :  '..(nwarn + 1)..'/'..wmax..'', 10, string.len(result.sender_user_id_))
end
end
end
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),warn_by_reply)
end
----------------------------------------------------------------------------
if (text == 'unwarn' or text == 'حذف اخطار') and tonumber(msg.reply_to_message_id_) > 0 then
function unwarn_by_reply(extra, result, success)
if priv(msg.chat_id_,result.sender_user_id_) then
else
if not database:hget("warn:"..result.chat_id_,result.sender_user_id_) then
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '↫ User ( '..result.sender_user_id_..' ) has not received any warns', 9, string.len(result.sender_user_id_))
else
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '↫ کاربر ( '..result.sender_user_id_..' ) هیچ اخطاری ندارد.', 10, string.len(result.sender_user_id_))
end
local warnhash = database:hget("warn:"..result.chat_id_,result.sender_user_id_)
else database:hdel("warn:"..result.chat_id_,result.sender_user_id_,0)
if database:get('lang:gp:'..msg.chat_id_) then
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '↫ user ( '..result.sender_user_id_..' ) cleared all his warnings.', 9, string.len(result.sender_user_id_))
else
SendMetion(msg.chat_id_, result.sender_user_id_, msg.id_, '↫ کاربر ( '..result.sender_user_id_..' ) تمام اخطار هایش پاکسازی شدند.', 10, string.len(result.sender_user_id_))
end
end
end
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unwarn_by_reply)
end
----------------------------------------------------------------------------
if text and (text:match('^help') or text:match('^راهنما$'))and check_user(msg) and not msg.forward_info_ then
text = [[
به بخش راهنمای ربات راد خوش آمدید ! 🖌

لطفا بخش مورد نظر خود را بعد از این متن بنویسید :

برای دریافت راهنمای قفلی و حالات آن :

`راهنمای قفلی`

برای دریافت راهنمای مدیریتی :

`راهنمای مدیریتی`

برای دریافت راهنمای سکوت :

`راهنمای محدودیتی`

برای دریافت راهنمای پاکسازی :

`راهنمای پاکسازی`

برای دریافت دستورات عمومی و دستورات فان :

`راهنمای عمومی`

برای دریافت دستورات صاحب ربات :

`راهنمای سودو`

⚠️ فقط متن مورد نظر خود را تایپ کنید !

قبل از استفاده از ربات لطفا قوانین ربات را مشاهده کنید و اگر به مشکلی خوردید از پشتیبانی کمک بگیرید ...

برای دریافت قوانین ربات :

`قوانین ربات`

برای تماس با پشتیبانی :

`پشتیبانی`
]]

bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'md')
end


----------------------------------------------------------------------------
local function getsettings(value)
if value == 'muteall' then
local hash = database:get(SUDO..'muteall'..msg.chat_id_)
if hash then
return '( فعال ✓ )'
else
return '( غیرفعال ✘ )'
end
elseif value == 'welcome' then
local hash = database:get(SUDO..'welcome:'..msg.chat_id_)
if hash == 'enable' then
return '( فعال ✓ )'
else
return '( غیرفعال ✘ )'
end
elseif value == 'spam' then
local hash = database:hget("flooding:settings:"..msg.chat_id_,"flood")
if hash then
if database:hget("flooding:settings:"..msg.chat_id_, "flood") == "kick" then
return '( فعال - اخراج )'
elseif database:hget("flooding:settings:"..msg.chat_id_,"flood") == "ban" then
return '( فعال - بن )'
elseif database:hget("flooding:settings:"..msg.chat_id_,"flood") == "mute" then
return '( فعال - سایلنت )'
end
else
return '( غیرفعال ✘ )'
end
elseif is_lock(msg,value) then
return  '( فعال ✓ )'
else
return '( غیرفعال ✘ )'
end
end
----------------------------------------------------------------------------
if text == 'settings' or text == 'تنظیمات' then
local wmax = tonumber(database:hget("warn:"..msg.chat_id_ ,"warnmax") or 3)
local text = '↫ تنظیمات اصلی گروه :\n\n'
..'⇜ قفل لینک : '..getsettings('links')..'\n'
..'⇜ قفل ربات : '..getsettings('bot')..'\n'
..'⇜ قفل تگ : '..getsettings('tag')..'\n'
..'⇜ قفل رگبار : '..getsettings('spam')..'\n'
..'⇜ قفل یوزرنیم : '..getsettings('username')..'\n'
..'⇜ قفل فوروارد : '..getsettings('forward')..'\n'
..'⇜ تعداد رگبار : [ '..NUM_MSG_MAX..' ]\n'
..'⇜ زمان رگبار : [ '..TIME_CHECK..' ]\n\n'
..'↫ تنظیمات فرعی گروه :\n\n'
..'✤ قفل پاسخ : '..getsettings('reply')..'\n'
.. '✤ قفل فحش : '..getsettings('fosh')..'\n'
.. '✤ قفل تبچی : '..getsettings('tabchi')..'\n'
..'✤ قفل ورودی : '..getsettings('join')..'\n'
..'✤ قفل فارسی : '..getsettings('persian')..'\n'
..'✤ قفل سنجاق : '..getsettings('pin')..'\n'
.. '✤ قفل ایموجی : '..getsettings('emoji')..'\n'
.. '✤ قفل دستورات : '..getsettings('cmd')..'\n'
..'✤ خوشامد گویی : '..getsettings('welcome')..'\n'
..'✤ قفل انگیلیسی : '..getsettings('english')..'\n'
.. '✤ قفل فیلم سلفی : '..getsettings('selfvideo')..'\n'
..'✤ قفل پیام سرویسی : '..getsettings('tgservice')..'\n'
..'✤ قفل دکمه شیشه ای : '..getsettings('inline')..'\n\n'
..'↫ تنظیمات رسانه گروه :\n\n'
..'✦ قفل صدا : '..getsettings('voice')..'\n'
..'✦ قفل گیف : '..getsettings('gif')..'\n'
..'✦ قفل فایل : '..getsettings('file')..'\n'
..'✦ قفل متن : '..getsettings('text')..'\n'
..'✦ قفل فیلم : '..getsettings('video')..'\n'
..'✦ قفل بازی : '..getsettings('game')..'\n'
..'✦ قفل عکس : '..getsettings('photo')..'\n'
..'✦ قفل موزیک : '..getsettings('music')..'\n'
..'✦ قفل استیکر : '..getsettings('sticker')..'\n'
..'✦ قفل مخاطب : '..getsettings('contact')..'\n\n'
.."↫ اطلاعات گروه :\n\n"
.."⇦ تعداد اخطار : ( `"..wmax.."/10` )\n"
..'⇦ قفل گروه : '..getsettings('muteall')..'\n'
.."⇦ آیدی شخص : ( `"..msg.sender_user_id_.."` )\n"
.."⇦ آیدی گروه : ( `"..msg.chat_id_.."` )\n\n"
bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
-------------------------------------------------Flood------------------------------------------------
if text and text:match('^setfloodmax (%d+)$') then
database:hset("flooding:settings:"..msg.chat_id_ ,"floodmax" ,text:match('setfloodmax (.*)'))
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'*The Maximum Message Sending Speed Is Set To :* [ `'..text:match('setfloodmax (.*)')..'` ]', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ حداکثر ارسال رگبار به ( `'..text:match('setfloodmax (.*)')..'` ) تنظیم شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('^setfloodtime (%d+)$') then
database:hset("flooding:settings:"..msg.chat_id_ ,"floodtime" ,text:match('setfloodtime (.*)'))
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'*Maximum Reception Recognition Time Set to :* [ `'..text:match('setfloodtime (.*)')..'` ]', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ حداکثر زمان ارسال رگبار به ( `'..text:match('setfloodtime (.*)')..'` ) تنظیم شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'link' or text == 'لینک' then
local link = database:get(SUDO..'grouplink'..msg.chat_id_)
if link then
if database:get('lang:gp:'..msg.chat_id_) then
 bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Group Link :* \n'..link, 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ لینک گروه :  \n'..link, 1, 'md')
end
else
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*The Link To The Group Has Not Been Set*\n*Register New Link With Command*\n/setlink link\n*It Is Possible.*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ لینکی برای گروه تنظیم نشده است !', 1, 'md')
end
end
end
----------------------------------------------------------------------------
if text == 'rules' or text == 'قوانین' then
local rules = database:get(SUDO..'grouprules'..msg.chat_id_)
if rules then
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Group Rules :* \n'..rules, 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ قوانین گروه : \n'..rules, 1, 'md')
end
else
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Rules Are Not Set For The Group.*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ قانونی برای گروه تنظیم نشده است !', 1, 'md')
end
end
end
----------------------------------------------------------------------------
if text == 'mutechat' or text == 'قفل چت' then
database:set(SUDO..'muteall'..msg.chat_id_,true)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*Filter All Conversations Enabled!*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ قفل چت فعال شد .', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'unmutechat' or text == 'باز کردن چت' then
database:del(SUDO..'muteall'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*All Conversations Filtered Disabled!*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ قفل چت غیرفعال شد .', 1, 'md')
end
end
----------------------------------------------------------------------------
if (text == 'kick' or text == 'اخراج') and tonumber(msg.reply_to_message_id_) > 0 then
function kick_by_reply(extra, result, success)
kick(msg,msg.chat_id_,result.sender_user_id_)
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),kick_by_reply)
end
----------------------------------------------------------------------------
if text and text:match('^kick (%d+)') then
kick(msg,msg.chat_id_,text:match('kick (%d+)'))
end
if text and text:match('^اخراج (%d+)') then
kick(msg,msg.chat_id_,text:match('اخراج (%d+)'))
end
-------------------------------------------------Ban-------------------------------------------------
if (text == 'ban' or text == 'مسدود') and tonumber(msg.reply_to_message_id_) > 0 then
function banreply(extra, result, success)
ban(msg,msg.chat_id_,result.sender_user_id_)
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),banreply)
end
----------------------------------------------------------------------------
if text and text:match('^ban (%d+)') then
ban(msg,msg.chat_id_,text:match('ban (%d+)'))
end
if text and text:match('^مسدود (%d+)') then
ban(msg,msg.chat_id_,text:match('مسدود (%d+)'))
end
----------------------------------------------------------------------------
if (text == 'unban' or text == 'لغو مسدودیت') and tonumber(msg.reply_to_message_id_) > 0 then
function unbanreply(extra, result, success)
unban(msg,msg.chat_id_,result.sender_user_id_)
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unbanreply)
end
----------------------------------------------------------------------------
if text and text:match('^unban (%d+)') then
unban(msg,msg.chat_id_,text:match('unban (%d+)'))
end
if text and text:match('^لغو مسدودیت (%d+)') then
unban(msg,msg.chat_id_,text:match('لغو مسدودیت (%d+)'))
end
----------------------------------------------------------------------------
if text == 'banlist' or text == 'لیست مسدود' then
local list = database:smembers(SUDO..'banned'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
t = '↫ banlist :\n\n'
else
t = '↫ لیست افراد بن شده :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - `"..v.."`\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '*The List Of Member Blocked Is Empty.*'
else
t = '↫ لیست افراد بن شده خالی میباشد.'
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if text == 'clean banlist' then
database:del(SUDO..'banned'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'*The List Of Blocked Users From The Group Was Successfully Deleted.*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ لیست افراد بن شده پاکسازی شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if (text == 'silent' or text == 'سکوت') and tonumber(msg.reply_to_message_id_) > 0 then
function mutereply(extra, result, success)
mute(msg,msg.chat_id_,result.sender_user_id_)
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),mutereply)
end
----------------------------------------------------------------------------
if text and text:match('^silent (%d+)') then
mute(msg,msg.chat_id_,text:match('silent (%d+)'))
end
if text and text:match('^سکوت (%d+)') then
mute(msg,msg.chat_id_,text:match('سکوت (%d+)'))
end
----------------------------------------------------------------------------
if (text == 'unsilent' or text == 'لغو سکوت') and tonumber(msg.reply_to_message_id_) > 0 then
function unmutereply(extra, result, success)
unmute(msg,msg.chat_id_,result.sender_user_id_)
end
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),unmutereply)
end
----------------------------------------------------------------------------
if text and text:match('^unsilent (%d+)') then
unmute(msg,msg.chat_id_,text:match('unsilent (%d+)'))
end
if text and text:match('^لغو سکوت (%d+)') then
unmute(msg,msg.chat_id_,text:match('لغو سکوت (%d+)'))
end
----------------------------------------------------------------------------
if text == 'silentlist' or text == 'لیست سکوت' then
local list = database:smembers(SUDO..'mutes'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
t = '*User List Silent Mode :*\n\n'
else
t = '↫ لیست افراد سایلنت شده :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - `"..v.."`\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '*The List Of Silent Member Is Empty !*'
else
t = '↫ لیست افراد سایلنت شده خالی میباشد.'
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if text == 'clean silentlist' or text == 'پاکسازی لیست سکوت' then
database:del(SUDO..'mutes'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'*List of Member In The List The Silent List Was Successfully Deleted.*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ لیست افرادی که در حالت سایلنت هستند پاکسازی شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('^del (%d+)$') or text:match('^پاکسازی (%d+)$') then
local limit = tonumber(text:match('^del (%d+)$') or text:match('^حذف (%d+)$'))
if limit > 1000 then
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '*The Number Of Messages Entered Is Greater Than The Limit (*`1000` *messages)*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ شما در هر بار پاکسازی فقط میتوانید ( 100 ) پیام گروه را پاک کنید!', 1, 'md')
end
else
function cb(a,b,c)
local msgs = b.messages_
for i=1 , #msgs do
delete_msg(msg.chat_id_,{[0] = b.messages_[i].id_})
end
end
bot.getChatHistory(msg.chat_id_, 0, 0, limit + 1,cb)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'[ `'..limit..'` ] *Recent Group Messages Deleted !*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ تعداد ( `'..limit..'` ) پیام گروه پاک شد.', 1, 'md')
end
end
end
----------------------------------------------------------------------------
if tonumber(msg.reply_to_message_id_) > 0 then
if text == "del" then
delete_msg(msg.chat_id_,{[0] = tonumber(msg.reply_to_message_id_),msg.id_})
end
end
-------------------------------------------------Filter Word-------------------------------------------------
if text and text:match('^filter (.*)') or text:match('^فیلتر (.*)') then
local w = text:match('^filter (.*)') or text:match('^فیلتر (.*)')
database:sadd(SUDO..'filters:'..msg.chat_id_,w)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'[` '..w..'` ] *Was Added To The List Of Filtered Words!*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ عبارت ( '..w..' ) به لیست کلمات فیلتر شده اضافه شد.', 1, 'html')
end
end
----------------------------------------------------------------------------
if text and text:match('^unfilter (.*)') or text:match('^حذف فیلتر (.*)') then
local w = text:match('^unfilter (.*)') or text:match('^حذف فیلتر (.*)')
database:srem(SUDO..'filters:'..msg.chat_id_,w)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'[ `'..w..'` ] Was Deleted From The Filtered List', 1, 'html')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ عبارت ( '..w..' ) از لیست کلمات فیلتر شده حذف شد.', 1, 'html')
end
end
----------------------------------------------------------------------------
if text == 'clean filterlist' or text == 'پاکسازی لیست فیلتر' then
database:del(SUDO..'filters:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1,'*All Filtered Words Have Been Successfully Deleted.*', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ لیست کلمات فیلتر شده پاکسازی شد.', 1, 'md')
end
end
----------------------------------------------------------------------------
if text == 'filterlist' or text == 'لیست فیلتر' then
local list = database:smembers(SUDO..'filters:'..msg.chat_id_)
if database:get('lang:gp:'..msg.chat_id_) then
t = '*List Of Words Filtered In Group :*\n\n'
else
t = '↫ لیست کلمات فیلتر شده :\n\n'
end
for k,v in pairs(list) do
t = t..k.." - "..v.."\n"
end
if #list == 0 then
if database:get('lang:gp:'..msg.chat_id_) then
t = '*Filtered Word List Is Empty*'
else
t = '↫ لیست کلمات فیلتر شده خالی میباشد.'
end
end
bot.sendMessage(msg.chat_id_, msg.id_, 1,t, 1, 'md')
end
----------------------------------------------------------------------------
if (text == 'pin' or text == 'سنجاق') and msg.reply_to_message_id_ ~= 0 then
local id = msg.id_
local msgs = {[0] = id}
pin(msg.chat_id_,msg.reply_to_message_id_,0)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.reply_to_message_id_, 1, "*Your message was pinned*", 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.reply_to_message_id_, 1, "↫ پیام مورد نظر سنجاق شد.", 1, 'md')
end
end
----------------------------------------------------------------------------
if (text == 'unpin' or text == 'حذف سنجاق') and msg.reply_to_message_id_ ~= 0 then
local id = msg.id_
local msgs = {[0] = id}
unpin(msg.chat_id_,msg.reply_to_message_id_,0)
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.reply_to_message_id_, 1, "*message unpinned*", 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.reply_to_message_id_, 1, "↫ پیام سنجاق شده برداشته شد.", 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('whois (%d+)') then
local id = text:match('whois (%d+)')
local text = 'کلیک کنید !'
tdcli_function ({ID="SendMessage", chat_id_=msg.chat_id_, reply_to_message_id_=msg.id_, disable_notification_=0, from_background_=1, reply_markup_=nil, input_message_content_={ID="InputMessageText", text_=text, disable_web_page_preview_=1, clear_draft_=0, entities_={[0] = {ID="MessageEntityMentionName", offset_=0, length_=11, user_id_=id}}}}, dl_cb, nil)
end
----------------------------------------------------------------------------
if text == "id" then
function id_by_reply(extra, result, success)
bot.sendMessage(msg.chat_id_, msg.id_, 1, '↫ آیدی شخص : ( `'..result.sender_user_id_..'` )', 1, 'md')
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),id_by_reply)
end
end
----------------------------------------------------------------------------
end -- end is_mod msg
----------------------------------------------------------------------------
-- memeber
----------------------------------------------------------------------------
if text and text:match('^[Aa]ctive') and not database:get(SUDO.."active:"..msg.chat_id_) then
database:set(SUDO.."active:"..msg.chat_id_, true)
bot.sendMessage(msg.chat_id_, msg.id_, 1, 'شما در حال نصب ربات برای گروه خود میباشید !\n\n\nلطفا برای تکمیل کردن نصب دستور زیر را وارد کنید :\n\n/setme\n\nبا وارد کردن این دستور شما مالک ربات میشوید !\n\n• Ch : '..botchannel..' \n گپ پشتیبانی : \n '..supportgp..'', 1, 'html')
tdcli.forwardMessages(realm_id, msg.chat_id_,{[0] = msg.id_}, 0)
elseif text and text:match('^[Ss]etme') and not database:get(SUDO.."omg:"..msg.chat_id_) then
database:sadd(SUDO.."owners:"..msg.chat_id_, msg.sender_user_id_)
database:set(SUDO.."omg:"..msg.chat_id_, true)
bot.sendMessage(msg.chat_id_, msg.id_, 1, 'شما با موفیت به عنوان مالک ربات تنظیم شدید.\n\n\nلطفا برای دریافت راهنما دستور زیر را ارسال کنید :\n\n/help\n\nلطفا برا حمایت از ربات و تیم ما. مارا به اشتراک بزارید.\n\n➢ Ch : '..botchannel..' \n گپ پشتیبانی : \n '..supportgp..'', 1, 'html')
tdcli.forwardMessages(realm_id, msg.chat_id_,{[0] = msg.id_}, 0)
end
----------------------------------------------------------------------------
if text and msg_type == 'text' and not is_muted(msg.chat_id_,msg.sender_user_id_) then
----------------------------------------------------------------------------
if text == "ربات" then
if database:get('ranks:'..msg.sender_user_id_) then
local rank =  database:get('ranks:'..msg.sender_user_id_)
local  k = {"جونم","جانم","بنال","چیه همش صدام میکنی","خستم کردی","بلههه" ,"بگو"}
bot.sendMessage(msg.chat_id_, msg.id_, 1,''..k[math.random(#k)]..' '..rank..'',1,'md')
else
local p = {"چه عجب","جونم","جانم","😐","بنال","چیه همش صدام میکنی","خستم کردی","بلههه","😕" ,"بگو","😐"}
bot.sendMessage(msg.chat_id_, msg.id_, 1,''..p[math.random(#p)]..'', 1, 'html')
end
end
----------------------------------------------------------------------------

if text and text:match('^[Mm]e') or text:match("^من$") then
local rank =  database:get('ranks:'..msg.sender_user_id_) or '------'
local msgs = database:get(SUDO..'total:messages:'..msg.chat_id_..':'..msg.sender_user_id_)
if is_ultrasudo(msg) then
t = 'صاحب ربات'
elseif is_sudo(msg) then
t = 'مدیر ربات'
elseif is_owner(msg) then
t = 'مالک گروه'
elseif is_mod(msg) then
t = 'مدیر گروه'
elseif is_vip(msg) then
t = 'کاربر ویژه'
else
t = 'فرد عادی'
end
local nwarn = database:hget("warn:"..msg.chat_id_,msg.sender_user_id_) or 0
if database:get('lang:gp:'..msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» Your ID : [ `'..msg.sender_user_id_..'` ]\n» Gp ID : [ `'..msg.chat_id_..'` ]\n» Access level : [ '..t..' ]\n» Warns : [ `'..nwarn ..'` ]\n↫ Your msgs : [ `'..msgs..'` ]\n↫ Your rank : [ '..rank..' ]\n\n', 1, 'md')
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, '» آیدی شما : [ `'..msg.sender_user_id_..'` ]\n» آیدی گروه : [ `'..msg.chat_id_..'` ]\n» سطح دسترسی : [ '..t..' ]\n» تعداد اخطار های شما : [ `'..nwarn ..'` ]\n↫ تعداد پیام های شما : [ `'..msgs..'` ]\n↫ مقام شما : [ '..rank..' ]\n\n', 1, 'md')
end
end
----------------------------------------------------------------------------
if text and text:match('^bot rules$') or text:match("^قوانین ربات$") then

text = [[
قوانین استفاده از ربات راد ! 📚


لطفا قوانین زیر را خوانده و سپس ربات را استفاده کنید در غیر این صورت از عواقب آن معذوریم !

1- از نصب ربات در گروه های پورن , ضد خدا , سیاسی جدا خودداری کنید در صورت مشاهده برخورد خواهد شد !
2- از تکرار دستورات خودداری کنید !
3- از استفاده ربات در گروه هایی که ربات های دیگر حضور دارد خودداری کنید و یا آن را با سایر ربات های خود ساز گار کنید !
4- شرط رایگان بودن ربات تبلیغ های محدودی هست که از سمت ربات ارسال میشود و تنها خواسته ما ماندگاری تبلیغ در گروه شماست !
5- در صورت فعال بودن حالت عضویت اجباری حتما در کانال پشتیبانی راد عضو شوید !

در صورت بروز هرگونه مشکل دستور `پشتیبانی` را ارسال کنید ! 💸
]]
bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'md')
end

if text and text:match('^lhelp$') or text:match("^راهنمای قفلی$") then

text = [[
به بخش راهنمای قفلی ربات راد خود آمدید ! 🖌

لطفا بخش مورد نظر خود را بعد از این متن بنویسید :

برای قفل کردن از کلمه lock در ابتدای هر کلمه که در زیر نام برده میشود و برای باز کردن از کلمه unlock استفاده کنید !

[ link | forward | username | tag | inline | tgservice | persian | English | pin | bot | emoji | cmd | selfivideo | join | fosh | tabchi | tgservice | photo | video | voice | gif | music | file | reply | text | contact | sticker | game ]

برای مثال برای قفل کردن لینک :

lock link 

برای باز کردن قفل لینک :

unlock link

⚠️ فقط متن مورد نظر خود را تایپ کنید !

کانال ما :

]] ..botchannel.. [[
]]
bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'html')
end
if text and text:match('^mchelp$') or text:match("^راهنمای محدودیتی$") then

text = [[
ه بخش راهنمای محدودیتی ربات راد خوش آمدید ! 🖌

لطفا بخش مورد نظر خود را بعد از این متن بنویسید :

⇝ silent
↫ ساکت کردن کاربر مورد نظر
⇝ unsilent
↫ دراوردن کاربر مورد نظر از حالت سایلنت

↫ تنظیم تعداد اخطار
⇝ setwarn kick
⇝ setwarn ban
⇝ setwarn mute
↫ تنظیم حالت اخطار
⇝ warn [reply]
↫ برای دادن اخطار
⇝ unwarn [reply]
↫ برای حذف اخطار کاربر مورد نظر

⇝ kick
↫ اخراج فرد مورد نظر از گروه
⇝ ban
↫ بن کردن فرد مورد نظر از گروه
⇝ unban
⇝ filter
↫ فیلتر کردن
⇝ unfilter
↫ در اوردن از حالت فیلتر
⇝ automuteall enable
↫ فعال سازی حالت سایلنت خودکار
⇝ automuteall disable
↫ غیر فعال سازی سایلنت خودکار
⇝ automuteall start-stop
_بخش مربوط به تنظیم پیام های مکرر و اسپم_
⇝ setfloodmax [1-40]
↫ تنظیم میزارن فلود
↫ به جای [1-40] عدد بگزارید
_بخش تنظیم زمان ارسال پیام مکرر_
⇝ setfloodtime [1-30]
↫ تنظیم زمان فلود
⇝ lock flood mute
↫ با فعال سازی این فرایند شخص ارسال کننده در حالت سایلنت قرار میگیرد
⇝ lock flood ban
↫ با فعال سازی این فرایند شخص ارسال کننده اخراج میشود
⇝ lock flood kick
↫ با فعال سازی این فرایند شخص ارسال کننده به صورت کلی از گروه اخراج 

کانال ما :

]] ..botchannel.. [[ 
]]
bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'html')
end
if text and text:match('^mhelp$') or text:match("^راهنمای مدیریتی$") then

text = [[
به بخش راهنمای مدیریتی ربات راد خود آمدید ! 🖌

لطفا بخش مورد نظر خود را بعد از این متن بنویسید :

⇝ setvip
↫ تنظیم فرد به عنوان کاربر ویژه

⇝ remvip

↫ حذف فرد از مقام کاربر ویژه
⇝ Viplist

⇝ ruadmin
↫آگاهی از ادمین بودن یا نبودن ربات 

⇝ banlist
↫ نمایش بن لیست گروه

⇝ promotelist
↫ نمایش لیست مدیر های ربات

⇝ ownerlist
⇝ promote
↫دادن مقام به کاربر مورد نظر
⇝ demote
↫ گرفتن مقام از کاربر مورد نظر
⇝ config
↫ ارتقا تمامی ادمین های  گروه به ادمین ربات

کانال ما :

]] ..botchannel.. [[ 
]]
bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'html')
end
if text and text:match('^cleanhelp$') or text:match("^راهنمای پاکسازی$") then

text = [[
به بخش راهنمای پاکسازی ربات راد خود آمدید ! 🖌

لطفا بخش مورد نظر خود را بعد از این متن بنویسید :

⇝ Cleanvip
↫ پاکسازی لیست افراد ویژه
⇝ clean modlist
↫ پاکسازی لیست پروموت ها
⇝ clean ownerlist
↫ پاکسازی لیست اونر های گروه

⇝ clean banlist
↫ پاکسازی بن لیست گروه
⇝ clean promotelist
↫ پاکسازی لیست مدیرها

⇝ del [1-100]
↫ حذف پیام توسط ربات

⇝ clean delete
↫ پاکسازی افراد دیلیت اکانت 

⇝ clean deactive
↫ پاکسازی عضو های غیر فعال در گروه :
فرایدند های حذفی :

⇝ clean [ banlist | silentlist | modlist | blocklist | filterlist | deleted | bots ]

کانال ما :

]] ..botchannel.. [[ 
]]
bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'html')
end

if text and text:match('^memhelp$') or text:match("^راهنمای عمومی$") then

text = [[
به بخش راهنمای عمومی ربات راد خود آمدید ! 🖌

لطفا بخش مورد نظر خود را بعد از این متن بنویسید :

⇝ ping
↫ اگاهی از انلاینی ربات•

از دستور "ربات" هم میتوانید استفاده کنید !

⇝ link
↫ دریافت لینک گروه

⇝ id | me
↫ نمایش مشخصات شما

⇝ rules
↫ قوانین گروه•

کانال ما :

]] ..botchannel.. [[  
]]
bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'html')
end
if text and text:match('^funhelp$') or text:match("^راهنمای فان$") then

text = [[
به بخش راهنمای فان ربات راد خود آمدید ! 🖌

لطفا بخش مورد نظر خود را بعد از این متن بنویسید :

↫ برای آگاهی از مدت زمان باقی مانده تا عید :

⇝ eid

↫ دریافت شماره سازنده ربات :

⇝ share | dev

↫  دریافت لینک دیلیت اکانت :

⇝ del acc

↫ دریافت تاریخ و ساعت :

⇝ date

↫ دریافت وضعیت آب و هوای شهر خود :

⇝ weather city |
مثال :

⇝ weather tehran

کانال ما :

]] ..botchannel.. [[  
]]
bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'html')
end
if text and text:match('^sudohelp$') or text:match("^راهنمای سودو$") and is_sudo(msg) then

text = [[
به بخش راهنمای سودو ربات راد خود آمدید ! 🖌

لطفا بخش مورد نظر خود را بعد از این متن بنویسید :

↫ دریافت آمار ربات :

⇝ stats

↫ راه اندازی مجدد ربات :
⇝ reload

↫ شمارش مجدد آمار :

⇝ reset stats
⇝ reset allmsgs
⇝ reset pvmsgs
⇝ reset gpsmsgs
⇝ reset sgpsmsgs
⇝ reset pv
⇝ reset gps
⇝ reset sgps

↫ ارسال پیام به گروه ها :

⇝ fwd all | pv | sgps | gps

↫ خارج کردن ربات از گروه :

⇝ leave

↫ یادداشت برداری :

⇝ note (text)

↫ دریافت متن یادداشت :

⇝ getnote
]]
bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'html')
end
-----------------------------------------------------------------------------
if text:match("^[Nn]ote (.*)$") or text:match("^یادداشت (.*)$") and is_sudo(msg) then
          local txt = {
            string.match(text, "^([Nn]ote) (.*)$")
          }
          database:set("Sudo:note" .. msg.sender_user_id_, txt[2])
          if database:get("lang:gp:" .. msg.chat_id_) then
            bot.sendMessage(msg.chat_id_, msg.id_, 1, "• Your note has been saved !", 1, "md")
          else
            bot.sendMessage(msg.chat_id_, msg.id_, 1, "پیام یادداشت شما ذخیره شد !", 1, "md")
          end
        end
        if text:match("^[Gg]etnote$") or text:match("^یادداشت ها$") and is_sudo(msg) then
          local note = database:get("Sudo:note" .. msg.sender_user_id_)
          bot.sendMessage(msg.chat_id_, msg.id_, 1, note, 1, nil)
        end
------------------------------------------------------------------------------		
		local idf = tostring(msg.chat_id_)
    if idf:match("-100(%d+)") then
      local chatname = chat and chat and chat.title_
      local svgroup = "group:Name" .. msg.chat_id_
      if chat and chatname then
        database:set(svgroup, chatname)
      end
    end
	local text = msg.content_.text_:gsub('پاکسازی دیلیت اکانت','clean delete')
  	if text:match("^[Cc][Ll][Ee][Aa][Nn] [Dd][Ee][Ll][Ee][Tt][Ee]$") and is_mod(msg) then
	local txt = {string.match(text, "^([Cc][Ll][Ee][Aa][Nn] [Dd][Ee][Ll][Ee][Tt][Ee])$")}
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)
  if chat_id:match('^-100') then
local channel_id = chat_id:gsub('-100', '')
chat = {ID = channel_id, type = 'channel'}
  else
local group_id = chat_id:gsub('-', '')
chat = {ID = group_id, type = 'group'}
  end
  return chat
end
  local function check_delete(arg, data)
for k, v in pairs(data.members_) do
local function clean_cb(arg, data)
if not data.first_name_ then
bot.changeChatMemberStatus(msg.chat_id_, data.id_, "Kicked")
end
end
bot.getUser(v.user_id_, clean_cb)
end
if database:get('bot:lang:'..msg.chat_id_) then
text = '_> delete accounts has been_ *Cleaned*'
else
text = 'تمامی افراد دیلیت اکانت با موفقیت حذف شدند !'
end
	bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
 end
  tdcli_function ({ID = "GetChannelMembers",channel_id_ = getChatId(msg.chat_id_).ID,offset_ = 0,limit_ = 5000}, check_delete, nil)
  end

----------------------------------------------------------------------------
if text and text:match("^[Pp]ing$") or text:match("^انلاینی$") then
text = 'Rad Free Bot is Online Every Time :D'
SendMetion(msg.chat_id_, msg.sender_user_id_, msg.id_, ''..text..'' , 0, string.len(text))
end
----------------------------------------------------------------------------
if text == "id" or text == "Id" or text == "آیدی" or text == "ایدی" or text == "ID" then
if check_user(msg) then
if msg.reply_to_message_id_ == 0 then
local rank =  database:get('ranks:'..msg.sender_user_id_) or 'مقامی برای شما ثبت نشده است !'
local gmsgs = database:get(SUDO..'groupmsgkk:'..msg.chat_id_..':')
local msgs = database:get(SUDO..'total:messages:'..msg.chat_id_..':'..msg.sender_user_id_)
local function getpro(extra, result, success)
if result.photos_[0] then
if database:get('lang:gp:'..msg.chat_id_) then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[0].sizes_[1].photo_.persistent_id_,'↫ Your ID : [ '..msg.sender_user_id_..' ]\n↫ Your msg : [ '..msgs..' ]\n➢ Ch : '..botchannel..'', 1, 'md')
else
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[0].sizes_[1].photo_.persistent_id_,'↫ آیدی شما : [ '..msg.sender_user_id_..' ]\n↫ تعداد پیام های شما : [ '..msgs..' ]\n➢ Ch : '..botchannel..'', 1, 'md')
end
else
bot.sendMessage(msg.chat_id_, msg.id_, 1,'↫ پروفایلی برای شما ثبت نشده است!\n\n» آیدی شما : ( '..msg.sender_user_id_..' )\n\n↫ آیدی گروه : ( '..msg.chat_id_..' )\n\n↫ تعداد پیام های شما : ( '..msgs..' )\n\n↫ تعداد پیام های گروه : ( '..gmsgs..' )\n\n↫ مقام شما : ( '..rank..' )\n\n➢ Ch : '..botchannel..'', 1, 'md')
end
end
tdcli_function ({
ID = "GetUserProfilePhotos",
user_id_ = msg.sender_user_id_,
offset_ = 0,
limit_ = 1
}, getpro, nil)
end
end
end
----------------------------------------------------------------------------
if text:match("^[Dd][Ee][Vv]$") or text:match("^صاحب ربات$") or text:match("^برنامه نویس$") or text:match("^سودو$") or text:match("^share$") then
sendContact(msg.chat_id_, msg.id_, 0, 1, nil, (380970279062), ("Mr >> Rad"), "", bot_id)
end
----------------------------------------------------------------------------
if text:match("^del acc$") or text:match("^delete account$") or text:match("^دلت اکانت$") or text:match("^دیل اک$") or text:match("^دیل اکانت$") then
local text =  [[
🗑🗑 لینک دیلت اکانت شما ساخته شد !

"https://telegram.org/deactivate"

⚠️ اخطار : توجه داشته باشید که این لینک برای حذف اکانت کاربری شما در تلگرام میباشد !

📚 ابتدا بروی لینک زیر کلیک کرده و وارد سایت شده و شماره تلفن خود را با کد کشور وارد کنید !

برای مثال : 
+9809036091185

سپس منتظر کد از سمت تلگرام باشید سپس کد خود را کپی کرده و در سایت وارد کنید !

لحظات خوشی را در کنار خانواده برای شما آرزو مندیم !

]]

bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'html')
end
if text:match("^پشتیبانی$") or text:match("^support$") then
local text =  [[
🇮🇷 به بخش پشتیبانی ربات راد خوش آمدید !

لطفا قبل از درخواست پشتیبانی در هر  یک از بخش های زیر قوانین استفاده از ربات را مرور کنید !

✪ پشتیبان برای ریپورتی ها :

➥ ]] ..pvresan.. [[

✪ پشتیبان آنلاین و پدید آورنده ربات  :

➥ ]] ..sudoid..[[

✪ گروه و انجمن پشتیبانی ربات :

➥ ]] ..supportgp.. [[


✪ اپراتور مشکلات :

➥ ]] ..sudophone.. [[

✪ مارا در کانال زیر دنبال کنید :

➥ ]] ..botchannel.. [[

]]

bot.sendMessage(msg.chat_id_, msg.id_, 0,text, 1, 'html')
end
---------------------------------------------------------------
----------------------------------------------------------------------------
local text = msg.content_.text_:gsub('پاکسازی غیرفعال','clean deactive')
  	if text:match("^[Cc][Ll][Ee][Aa][Nn] [Dd][Ee][Aa][Cc][Tt][Ii][Vv][Ee]$") and is_mod(msg) then
	local txt = {string.match(text, "^([Cc][Ll][Ee][Aa][Nn] [Dd][Ee][Aa][Cc][Tt][Ii][Vv][Ee])$")}
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)
  if chat_id:match('^-100') then
local channel_id = chat_id:gsub('-100', '')
chat = {ID = channel_id, type = 'channel'}
  else
local group_id = chat_id:gsub('-', '')
chat = {ID = group_id, type = 'group'}
  end
  return chat
end
  local function check_deactive(arg, data)
for k, v in pairs(data.members_) do
local function clean_cb(arg, data)
if data.type_.ID == "UserTypeGeneral" then
if data.status_.ID == "UserStatusEmpty" then
bot.changeChatMemberStatus(msg.chat_id_, data.id_, "Kicked")
end
end
end
bot.getUser(v.user_id_, clean_cb)
end
if database:get('bot:lang:'..msg.chat_id_) then
text = 'deactive users has been cleaned !'
else
text = 'اعضای غیر فعال از گروه حذف شدند !'
end
	bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
 end
  tdcli_function ({ID = "GetChannelMembers",channel_id_ = getChatId(msg.chat_id_).ID,offset_ = 0,limit_ = 5000}, check_deactive, nil)
  end
----------------------------------------------------------------------------
if text:match("^[Rr]uadmin$") and is_sudo(msg) or text:match("^ادمینی$") and is_mod(msg) then
if msg.can_be_deleted_ == true then
if database:get("lang:gp:" .. msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, "I'm *Admin* !", 1, "md")
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, "من ادمین هستم !", 1, "md")
end
elseif database:get("lang:gp:" .. msg.chat_id_) then
bot.sendMessage(msg.chat_id_, msg.id_, 1, "I'm *Not Admin* !", 1, "md")
else
bot.sendMessage(msg.chat_id_, msg.id_, 1, "من ادمین نیستم !", 1, "md")
end
end
----------------------------------------------------------------------------

----------------------------------------------------------------------------
if text and text:match("^date$") then
local url , res = http.request('http://probot.000webhostapp.com/api/time.php/')
if res ~= 200 then return bot.sendMessage(msg.chat_id_, msg.id_, 1, '> Error 404 :|', 1, 'html')
end
local jdat = json:decode(url)
if jdat.L == "0" then
jdat_L = 'خیر'
elseif jdat.L == "1" then
jdat_L = 'بله'
end
local text = '↫ ساعت : <code>'..jdat.Stime..'</code>\n\n↫ تاریخ : <code>'..jdat.FAdate..'</code>\n\n↫ تعداد روز های ماه جاری : <code>'..jdat.t..'</code>\n\n↫ عدد روز در هفته : <code>'..jdat.w..'</code>\n\n↫ شماره ی این هفته در سال : <code>'..jdat.W..'</code>\n\n↫ نام باستانی ماه : <code>'..jdat.p..'</code>\n\n↫ شماره ی ماه از سال : <code>'..jdat.n..'</code>\n\n↫ نام فصل : <code>'..jdat.f..'</code>\n\n↫ شماره ی فصل از سال : <code>'..jdat.b..'</code>\n\n↫ تعداد روز های گذشته از سال : <code>'..jdat.z..'</code>\n\n↫ در صد گذشته از سال : <code>'..jdat.K..'</code>\n\n↫ تعداد روز های باقیمانده از سال : <code>'..jdat.Q..'</code>\n\n↫ در صد باقیمانده از سال : <code>'..jdat.k..'</code>\n\n↫ نام حیوانی سال : <code>'..jdat.q..'</code>\n\n↫ شماره ی قرن هجری شمسی : <code>'..jdat.C..'</code>\n\n↫ سال کبیسه : <code>'..jdat_L..'</code>\n\n↫ منطقه ی زمانی تنظیم شده : <code>'..jdat.e..'</code>\n\n↫ اختلاف ساعت جهانی : <code>'..jdat.P..'</code>\n\n↫ اختلاف ساعت جهانی به ثانیه : <code>'..jdat.A..'</code>\n\n<b>➢</b> Ch : '..botchannel..''
bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
--------------------
if text and text:match("^[Ee]id$") then
local url , res = http.request('http://probot.000webhostapp.com/api/time.php/')
if res ~= 200 then return bot.sendMessage(msg.chat_id_, msg.id_, 1, '> Error 404 :|', 1, 'html')
end
local jdat = json:decode(url)
if jdat.L == "0" then
jdat_L = 'خیر'
elseif jdat.L == "1" then
jdat_L = 'بله'
end
local text = '•• اطلاعات تکمیلی عید نوروز\n\n• تعداد روز های گذشته از سال : <code>'..jdat.z..'</code>\n• در صد گذشته از سال : <code>'..jdat.K..'</code>\n• تعداد روز های باقیمانده تا عید : <code>'..jdat.Q..'</code>\n• در صد باقیمانده از سال : <code>'..jdat.k..'</code>\n\n<b>➢</b> Ch : '..botchannel..''
bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
---------------------------------------------------------------------------------------------
if text and text:match("^([Ww][Ee][Aa][Tt][Hh][Ee][Rr]) (.*)$") or text:match("^(هوا) (.*)$") then
MatchesEN = {text:match("^([Ww][Ee][Aa][Tt][Hh][Ee][Rr]) (.*)$")}; MatchesFA = {text:match("^(هوا) (.*)$")}
Ptrn = MatchesEN[2] or MatchesFA[2]
local function temps(K)
local F = (K*1.8)-459.67
local C = K-273.15
return F,C
end

local url , res = http.request("http://api.openweathermap.org/data/2.5/weather?q="..URL.escape(Ptrn).."&appid=269ed82391822cc692c9afd59f4aabba")
if res ~= 200 then return end
if not url then
return
end
if not json:decode(url) then
return
end
local jtab = json:decode(url)
if jtab.name then
if jtab.weather[1].main == "Thunderstorm" then
status = "⛈طوفاني"
elseif jtab.weather[1].main == "Drizzle" then
status = "🌦نمنم باران"
elseif jtab.weather[1].main == "Rain" then
status = "🌧باراني"
elseif jtab.weather[1].main == "Snow" then
status = "🌨برفي"
elseif jtab.weather[1].main == "Atmosphere" then
status = "🌫مه - غباز آلود"
elseif jtab.weather[1].main == "Clear" then
status = "🌤️صاف"
elseif jtab.weather[1].main == "Clouds" then
status = "☁️ابري"
elseif jtab.weather[1].main == "Extreme" then
status = "-------"
elseif jtab.weather[1].main == "Additional" then
status = "-------"
else
status = "-------"
end
local F1,C1 = temps(jtab.main.temp)
local F2,C2 = temps(jtab.main.temp_min)
local F3,C3 = temps(jtab.main.temp_max)
if jtab.rain then
rain = jtab.rain["3h"].." ميليمتر"
else
rain = "-----"
end
if jtab.snow then
snow = jtab.snow["3h"].." ميليمتر"
else
snow = "-----"
end
			today = "نام شهر : *"..jtab.name.."*\n"
			.."کشور : *"..(jtab.sys.country or "----").."*\n"
			.."وضعیت هوا :\n"
			.."   `"..C1.."° درجه سانتيگراد (سلسيوس)`\n"
			.."   `"..F1.."° فارنهايت`\n"
			.."   `"..jtab.main.temp.."° کلوين`\n"
			.."هوا "..status.." ميباشد\n\n"
			.."حداقل دماي امروز: `C"..C2.."°   F"..F2.."°   K"..jtab.main.temp_min.."°`\n"
			.."حداکثر دماي امروز: `C"..C3.."°   F"..F3.."°   K"..jtab.main.temp_max.."°`\n"
			.."رطوبت هوا: `"..jtab.main.humidity.."%`\n"
			.."مقدار ابر آسمان: `"..jtab.clouds.all.."%`\n"
			.."سرعت باد: `"..(jtab.wind.speed or "------").." متر بر ثانیه`\n"
			.."جهت باد: `"..(jtab.wind.deg or "------").."° درجه`\n"
			.."فشار هوا: `"..(jtab.main.pressure/1000).." بار(اتمسفر)`\n"
			.."بارندگي 3ساعت اخير: `"..rain.."`\n"
			.."بارش برف 3ساعت اخير: `"..snow.."`\n\n"
			after = ""
			local res = http.request("http://api.openweathermap.org/data/2.5/forecast?q="..URL.escape(Ptrn).."&appid=269ed82391822cc692c9afd59f4aabba")
			local jtab = json:decode(res)
			for i=1,5 do
				local F1,C1 = temps(jtab.list[i].main.temp_min)
				local F2,C2 = temps(jtab.list[i].main.temp_max)
				if jtab.list[i].weather[1].main == "Thunderstorm" then
					status = "⛈طوفانی"
				elseif jtab.list[i].weather[1].main == "Drizzle" then
					status = "🌦نمنم باران"
				elseif jtab.list[i].weather[1].main == "Rain" then
					status = "🌧بارانی"
				elseif jtab.list[i].weather[1].main == "Snow" then
					status = "🌨برفی"
				elseif jtab.list[i].weather[1].main == "Atmosphere" then
					status = "🌫مه - غباز آلود"
				elseif jtab.list[i].weather[1].main == "Clear" then
					status = "🌤️صاف"
				elseif jtab.list[i].weather[1].main == "Clouds" then
					status = "☁️ابری"
				elseif jtab.list[i].weather[1].main == "Extreme" then
					status = "-------"
				elseif jtab.list[i].weather[1].main == "Additional" then
					status = "-------"
				else
					status = "-------"
				end
				if i == 1 then
					day = "فردا هوا "
				elseif i == 2 then
					day = "پس فردا هوا "
				elseif i == 3 then
					day = "3 روز بعد هوا "
				elseif i == 4 then
					day ="4 روز بعد هوا "
				elseif i == 5 then
					day = "5 روز بعد هوا "
				end
				after = after.."- "..day..status.." ميباشد. \n🔺`C"..C2.."°`  *-*  `F"..F2.."°`\n🔻`C"..C1.."°`  *-*  `F"..F1.."°`\n"
			end
			Text = today.."وضعيت آب و هوا در پنج روز آينده:\n"..after
			bot.sendMessage(msg.chat_id_, msg.id_, 1, Text, 1, 'md')
		else
			Text = "مکان وارد شده صحیح نمیباشد."
			bot.sendMessage(msg.chat_id_, msg.id_, 1, Text, 1, 'md')
		end
	end
	-----------------------------------------------------------------

----------------------------------------------------------------------------
end -- end check mute
 -- edit and updated by : @MinuteMen
end -- end text
 -- edit and updated by : @MinuteMen
end  -- end is_supergroup
 -- edit and updated by : @MinuteMen
end -- end function
----------------------------------------------------------------------------
function tdcli_update_callback(data)
if (data.ID == "UpdateNewMessage") then
run(data.message_,data)
elseif (data.ID == "UpdateMessageEdited") then
data = data
local function edited_cb(extra,result,success)
run(result,data)
end
tdcli_function ({
ID = "GetMessage",
chat_id_ = data.chat_id_,
message_id_ = data.message_id_
}, edited_cb, nil)
elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
tdcli_function ({
ID="GetChats",
offset_order_="9223372036854775807",
offset_chat_id_=0,
limit_=20
}, dl_cb, nil)
end
end
