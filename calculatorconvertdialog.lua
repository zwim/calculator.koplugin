--[[--
This widget displays the calculator convert menu
]]

local ButtonDialogTitle = require("ui/widget/buttondialogtitle")
local CalculatorUnitsDialog = require("calculatorunitsdialog")
local Font = require("ui/font")
local InputContainer = require("ui/widget/container/inputcontainer")
local Size = require("ui/size")
local UIManager = require("ui/uimanager")
local _ = require("gettext")
local Screen = require("device").screen
local ffiUtil = require("ffi/util")
local logger = require("logger")

local length_table = {
    {"nm",1e-9},
    {"µm",1e-6},
    {"mm",1e-3},
    {"cm",1e-2},
    {"dm",1e-1},
    {"m",1},
    {"km",1e3},
    {"Mm",1e6},
    {"inch",0.0254},
    {"foot",0.3048},
    {"yard",0.9144},
    {"mile",1609.344},
    {"AE",149597870700},
    {"LightYear",9460730472580800},
    {"parsec",3.0857e16},
}

local mass_table = {
    {"µg",1e-9},
    {"mg",1e-6},
    {"g",1e-3},
    {"dag",1e-2},
    {"kg",1},
    {"t",1e3},
    {"oz",28.349523125e-3},
    {"lb",453.59237e-3},
    {"st",6.35029318},
}

local time_table = {
    {"ns",1e-9},
    {"µs",1e-6},
    {"ms",1e-3},
    {"s",1},
    {"min",60},
    {"h",3600},
    {"day",3600*24},
    {"week",3600*24*7},
    {"month",3600*24*30},
    {"year",3600*24*365.2425},
}

local energy_table = {
    {"J",1},
    {"kJ",1e3},
    {"MJ",1e6},
    {"kWh",1e3*3600},
    {"cal",4.1858},
    {"kCal",4186.6},
    {"BTU",1055.05585262},
}

local power_table = {
    {"W",1},
    {"kW",1e3},
    {"MW",1e6},
    {"cal/s",1/4.1858},
    {"PS",735.5},
    {"BTU/h",293.07107017},
}

local CalculatorConvertDialog = InputContainer:new{
    is_always_active = true,
    title = _("Convert"),
    modal = true,
    width = math.floor(Screen:getWidth() * 0.8),
    face = Font:getFace("cfont", 22),
    title_face = Font:getFace("x_smalltfont"),
    title_padding = Size.padding.default,
    title_margin = Size.margin.title,
    text_face = Font:getFace("smallinfofont"),
    button_padding = Size.padding.default,
    border_size = Size.border.window,
}

function CalculatorConvertDialog:init()
    local convert_buttons = {
        ["01_length"] = {
            text = " Length",
            callback = function()
                UIManager:close(self)
                self.units_dialog = CalculatorUnitsDialog:new{
                    parent = self,
                    units = length_table,
                    }
                UIManager:show(self.units_dialog)
            end,
        },
        ["02_mass"] = {
            text = ("Mass"),
            is_enter_default = true,
            callback = function()
                UIManager:close(self)
                self.units_dialog = CalculatorUnitsDialog:new{
                    parent = self,
                    units = mass_table,
                    }
                UIManager:show(self.units_dialog)
            end,
        },
        ["03_time"] = {
            text = _("Time"),
            callback = function()
                UIManager:close(self)
                self.units_dialog = CalculatorUnitsDialog:new{
                    parent = self,
                    units = time_table,
                    }
                UIManager:show(self.units_dialog)
            end,
        },
        ["04_energy"] = {
            text = _("Energy"),
            callback = function()
                UIManager:close(self)
                self.units_dialog = CalculatorUnitsDialog:new{
                    parent = self,
                    units = energy_table,
                    }
                UIManager:show(self.units_dialog)
            end,
        },
        ["05_power"] = {
            text = _("Power"),
            callback = function()
                UIManager:close(self)
                self.units_dialog = CalculatorUnitsDialog:new{
                    parent = self,
                    units = power_table,
                    }
                UIManager:show(self.units_dialog)
            end,
        },
        ["99_close"] = {
            text = "✕", --close
            callback = function()
                UIManager:close(self)
            end,
        },
    }

    local highlight_buttons = {{}}
    local columns = 2
    for idx, button in ffiUtil.orderedPairs(convert_buttons) do
        if #highlight_buttons[#highlight_buttons] >= columns then
            table.insert(highlight_buttons, {})
        end
        table.insert(highlight_buttons[#highlight_buttons], button)
        logger.dbg("ReaderHighlight", idx..": line "..#highlight_buttons..", col "..#highlight_buttons[#highlight_buttons])
    end

    self[1] = ButtonDialogTitle:new{
        title = _("♺ Convert"),
        buttons = highlight_buttons,
    }

end


function CalculatorConvertDialog:onShow()
    UIManager:setDirty(self, function()
        return "ui", self.dimen
    end)
end

function CalculatorConvertDialog:onClose()
    UIManager:setDirty(nil, function()
        return "ui", self[1][1].dimen
    end)
end

return CalculatorConvertDialog