--[[
This plugin provides a sophisicated calculator
]]

local DataStorage = require("datastorage")
local Dispatcher = require("dispatcher")
local Font = require("ui/font")
local InfoMessage = require("ui/widget/infomessage")
local InputDialog = require("ui/widget/inputdialog")
--local TextViewer = require("ui/widget/textviewer")
local Trapper = require("ui/trapper")
local UIManager = require("ui/uimanager")
local Util = require("util")
local VirtualKeyboard = require("ui/widget/virtualkeyboard")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local lfs = require("libs/libkoreader-lfs")
local logger = require("logger")
local util = require("ffi/util")
local _ = require("gettext")

local EXTERNAL_PLUGIN = DataStorage:getDataDir() .. "/plugins/calculator.koplugin/formulaparser"
if lfs.attributes(EXTERNAL_PLUGIN, "mode") == "directory" then
    package.path = string.format("%s/?.lua;%s", EXTERNAL_PLUGIN, package.path)
end

local CalculatorSettingsDialog = require("calculatorsettingsdialog")
local Parser = require("formulaparser")

local VERSION_FILE = DataStorage:getDataDir() .. "/plugins/calculator.koplugin/VERSION"
local LATEST_VERSION = "https://raw.githubusercontent.com/zwim/calculator.koplugin/master/VERSION"

local Calculator = WidgetContainer:new{
    name = "calculator",
    is_doc_only = false,
    dump_file = util.realpath(DataStorage:getDataDir()) .. "/output.calc",
    init_file = util.realpath(DataStorage:getDataDir()) .. "/init.calc",
    history = "",
    i_num = 1, -- number of next input
    input = {},
    angle_mode = "degree", -- don't translate
    angle_modes = {
            {"radiant", _("Radiant")},
            {"degree", _("Degree")},
            {"gon", _("Gon")},
        },
    number_format = "auto", -- don't translate
    number_formats = {
            {"scientific", _("Scientific")},
            {"engineer", _("Engineer")},
            {"auto", _("Auto")},
            {"programmer", _("Programmer")},
            {"native", _("Native")},
        },
    round_places = 5, -- decimal places
    lower_bound = 5, -- switch to scientific if <=10^lower_bound
    upper_bound = 6 -- switch to scientific if >=10^upper_bound
}

function Calculator:init()
    self:onDispatcherRegisterActions()
    self.ui.menu:registerToMainMenu(self)
end

function Calculator:addKeyboard()
    VirtualKeyboard.lang_to_keyboard_layout[_"Calculator"] = "calc_keyboard"
    VirtualKeyboard.layout_file = "calc_keyboard"
    self.original_keyboard_layout = G_reader_settings:readSetting("keyboard_layout")
    G_reader_settings:saveSetting("keyboard_layout", "Calculator")
end

function Calculator:restoreKeyboard()
    VirtualKeyboard.lang_to_keyboard_layout[_"Calculator"] = nil
    VirtualKeyboard.layout_file = nil

    G_reader_settings:saveSetting("keyboard_layout", self.original_keyboard_layout)
end

function Calculator:gotoEnd()
    local pos = #self.input_dialog._input_widget.charlist
    self.input_dialog._input_widget:moveCursorToCharPos(pos + 1)
end

function Calculator:addToMainMenu(menu_items)
    menu_items.calculator = {
        text = _("Calculator"),
        sorting_hint = "more_tools",
        keep_menu_open = true,
        callback = function()
            self:onCalculatorStart()
        end,
    }
end

function Calculator:onDispatcherRegisterActions()
    Dispatcher:registerAction("show_calculator", { category = "none", event = "CalculatorStart", title = _("Show calculator"), device = true, })
end

function Calculator:getString(format, table)
    for _, v in pairs(table) do
        if v[1] == format then
           return v[2]
        end
    end
    return "default"
end

