--[[--
This widget displays the calculator settings menu
]]

local Blitbuffer = require("ffi/blitbuffer")
local ButtonTable = require("ui/widget/buttontable")
local CenterContainer = require("ui/widget/container/centercontainer")
local Font = require("ui/font")
local FrameContainer = require("ui/widget/container/framecontainer")
local Geom = require("ui/geometry")
local HorizontalGroup = require("ui/widget/horizontalgroup")
local HorizontalSpan = require("ui/widget/horizontalspan")
local InputContainer = require("ui/widget/container/inputcontainer")
local LineWidget = require("ui/widget/linewidget")
local RadioButtonTable = require("ui/widget/radiobuttontable")
local Size = require("ui/size")
local TextWidget = require("ui/widget/textwidget")
local UIManager = require("ui/uimanager")
local VerticalGroup = require("ui/widget/verticalgroup")
local VerticalSpan = require("ui/widget/verticalspan")
local _ = require("gettext")
local Screen = require("device").screen

local Parser = require("formulaparser/formulaparser")

local CalculatorSettingsDialog = InputContainer:new{
    is_always_active = true,
    title = _("Calculator settings"),
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

function CalculatorSettingsDialog:init()
    -- Title & description
    self.title_widget = FrameContainer:new{
        padding = self.title_padding,
        margin = self.title_margin,
        bordersize = 0,
        TextWidget:new{
            text = self.title,
            face = self.title_face,
            max_width = self.width,
        }
    }
    self.title_bar = LineWidget:new{
        dimen = Geom:new{
            w = self.width,
            h = Size.line.thick,
        }
    }

    local buttons = {}
    local radio_buttons_angle = {}
    for _, v in pairs(self.parent.angle_modes) do
        table.insert(radio_buttons_angle, {
            {
            text = v[2],
            checked = self.parent.angle_mode == v[1],
            provider = v[1],
            },
        })
    end

    local radio_buttons_format = {}
    for _, v in pairs(self.parent.number_formats) do
        table.insert(radio_buttons_format, {
            {
            text = v[2],
            checked = self.parent.number_format == v[1],
            provider = v[1],
            },
        })
    end

    local radio_buttons_round = {}
    for i = 0,10 do
        table.insert(radio_buttons_round, {
            {
            text = i,
            checked = self.parent.round_places == i,
            provider = i,
            },
        })
    end

    table.insert(buttons, {
        {
            text = _("Cancel"),
            callback = function()
                UIManager:close(self.parent.settings_dialog)
            end,
        },
        {
            text = _("Save"),
            is_enter_default = true,
            callback = function()
                UIManager:close(self.parent.settings_dialog)
                local new_angle_mode = self.parent.settings_dialog.radio_button_table_angle.checked_button.provider
                if new_angle_mode ~= self.parent.angle_mode then
                    self.parent.angle_mode = new_angle_mode
                    if self.parent.angle_mode == "gon" then
                        Parser:eval(Parser:parse("setgon()"))
                    elseif self.parent.angle_mode == "degree" then
                        Parser:eval(Parser:parse("setdeg()"))
                    else
                        Parser:eval(Parser:parse("setrad()"))
                    end
                    G_reader_settings:saveSetting("calculator_angle_mode", new_angle_mode)
                    self.parent.status_line = self.parent:getStatusLine()
                end

                local new_format = self.parent.settings_dialog.radio_button_table_format.checked_button.provider
                if new_format ~= self.parent.number_format then
                    self.parent.number_format = new_format
                    G_reader_settings:saveSetting("calculator_number_format", new_format)
                    self.parent.status_line = self.parent:getStatusLine()
                end

                local new_round = self.parent.settings_dialog.radio_button_table_round.checked_button.provider
                if new_round ~= self.parent.round_places then
                    self.parent.round_places = new_round
                    G_reader_settings:saveSetting("calculator_round_places", new_round)
                    self.parent.status_line = self.parent:getStatusLine()
                end

                UIManager:close(self.parent.input_dialog)
                self.parent:onCalculatorStart()
            end,
        },
    })

    self.radio_button_table_angle = RadioButtonTable:new{
        radio_buttons = radio_buttons_angle,
        width = math.floor(self.width * 0.4),
        focused = true,
        scroll = false,
        parent = self,
        face = self.face,
    }

    self.radio_button_table_format = RadioButtonTable:new{
        radio_buttons = radio_buttons_format,
        width = math.floor(self.width * 0.4),
        focused = true,
        scroll = false,
        parent = self,
        face = self.face,
    }

    self.radio_button_table_round = RadioButtonTable:new{
        radio_buttons = radio_buttons_round,
        width = math.floor(self.width * 0.4),
        focused = true,
        scroll = false,
        parent = self,
        face = self.face,
    }

    -- Buttons Table
    self.button_table = ButtonTable:new{
        width = self.width - 2*self.button_padding,
        button_font_face = "cfont",
        button_font_size = 20,
        buttons = buttons,
        zero_sep = true,
        show_parent = self,
    }

    self.dialog_frame = FrameContainer:new{
        radius = Size.radius.window,
        bordersize = Size.border.window,
        padding = 0,
        margin = 0,
        background = Blitbuffer.COLOR_WHITE,
        VerticalGroup:new{
            align = "center",
            self.title_widget,
            self.title_bar,
            HorizontalGroup:new{
                    dimen = Geom:new{
                    w = self.title_bar:getSize().w,
                    h = self.radio_button_table_round:getSize().h,
                },
                VerticalGroup:new{ -- angle and format
                    align = "center",
                    TextWidget:new{
                        text = _("Angle"),
                        face =  self.text_face,
                    },
                    VerticalSpan:new{width = Size.span.vertical_large*2},
                    CenterContainer:new{
                        dimen = Geom:new{
                            w = self.title_bar:getSize().w * 0.4,
                            h = self.radio_button_table_angle:getSize().h,
                        },
                        self.radio_button_table_angle,
                    },
                    VerticalSpan:new{width = Size.span.vertical_large*6},
                    TextWidget:new{
                        text = _("Number format"),
                        face =  self.text_face,
                    },
                    CenterContainer:new{
                        dimen = Geom:new{
                            w = self.title_bar:getSize().w * 0.4,
                            h = self.radio_button_table_format:getSize().h,
                        },
                        self.radio_button_table_format,
                    },
                },
                HorizontalSpan:new{width=self.title_bar:getSize().w * 0.1},
                VerticalGroup:new{ -- rounding
                    align = "center",
                    -- round
                    TextWidget:new{
                        text = _("Rounding"),
                        face =  self.text_face,
                    },

                    CenterContainer:new{
                        dimen = Geom:new{
                            w = self.title_bar:getSize().w * 0.4,
                            h = self.radio_button_table_round:getSize().h,
                        },
                        self.radio_button_table_round,
                    },
                },
            },

            VerticalSpan:new{width = Size.span.vertical_large*2},
            -- buttons
            CenterContainer:new{
                dimen = Geom:new{
                    w = self.title_bar:getSize().w,
                    h = self.button_table:getSize().h,
                },
                self.button_table,
            }
        }
    }

    self[1] = CenterContainer:new{
        dimen = Geom:new{
            w = Screen:getWidth(),
            h = Screen:getHeight(),
        },
        self.dialog_frame,
    }
end

function CalculatorSettingsDialog:onShow()
    UIManager:setDirty(self, function()
        return "ui", self.dialog_frame.dimen
    end)
end

function CalculatorSettingsDialog:onCloseWidget()
    UIManager:setDirty(nil, function()
        return "ui", self[1][1].dimen
    end)
end

return CalculatorSettingsDialog
