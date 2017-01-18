do

----------------------- --PlistsFunction
local function plugin_enabled( name )
  for k,v in pairs(_config.enabled_plugins) do
    if name == v then
      return k
    end
  end
  return false
end

local function disable_plugin( name, chat )
  local k = plugin_enabled(name)
  if not k then
    return
  end
  table.remove(_config.enabled_plugins, k)
  save_config( )
end

local function enable_plugin( plugin_name )
  if plugin_enabled(plugin_name) then
    return disable_plugin( name, chat )
  end
    table.insert(_config.enabled_plugins, plugin_name)
    save_config()
end

local function plugin_exists( name )
  for k,v in pairs(plugins_names()) do
    if name..'.lua' == v then
      return true
    end
  end
  return false
end
  
local function reload_plugins( )
  plugins = {}
  load_plugins()
end

local function saveplug(extra, success, result)
  local msg = extra.msg
  local name = extra.name
  local receiver = get_receiver(msg)
  if success then
    local file = 'plugins/'..name..'.lua'
    print('File saving to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    enable_plugin(name)
    reload_plugins( )
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
----------------------- -PlistsFunction
-- Returns the key (index) in the config.enabled_plugins table
local function plugin_enabled( name )
  for k,v in pairs(_config.enabled_plugins) do
    if name == v then
      return k
    end
  end
  --if not found
  return false
end

-- Returns true if file exists in plugins folder
local function plugin_exists( name )
  for k,v in pairs(plugins_names()) do
    if name..'.lua' == v then
      return true
    end
  end
  return false
end

local function list_all_plugins(only_enabled)
  local text = ''
  local nsum = 0
  for k, v in pairs( plugins_names( )) do
    --  ✔ enabled, ❌ disabled
    local status = '❌'
    nsum = nsum+1
    nact = 0
    -- Check if is enabled
    for k2, v2 in pairs(_config.enabled_plugins) do
      if v == v2..'.lua' then 
        status = '✔' 
      end
      nact = nact+1
    end
    if not only_enabled or status == '✔' then
      -- get the name
      v = string.match (v, "(.*)%.lua")
      text = text..nsum..'. '..v..'  '..status..'\n'
    end
  end
  local text = text..'\n<b>There are '..nsum..' plugins installed.\n'..nact..' plugins enabled and '..nsum-nact..' disabled. </b>'
  return text
end

local function list_plugins(only_enabled)
  local text = ''
  local nsum = 0
  for k, v in pairs( plugins_names( )) do
    --  ✔ enabled, ❌ disabled
    local status = '❌'
    nsum = nsum+1
    nact = 0
    -- Check if is enabled
    for k2, v2 in pairs(_config.enabled_plugins) do
      if v == v2..'.lua' then 
        status = '✔' 
      end
      nact = nact+1
    end
    if not only_enabled or status == '✔' then
      -- get the name
      v = string.match (v, "(.*)%.lua")
      text = text..v..'  '..status..'\n'
    end
  end
  local text = text..'<b>\n'..nact..' plugins enabled from '..nsum..' plugins installed. </b>'
  return text
end

local function reload_plugins( )
  plugins = {}
  load_plugins()
  return "<b>Done ! </b>"
end


local function enable_plugin( plugin_name )
  print('checking if '..plugin_name..' exists')
  -- Check if plugin is enabled
  if plugin_enabled(plugin_name) then
    return '<b>Plugin '..plugin_name..' is enabled. </b>'
  end
  -- Checks if plugin exists
  if plugin_exists(plugin_name) then
    -- Add to the config table
    table.insert(_config.enabled_plugins, plugin_name)
    print(plugin_name..' added to _config table')
    save_config()
    -- Reload the plugins
    return reload_plugins( )
  else
    return '<b>Plugin '..plugin_name..' does not exists </b>'
  end
end

local function disable_plugin( name, chat )
  -- Check if plugins exists
  if not plugin_exists(name) then
    return '<b>Plugin '..name..' does not exists </b>'
  end
  local k = plugin_enabled(name)
  -- Check if plugin is enabled
  if not k then
    return '<b>Plugin '..name..' not enabled </b>'
  end
  -- Disable and reload
  table.remove(_config.enabled_plugins, k)
  save_config( )
  return reload_plugins(true)    
end

local function disable_plugin_on_chat(receiver, plugin)
  if not plugin_exists(plugin) then
    return "<b>Plugin doesn't exists </b>"
  end

  if not _config.disabled_plugin_on_chat then
    _config.disabled_plugin_on_chat = {}
  end

  if not _config.disabled_plugin_on_chat[receiver] then
    _config.disabled_plugin_on_chat[receiver] = {}
  end

  _config.disabled_plugin_on_chat[receiver][plugin] = true

  save_config()
  return '<b>Plugin '..plugin..' disabled on this chat </b>'
end

local function reenable_plugin_on_chat(receiver, plugin)
  if not _config.disabled_plugin_on_chat then
    return '<b>There aren\'t any disabled plugins </b>'
  end

  if not _config.disabled_plugin_on_chat[receiver] then
    return '<b>There aren\'t any disabled plugins for this chat </b>'
  end

  if not _config.disabled_plugin_on_chat[receiver][plugin] then
    return '<b>This plugin is not disabled </b>'
  end

  _config.disabled_plugin_on_chat[receiver][plugin] = false
  save_config()
  return '<b>Plugin '..plugin..' is enabled again </b>'
end
----------------------- -RmsgFunction
local function history(extra, suc, result)
  for i=1, #result do
    delete_msg(result[i].id, ok_cb, false)
  end
  if tonumber(extra.con) == #result then
    send_msg(extra.chatid, '[ '..#result..' ] Messages Of Supergroup Removed', ok_cb, false)
  else
    send_msg(extra.chatid, 'Messages Removed', ok_cb, false)
  end
end
------------------------
local function savefile(extra, success, result)
  local msg = extra.msg
  local name = extra.name
  local adress = extra.adress
  local receiver = get_receiver(msg)
  if success then
    local file = './'..adress..'/'..name..''
    print('File saving to:', result)
    os.rename(result, file)
    print('File moved to:', file)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
------------------------
local function reload_plugins( )
  plugins = {}
  load_plugins()
end
-------------------------
function run(msg, matches) 
--------------------------
if matches[1] == 'addplugin' and is_sudo(msg) then
   name = matches[2]
   text = matches[3]
   file = io.open("./plugins/"..name.lua, "w")
   file:write(text)
   file:flush()
   file:close()
   return "Add plugin successful"
end
   -------------SendPL-------------
if matches[1] == "send" and is_sudo(msg) then
   receiver = get_receiver(msg)
      reply_document(msg.id, "./plugins/"..matches[2]..".lua", ok_cb, false)
      reply_document(msg.id, "./plugins/"..matches[2], ok_cb, false)
end
-------------DelPL-----------
if matches[1] == "delplug" and is_sudo(msg) then
			text = io.popen("cd plugins && rm "..matches[2]..".lua")
				reply_msg(msg['id'], "Plugin "..matches[2].." Successfully Deleted.", ok_cb, false)
			return text
end 
-----------SavePL---------
if matches[1] == "save" and matches[2] and is_sudo(msg) then
    local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
     local name = matches[2]
     load_document(msg.reply_id, saveplug, {msg=msg,name=name})
      return reply_msg(msg.reply_id, 'Plugin '..name..' has been saved.', ok_cb, false)
    end
end
----------CPU----------
    if matches[1] == "cpu" and is_sudo(msg) then
			text = io.popen("cat /proc/cpuinfo"):read('*all')
			return text
		end 
----------Plist----------
  if matches[1] == 'plist' and is_sudo(msg) then
    return list_all_plugins()
  end
  -- Enable a plugin
  if matches[1] == 'pl' and  matches[2] == '+' and is_sudo(msg) then
    local plugin_name = matches[3]
    print("enable: "..matches[3])
    return enable_plugin(plugin_name)
  end
  -- Disable a plugin
  if matches[1] == 'pl' and  matches[2] == '-' and is_sudo(msg) then 
    if matches[3] == 'plugins' then
    	return '<b>This plugin can\'t be disabled </b>'
    end
    print("disable: "..matches[3])
    return disable_plugin(matches[3])
  end
----------RMSG----------
  if matches[1] == 'rmsg' and is_owner(msg) then
    if msg.to.type == 'channel' then
      if tonumber(matches[2]) > 1000 or tonumber(matches[2]) < 1 then
        return reply_msg(msg['id'], "You Can Use [1-1000] For Remove Messages", ok_cb, false)
      end
      get_history(msg.to.peer_id, matches[2] + 1 , history , {chatid = msg.to.peer_id, con = matches[2]})
    else
      return reply_msg(msg['id'], "You Can Use It Only In SuperGroup", ok_cb, false)
    end
  else
    return ""
  end
---------SaveFile----------
if matches[1] == "file" and matches[2] and matches[3] and is_sudo(msg) then
    local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
    local adress = matches[2]
    local name = matches[3]
      load_document(msg.reply_id, savefile, {msg=msg,name=name,adress=adress})
      return 'File '..name..' has been saved in: \n./'..adress
    end
  if not is_sudo(msg) then
    return "only for sudo!"
  end
end
---------SaveFile----------
if matches[1] == "reload" then
      reload_plugins(true)
      return "<b>reloaded</b>"
      end
---------------------------
end
end
return {               
patterns = {
   "^[#!/](addplugin) (.+) (.*)$",
   "^[#!/](send) (.*)$",
   "^[#!/](delplug) (.*)$",
   "^[#!/](save) (.*)$",
   "^[#!/](cpu)$",
   "^[#!/](reload)$",
   "^[#!/](plist)$",
   "^[#!/](pl) (+) (.*)$",
   "^[#!/](pl) (-) (.*)$",
   "^[#!/](rmsg) (%d*)$",
   "^[#!/](file) (.*) (.*)$",
 }, 
run = run,
}