function Calculator:getStatusLine()
    local angle_mode = Parser:eval(Parser:parse("getAngleMode()"))
    angle_mode = self:getString(angle_mode, self.angle_modes)
    angle_mode = angle_mode .. (" "):rep(9-#angle_mode)
    local format = self:getString(self.number_format, self.number_formats)
    format = format .. (" "):rep(12-#format)
    return string.format(_("Angle: %s Format: %s Round: %d"),
        angle_mode, format, self.round_places)
end

function Calculator:onCalculatorStart()
    self.angle_mode = G_reader_settings:readSetting("calculator_angle_mode") or self.angle_mode
    self.number_format = G_reader_settings:readSetting("calculator_number_format") or self.number_format
    self.round_places = G_reader_settings:readSetting("calculator_round_places") or self.round_places

    self:addKeyboard()

    if self.angle_mode ~= Parser:eval(Parser:parse("getAngleMode()")) then
        if self.angle_mode == "radiant" then
            Parser:eval(Parser:parse("setrad()"))
        elseif self.angle_mode == "degree" then
            Parser:eval(Parser:parse("setdeg()"))
        else
            Parser:eval(Parser:parse("setgon()"))
        end
    end

    self.status_line = self.status_line or self:getStatusLine()

    local hint = _("Enter your calculations or\ntype 'help()' and press 'Calc'")
    local current_version = self:getCurrentVersion()
    local latest_version = self:getLatestVersion(LATEST_VERSION, 20, 60)
    if latest_version and current_version and latest_version > current_version then
        hint = hint .. "\n\n" .. _("A calculator update is available:") .. "\n"
        if current_version then
            hint = hint .. "Current-" .. current_version
        end
        if latest_version then
            hint = hint .. "Latest-" .. latest_version
        end
    end
    self.input_dialog = InputDialog:new{
        title =  _("Calculator"),
        input_hint = hint,
        description = self.status_line,
        description_face= Font:getFace("scfont"),
        input = self.history,
        input_face = Font:getFace("scfont"),
        para_direction_rtl = false, -- force LTR
        input_type = "string",
        allow_newline = false,
        cursor_at_end = true,
        fullscreen = true,
        lang = "Calculator",
        buttons = {{
            {
            text = _("Calc"),
            is_enter_default = true,
            callback = function()
                Trapper:wrap(function()
                    self:calculate(self.input_dialog:getInputText())
                end)
                self.input_dialog:setInputText(self.history)
                self:gotoEnd()
            end,
            },
            {
            text = _("Clear"),
            callback = function()
                Parser:eval("kill()")
                self.history = ""
                self.input = {}
                self.input_dialog:setInputText("")
            end,
            },
            {
            text = _("Load"),
            callback = function()
                self:load(self.init_file)
            end,
            },
            {
            text = _("Save"),
            callback = function()
                self:dump(self.dump_file)
            end,
            },
            {
            text = "☰", -- settings menu
            callback = function ()
                self.settings_dialog = CalculatorSettingsDialog:new{
                    parent = self,
                }
                UIManager:show(self.settings_dialog)
            end,
            },
            {
            text = _("Close"),
            callback = function()
                self:restoreKeyboard()
                UIManager:close(self.input_dialog)
            end,
            },
        }},
        enter_callback = function()
                Trapper:wrap(function()
                    self:calculate(self.input_dialog:getInputText())
                end)
                self.input_dialog:setInputText(self.history)
                self:gotoEnd()
        end,
        -- Set/save view and cursor position callback
        view_pos_callback = function(top_line_num, charpos)
            -- This same callback is called with no argument to get initial position,
            -- and with arguments to give back final position when closed.
            if top_line_num and charpos then
                self.book_style_tweak_last_edit_pos = {top_line_num, charpos}
            else
                local prev_pos = self.book_style_tweak_last_edit_pos
                if type(prev_pos) == "table" and prev_pos[1] and prev_pos[2] then
                    return prev_pos[1], prev_pos[2]
                end
                return nil, nil -- no previous position known
            end
        end,
    }
    UIManager:show(self.input_dialog)
    self.input_dialog:onShowKeyboard(true)
end

function Calculator:load(file_name)
    local file = io.open(file_name, "r")
    if file then
        local line = file:read()
        while line do
           Parser:eval(line)
           line = file:read()
        end
        file:close()
    else
        logger.warn("Failed to load file from " ..file_name )
    end
end

function Calculator:dump(file_name)
    local file = io.open(file_name, "w")
    if file then
        for i = 1, #self.input do
            if self.input[i] then
                file:write("/*i" .. i .. ":*/ " .. self.input[i] .. "\n")
                file:write("/*o" .. i .. ":   " .. tostring(Parser:eval("o" .. i)) .. " */\n")
            end
        end
        file:close()
    else
        logger.warn("Failed to dump calculator output to " .. file_name)
    end
end

function Calculator:insertBraces(str)
    local function_names={"exp", "sin", "cos", "tan", "asin", "acos", "atan", "ln", "ld", "log", "sqrt", "√", "rnd", "floor", "showvars"}
    str = str:gsub("EE","E")
    for _, func in pairs(function_names) do
        local _, pos = str:find("^" .. func .. "[^(]")
        if pos == 0 then
            _, pos = str:find("[^%a^d_]" .. func .. "[^(]")
        end
        while pos do
            str = str:sub(1, pos-1) .. "(" .. str:sub(pos)
            _, pos = str:find("[^%a^d_]" .. func .. "[^(]")
        end
    end
    local _, count_opening = str:gsub("%(", "")
    count_opening = count_opening or 0
    local _, count_closing = str:gsub("%)", "")
    count_closing = count_closing or 0
    str = str .. (")"):rep(count_opening-count_closing)
    return str
end

function Calculator:formatResult(val, format, round)
    if val == nil then
        return nil
    end

    local ret = tostring(val)
    if format == "native" then -- lua native format
        return ret
    end

    if ret == "true" or ret == "false" then
        return ret
    end

    if format == "scientific" or format == "engineer" then
        ret = string.format("%." .. round .. "E", val)
    elseif format == "auto" then
        if val == 0 then
            return "" .. 0
        elseif math.abs(val) >= 10^self.upper_bound or math.abs(val) <= 0.1^self.lower_bound then
            ret = string.format("%." .. round .. "E", val)
        else
            ret = "" .. math.floor(val * 10^self.round_places + 0.5)/(10^self.round_places)
        end
    end

    -- tidy result
    local repl
    repeat -- remove e.g. 1.400e+04 -> 1.4e+04
        ret, repl = ret:gsub("0E","E")
    until (repl == 0)
    ret = ret:gsub(".E","E") -- 1.E+04 -> 1E+04
    ret = ret:gsub("E%+00$","") -- 1.2E+00 -> 1.2

    if format == "programmer" then
        local tmp = string.format("%016X", val)
        for i = 16-4,4,-4 do
            tmp = tmp:sub(1,i) .. "'" .. tmp:sub(i+1)
        end
        ret = string.format("%15s  0x%s", ret, tmp)
    end

    return ret
end

-- uses two strings
--   self.history holds the old formulas and results
--   input_text holds the history and the new user entry
function Calculator:calculate(input_text)
    local history_table = Util.splitToArray(self.history, "\n", false)
    local input_table =  Util.splitToArray(input_text, "\n", false)
    local command_position = 1

    -- search first difference between history and input
    for i = 1,#input_table do
        if not history_table[i] or input_table[i] ~= history_table[i] then
            command_position = i
            break
        end
    end
    if command_position and input_table[command_position] then
        local new_command = input_table[command_position]
        new_command = Parser:greek2text(new_command)
        print()
        print()
        print()
        print()
        print()
        print(new_command)
        new_command = new_command:gsub("^[io][0-9]*: ","")  -- strip leading "ixxx: " or "oxxx: "
        new_command = self:insertBraces(new_command)

        local last_result, last_err = Parser:eval(new_command)

        if type(last_result) == "string" then
            self.history = input_text .. "\n" .. Parser:text2greek(last_result)
        elseif last_result ~= nil and not last_err then
            self.input[#self.input + 1] = new_command
            Parser:eval(Parser:parse("o" .. #self.input .. ":=" .. tostring(last_result))) -- last result is stored in "oxxx"
            Parser:eval(Parser:parse("ans:" .. tostring(last_result))) -- last result is stored in "ans"
            last_result = self:formatResult(last_result, self.number_format, self.round_places)

            if command_position ~= #input_table then  -- an old entry was changed
                self.history = input_text .. "\ni" .. #self.input .. ": " .. new_command
            else -- a new formula is entered
                local index = input_text:find("\n[^\n]*$")
                if not index then -- first entry
                    self.history = "i" .. #self.input .. ": " .. Parser:text2greek(new_command) .. " "
                else
                    self.history = input_text:sub(1,index) .. "i" .. #self.input .. ": " .. Parser:text2greek(new_command) .. " "
                end
            end
            self.history = self.history  .. "\no" .. #self.input .. ": " .. Parser:text2greek(tostring(last_result)) .. "\n"
        else
            self.history = input_text
            UIManager:show(InfoMessage:new{
                text = last_err or _("Input error"),
                })
        end
    end
end

function Calculator:getCurrentVersion()
    local file = io.open(VERSION_FILE, "r")
    local version
    if file then
        version = file:read("*a")
        file:close()
    else
        logger.warn("Did not find version file " .. VERSION_FILE )
    end
    return version
end

function Calculator:getLatestVersion(url, timeout, maxtime)
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local socket = require("socket")
    local socketutil = require("socketutil")
    local socket_url = require("socket.url")

    local parsed = socket_url.parse(url)

    local sink = {}
    socketutil:set_timeout(timeout or 10, maxtime or 30)
    local request = {
        url     = url,
        method  = "GET",
        sink    = maxtime and socketutil.table_sink(sink) or ltn12.sink.table(sink),
    }

    local code, headers, status = socket.skip(1, http.request(request))
    socketutil:reset_timeout()
    local content = table.concat(sink) -- empty or content accumulated till now

    if code == socketutil.TIMEOUT_CODE or
       code == socketutil.SSL_HANDSHAKE_CODE or
       code == socketutil.SINK_TIMEOUT_CODE
    then
        logger.warn("request interrupted:", code)
        return false, code
    end
    if headers == nil then
        logger.warn("No HTTP headers:", code, status)
        return false, "Network or remote server unavailable"
    end
    if not code or string.sub(code, 1, 1) ~= "2" then -- all 200..299 HTTP codes are OK
        logger.warn("HTTP status not okay:", code, status)
        return false, "Remote server error or unavailable"
    end
    if headers and headers["content-length"] then
        -- Check we really got the announced content size
        local content_length = tonumber(headers["content-length"])
        if #content ~= content_length then
            return false, "Incomplete content received"
        end
    end
    return content
end

return Calculator
