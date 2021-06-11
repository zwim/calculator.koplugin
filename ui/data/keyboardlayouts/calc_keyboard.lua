--[[
    Keyboard layout for calculator
]]


print("xxxxxxxxxx")
print("xxxxxxxxxx")
print("xxxxxxxxxx")
print("xxxxxxxxxx")
print("xxxxxxxxxx")
print("xxxxxxxxxx")
print("xxxxxxxxxx")
print("xxxxxxxxxx")
print("xxxxxxxxxx")


local calc_popup = {
   _a_ = {
        "a",
        north = "A",
        northeast = "alpha",
        east = "α",
    },
   _b_ = {
        "b",
        north = "B",
        northeast = "beta",
        east = "β",
    },
   _c_ = {
        "c",
        north = "C",
        northeast = "chi",
        east = "χ",
    },
   _d_ = {
        "d",
        north = "D",
        northeast = "delta",
        east = "δ",
    },
   _e_ = {
        "e",
        north = "E",
        northeast = "epsilon",
        east = "ε",
    },
   _f_ = {
        "f",
        north = "F",
        northeast = "phi",
        east = "φ",
    },
   _g_ = {
        "g",
        north = "G",
        northeast = "gamma",
        east = "γ",
    },
   _h_ = {
        "h",
        north = "H",
    },
   _i_ = {
        "i",
        north = "I",
        northeast = "iota",
        east = "ι",
    },
   _j_ = {
        "j",
        north = "J",
    },
   _k_ = {
        "k",
        north = "K",
        northeast = "kappa",
        east = "ϰ",
    },
    _l_ = {
        "l",
        north = "L",
        northeast = "lambda",
        east = "λ",
    },
   _m_ = {
        "m",
        north = "M",
        northeast = "my",
        east = "µ",
    },
   _n_ = {
        "n",
        north = "N",
        northeast = "ny",
        east = "ν",
    },
   _o_ = {
        "o",
        north = "O",
    },
   _p_ = {
        "p",
        north = "P",
        northeast = "pi",
        east = "π",
        northwest = "psi",
        west =  "ψ",
    },
   _q_ = {
        "q",
        north = "Q",
    },
   _r_ = {
        "r",
        north = "R",
        northeast = "rho",
        east = "ρ",
    },
   _s_ = {
        "s",
        north = "S",
        northeast = "sigma",
        east = "σ",
        northwest = "Sigma",
        west = "Σ",
    },
   _t_ = {
        "t",
        north = "T",
        northeast = "tau",
        east = "τ",
        northwest = "thita",
        west= "ϑ"
    },
   _u_ = {
        "u",
        north = "U",
    },
   _v_ = {
        "v",
        north = "V",
    },
   _w_ = {
        "w",
        north = "W",
        northeast = "omega",
        east = "ω",
    },
   _x_ = {
        "x",
        north = "X",
        northeast = "xi",
        east = "x",
    },
   _y_ = {
        "y",
        north = "Y",
    },
   _z_ = {
        "z",
        north = "Z",
        northeast = "zeta",
        east = "ζ",
    },
    _eq = {
        "=",
        north = "!=",
        northeast = ">",
        northwest = "<",
        east = ">=",
        west = "<=",
        south = "==",
        southeast = "≥xxx",
        southwest = "≤xxx",
    },
    _vl = {
        ":=",
        north = "=",
        northeast = "-=",
        northwest = "+=",
        east = "",
        west = "",
        south = "%=",
        southeast = "/=",
        southwest = "*=",
    },
}

local _a_ = calc_popup._a_
local _b_ = calc_popup._b_
local _c_ = calc_popup._c_
local _d_ = calc_popup._d_
local _e_ = calc_popup._e_
local _f_ = calc_popup._f_
local _g_ = calc_popup._g_
local _h_ = calc_popup._h_
local _i_ = calc_popup._i_
local _j_ = calc_popup._j_
local _k_ = calc_popup._k_
local _l_ = calc_popup._l_
local _m_ = calc_popup._m_
local _n_ = calc_popup._n_
local _o_ = calc_popup._o_
local _p_ = calc_popup._p_
local _q_ = calc_popup._q_
local _r_ = calc_popup._r_
local _s_ = calc_popup._s_
local _t_ = calc_popup._t_
local _u_ = calc_popup._u_
local _v_ = calc_popup._v_
local _w_ = calc_popup._w_
local _x_ = calc_popup._x_
local _y_ = calc_popup._y_
local _z_ = calc_popup._z_

local _eq = calc_popup._eq
local _vl = calc_popup._vl

return {
    min_layer = 1,
    max_layer = 4,
    shiftmode_keys = {[""] = true, ["1/2"] = true, ["2/2"] = true,},
    symbolmode_keys = {["Sym"] = true, ["ABC"] = true},
    utf8mode_keys = {["🌐"] = true},
    keys = {
        -- first row
        {  --  1      2        3       4
            { _q_,   "!",     "",    "+=", },
            { _w_,   "x",     "",    "-?", },
            { _e_,   "y",     "",    "*=", },
            { _r_,   "z",     "",    "/=", },
            { _t_,   "EE",    "",    "<<", },
            { _z_,   "(",     "",    ">>", },
            { _u_,   ")",     "|",   "?", },
            { _i_,   _eq,     "?",    "<", },
            { _o_,   _vl,     "",    ">", },
        },
        -- second row
        {  --  1      2        3       4
            { _a_,   "π",     "",    "||", },
            { _s_,   "sin",   "",    "&&", },
            { _d_,   "cos",   "",    "!&", },
            { _f_,   "tan",   "",    "", },
            { _g_,   "7",     "",    "", },
            { _h_,   "8",     "",    "", },
            { _j_,   "9",     "{",    ":", },
            { _k_,   "/",     "}",    "<=", },
            { _l_,   "^",     "_",    ">=", },
        },
        -- third row
        {  --  1      2        3       4
            { _y_,   "e",     " ",    " ", },
            { _x_,   "asin",  " ",    " ", },
            { _c_,   "acos",  "↑",    "", },
            { _v_,   "atan",  "",    "", },
            { _b_,   "4",     "",    "", },
            { _n_,   "5",     ">",   "", },
            { _m_,   "6",     "",    "", },
            { _p_,   "*",     "",    "!=", },
            { "α",   "√",     "",    "==", },
        },
        -- fourth row
        {  --  1      2        3       4
            { "β",   "rnd",   " ",    " ", },
            { "γ",   "ln",    " ",    " ", },
            { "δ",   "ld",    "&",    "", },
            { "ε",   "log",   "",    "", },
            { "η",   "1",     "",    "", },
            { "λ",   "2",     "",    ",", },
            { "μ",   "3",     "",    "↑", },
            { "ν",   "‒",     "",    ":=", },
            { label = "",  width = 1.0, bold = false  },  --delete

        },
        -- fifth row
        { --  1      2        3       4
            {"2/2",   "1/2",  "2/2",  "1/2",},
            { "Sym",  "Sym",  "ABC",  "ABC", },
            { label = "🌐", },
            { "σ",    "ans",  "",    " ", },
            { "φ",    "0",    "",    " ", },
            { "τ",    ".",    "",    "←", },
            { "ω",    "-",    "",    "↓", },
            { "ψ",    "+",    "",    "→", },
            { label = "⮠",
              "\n",   "\n",   "\n",   "\n",
              width = 1.0,
              bold = true
            },
        },
    },
}
