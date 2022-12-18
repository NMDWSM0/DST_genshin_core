--------------------------------------------------------------------------------------------
--      带icon的，64宽度的按钮
--------------------------------------------------------------------------------------------
local default_icon_xoffset = {
    short = -83,
    medshort = -146,
    medium = -182,
    medlong = -196,
    long = -210,
    xlong = -224,
    xxlong = -243
}

local default_btn_size = {
    short = {x = 234, y = 64},
    medshort = {x = 360, y = 64},
    medium = {x = 432, y = 64},
    medlong = {x = 460, y = 64},
    long = {x = 488, y = 64},
    xlong = {x = 516, y = 64},
    xxlong = {x = 554, y = 64},
}

local function GetDefaultBorderNormalScale(length)
    local x_scale = (default_btn_size[length].x - 1) / (default_btn_size[length].x + 2)
    local y_scale = (default_btn_size[length].y - 1) / (default_btn_size[length].y + 2)
    return {x_scale, y_scale, 0.9}
end

local function GetDefaultBorderDownScale(length)
    local x_scale = default_btn_size[length].x / (default_btn_size[length].x + 2)
    local y_scale = default_btn_size[length].y / (default_btn_size[length].y + 2)
    return {x_scale, y_scale, 0.95}
end

local function GetDefaultButtonFocusScale(length)
    local x_scale = (default_btn_size[length].x - 6) / default_btn_size[length].x
    local y_scale = (default_btn_size[length].y - 6) / default_btn_size[length].y
    return {x_scale, y_scale, 1}
end

------------------------------------------------------------
-- length
------------------------------------------------------------
-- 长度，只支持short, medshort, medium, medlong, long, xlong, xxlong七档：
------------------------------------------------------------
-- short:    234*64大小, icon:-83；
-- medshort: 360*64大小, icon:-146；
-- medium:   432*64大小, icon:-182；
-- medlong:  460*64大小, icon:-196；
-- long:     488*64大小, icon:-210；
-- xlong:    518*64大小, icon:-224；
-- xxlong:   554*64大小, icon:-243；
------------------------------------------------------------
-- icontype
------------------------------------------------------------
-- 图标类型，支持ok, cancel, delete, refresh, setting, teleport, down, ban
------------------------------------------------------------
function GetDefaultGButtonConfig(type, length, icontype, fontsize)
    fontsize = fontsize or 42
    return type == "light" and
    {
        -- [1] focus时的border层
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = "images/ui/default_genshin_button.xml",  --实际上，使用同一张图即可，都是白的
                change = false,
                normal = "border_"..length..".tex",
                focus = "border_"..length..".tex",
                down = "border_"..length..".tex",
                selected = "border_"..length..".tex",
                disable = "border_"..length..".tex",
            },
            scale = {
                normal = GetDefaultBorderNormalScale(length),
                focus = {1, 1, 1},
                down = GetDefaultBorderDownScale(length),
                selected = GetDefaultBorderNormalScale(length),
                disable = GetDefaultBorderDownScale(length)
            },
            tint = {
                normal = {1, 1, 1, 0},
                focus = {1, 1, 1, 1},
                down = {143/255, 142/255, 147/255, 0.55},
                selected = {255/255, 230/255, 178/255, 0},
                disable = {1, 1, 1, 0.1}
            }
        },
        -- [2] 普通按钮层
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = "images/ui/default_genshin_button.xml",  --同一张白色图即可，有不同长度可选
                change = false,
                normal = "btn_"..length..".tex",
                focus = "btn_"..length..".tex",
                down = "btn_"..length..".tex",
                selected = "btn_"..length..".tex",
                disable = "btn_"..length..".tex",
            },
            scale = {
                normal = {1, 1, 1},
                focus = GetDefaultButtonFocusScale(length),
                down = GetDefaultButtonFocusScale(length),
                selected = {1, 1, 1},
                disable = GetDefaultButtonFocusScale(length)
            },
            tint = {
                normal = {236/255, 229/255, 216/255, 1},
                focus = {236/255, 229/255, 216/255, 1},
                down = {179/255, 165/255, 143/255, 1},
                selected = {59/255, 66/255, 85/255, 1},
                disable = {62/255, 69/255, 86/255, 1}
            }
        },
        -- [3] 图标层
        {
            type = "image",
            position = {
                normal = {default_icon_xoffset[length], 0, 0},
                focus = {default_icon_xoffset[length], 0, 0},
                down = {default_icon_xoffset[length], 0, 0},
                selected = {default_icon_xoffset[length], 0, 0},
                disable = {default_icon_xoffset[length], 0, 0}
            },
            textures = {
                atlas = "images/ui/default_genshin_button.xml",   --同一张图，各种icon:ok, cancel, refresh, delete, setting
                change = false,
                normal = "icon_"..icontype..".tex",
                focus = "icon_"..icontype..".tex",
                down = "icon_"..icontype..".tex",
                selected = "icon_"..icontype..".tex",
                disable = "icon_"..icontype..".tex",
            },
            scale = {
                normal = {1, 1, 1},
                focus = {1, 1, 1},
                down = {1, 1, 1},
                selected = {1, 1, 1},
                disable = {1, 1, 1}
            },
            tint = {
                normal = {1, 1, 1, 1},
                focus = {1, 1, 1, 1},
                down = {179/255, 165/255, 143/255, 1},
                selected = {1, 1, 1, 1},
                disable = {1, 1, 1, 0.13}
            }
        },
        -- but the last layer shows whether to have text shown
        -- [3]: the text layer
        {
            type = "text",
            font = "genshinfont",
            position = {
                normal = {10, -1, 0},
                focus = {10, -1, 0},
                down = {10, -1, 0},
                selected = {10, -1, 0},
                disable = {10, -1, 0}
            },
            colors = {
                normal = {59/255, 66/255, 85/255, 1},
                focus = {59/255, 66/255, 85/255, 1},
                down = {255/255, 253/255, 212/255, 1},
                selected = {236/255, 229/255, 216/255, 1},
                disable = {150/255, 150/255, 150/255, 1}
            },
            sizes = {
                normal = fontsize,
                focus = fontsize,
                down = fontsize,
                selected = fontsize,
                disable = fontsize
            }
        }
    }
    or
    {
        -- [1] focus时的border层
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = "images/ui/default_genshin_button.xml",  --实际上，使用同一张图即可，都是白的
                change = false,
                normal = "border_"..length..".tex",
                focus = "border_"..length..".tex",
                down = "border_"..length..".tex",
                selected = "border_"..length..".tex",
                disable = "border_"..length..".tex",
            },
            scale = {
                normal = GetDefaultBorderNormalScale(length),
                focus = {1, 1, 1},
                down = GetDefaultBorderDownScale(length),
                selected = GetDefaultBorderNormalScale(length),
                disable = GetDefaultBorderDownScale(length)
            },
            tint = {
                normal = {255/255, 230/255, 178/255, 0},
                focus = {255/255, 230/255, 178/255, 1},
                down = {181/255, 178/255, 174/255, 0.85},
                selected = {217/255, 210/255, 199/255, 0},
                disable = {74/255, 83/255, 102/255, 0.1}
            }
        },
        -- [2] 普通按钮层
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = "images/ui/default_genshin_button.xml",  --同一张白色图即可，有不同长度可选
                change = false,
                normal = "btn_"..length..".tex",
                focus = "btn_"..length..".tex",
                down = "btn_"..length..".tex",
                selected = "btn_"..length..".tex",
                disable = "btn_"..length..".tex",
            },
            scale = {
                normal = {1, 1, 1},
                focus = GetDefaultButtonFocusScale(length),
                down = GetDefaultButtonFocusScale(length),
                selected = {1, 1, 1},
                disable = GetDefaultButtonFocusScale(length)
            },
            tint = {
                normal = {74/255, 83/255, 102/255, 1},
                focus = {74/255, 83/255, 102/255, 1},
                down = {256/255, 236/255, 203/255, 1},
                selected = {236/255, 229/255, 216/255, 1},
                disable = {230/255, 219/255, 198/255, 1}
            }
        },
        -- [3] 图标层
        {
            type = "image",
            position = {
                normal = {default_icon_xoffset[length], 0, 0},
                focus = {default_icon_xoffset[length], 0, 0},
                down = {default_icon_xoffset[length], 0, 0},
                selected = {default_icon_xoffset[length], 0, 0},
                disable = {default_icon_xoffset[length], 0, 0}
            },
            textures = {
                atlas = "images/ui/default_genshin_button.xml",   --同一张图，各种icon:ok, cancel, refresh, delete, setting
                change = false,
                normal = "icon_"..icontype..".tex",
                focus = "icon_"..icontype..".tex",
                down = "icon_"..icontype..".tex",
                selected = "icon_"..icontype..".tex",
                disable = "icon_"..icontype..".tex",
            },
            scale = {
                normal = {1, 1, 1},
                focus = {1, 1, 1},
                down = {1, 1, 1},
                selected = {1, 1, 1},
                disable = {1, 1, 1}
            },
            tint = {
                normal = {1, 1, 1, 1},
                focus = {1, 1, 1, 1},
                down = {256/255, 236/255, 203/255, 1},
                selected = {1, 1, 1, 1},
                disable = {1, 1, 1, 0.13}
            }
        },
        -- but the last layer shows whether to have text shown
        -- [3]: the text layer
        {
            type = "text",
            font = "genshinfont",
            position = {
                normal = {10, -1, 0},
                focus = {10, -1, 0},
                down = {10, -1, 0},
                selected = {10, -1, 0},
                disable = {10, -1, 0}
            },
            colors = {
                normal = {236/255, 229/255, 216/255, 1},
                focus = {236/255, 229/255, 216/255, 1},
                down = {161/255, 146/255, 125/255, 1},
                selected = {59/255, 66/255, 85/255, 1},
                disable = {150/255, 150/255, 150/255, 1}
            },
            sizes = {
                normal = fontsize,
                focus = fontsize,
                down = fontsize,
                selected = fontsize,
                disable = fontsize
            }
        }
    }
end


--------------------------------------------------------------------------------------------
--      不带icon的，50宽度的按钮
--------------------------------------------------------------------------------------------
local noicon_btn_size = {
    short = {x = 234, y = 64},
    medshort = {x = 360, y = 64},
    medium = {x = 432, y = 64},
    medlong = {x = 460, y = 64},
    long = {x = 488, y = 64},
    xlong = {x = 516, y = 64},
    xxlong = {x = 554, y = 64},
}

local function GetNoiconBorderNormalScale(length)
    local x_scale = (noicon_btn_size[length].x - 1) / (noicon_btn_size[length].x + 2)
    local y_scale = (noicon_btn_size[length].y - 1) / (noicon_btn_size[length].y + 2)
    return {x_scale, y_scale, 0.9}
end

local function GetNoiconBorderDownScale(length)
    local x_scale = noicon_btn_size[length].x / (noicon_btn_size[length].x + 2)
    local y_scale = noicon_btn_size[length].y / (noicon_btn_size[length].y + 2)
    return {x_scale, y_scale, 0.95}
end

local function GetNoiconButtonFocusScale(length)
    local x_scale = (noicon_btn_size[length].x - 6) / noicon_btn_size[length].x
    local y_scale = (noicon_btn_size[length].y - 6) / noicon_btn_size[length].y
    return {x_scale, y_scale, 1}
end

------------------------------------------------------------
-- length
------------------------------------------------------------
-- 长度，只支持short, long两档：
------------------------------------------------------------
-- short:    234*64大小, icon:-83；
-- long:     488*64大小, icon:-210；
------------------------------------------------------------
function GetNoiconGButtonConfig(type, length, fontsize)
    fontsize = fontsize or 37
    return type == "light" and
    {
        -- [1] focus时的border层
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = "images/ui/noicon_genshin_button.xml",  --实际上，使用同一张图即可，都是白的
                change = false,
                normal = "border_"..length..".tex",
                focus = "border_"..length..".tex",
                down = "border_"..length..".tex",
                selected = "border_"..length..".tex",
                disable = "border_"..length..".tex",
            },
            scale = {
                normal = GetNoiconBorderNormalScale(length),
                focus = {1, 1, 1},
                down = GetNoiconBorderDownScale(length),
                selected = GetNoiconBorderNormalScale(length),
                disable = GetNoiconBorderDownScale(length)
            },
            tint = {
                normal = {1, 1, 1, 0},
                focus = {1, 1, 1, 1},
                down = {143/255, 142/255, 147/255, 0.55},
                selected = {255/255, 230/255, 178/255, 0},
                disable = {1, 1, 1, 0.1}
            }
        },
        -- [2] 普通按钮层
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = "images/ui/noicon_genshin_button.xml",  --同一张白色图即可，有不同长度可选
                change = false,
                normal = "btn_"..length..".tex",
                focus = "btn_"..length..".tex",
                down = "btn_"..length..".tex",
                selected = "btn_"..length..".tex",
                disable = "btn_"..length..".tex",
            },
            scale = {
                normal = {1, 1, 1},
                focus = GetNoiconButtonFocusScale(length),
                down = GetNoiconButtonFocusScale(length),
                selected = {1, 1, 1},
                disable = GetNoiconButtonFocusScale(length)
            },
            tint = {
                normal = {236/255, 229/255, 216/255, 1},
                focus = {236/255, 229/255, 216/255, 1},
                down = {179/255, 165/255, 143/255, 1},
                selected = {59/255, 66/255, 85/255, 1},
                disable = {62/255, 69/255, 86/255, 1}
            }
        },
        -- but the last layer shows whether to have text shown
        -- [3]: the text layer
        {
            type = "text",
            font = "genshinfont",
            position = {
                normal = {0, -1, 0},
                focus = {0, -1, 0},
                down = {0, -1, 0},
                selected = {0, -1, 0},
                disable = {0, -1, 0}
            },
            colors = {
                normal = {59/255, 66/255, 85/255, 1},
                focus = {59/255, 66/255, 85/255, 1},
                down = {255/255, 253/255, 212/255, 1},
                selected = {236/255, 229/255, 216/255, 1},
                disable = {150/255, 150/255, 150/255, 1}
            },
            sizes = {
                normal = fontsize,
                focus = fontsize,
                down = fontsize,
                selected = fontsize,
                disable = fontsize
            }
        }
    }
    or
    {
        -- [1] focus时的border层
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = "images/ui/noicon_genshin_button.xml",  --实际上，使用同一张图即可，都是白的
                change = false,
                normal = "border_"..length..".tex",
                focus = "border_"..length..".tex",
                down = "border_"..length..".tex",
                selected = "border_"..length..".tex",
                disable = "border_"..length..".tex",
            },
            scale = {
                normal = GetNoiconBorderNormalScale(length),
                focus = {1, 1, 1},
                down = GetNoiconBorderDownScale(length),
                selected = GetNoiconBorderNormalScale(length),
                disable = GetNoiconBorderDownScale(length)
            },
            tint = {
                normal = {255/255, 230/255, 178/255, 0},
                focus = {255/255, 230/255, 178/255, 1},
                down = {181/255, 178/255, 174/255, 0.85},
                selected = {217/255, 210/255, 199/255, 0},
                disable = {74/255, 83/255, 102/255, 0.1}
            }
        },
        -- [2] 普通按钮层
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = "images/ui/noicon_genshin_button.xml",  --同一张白色图即可，有不同长度可选
                change = false,
                normal = "btn_"..length..".tex",
                focus = "btn_"..length..".tex",
                down = "btn_"..length..".tex",
                selected = "btn_"..length..".tex",
                disable = "btn_"..length..".tex",
            },
            scale = {
                normal = {1, 1, 1},
                focus = GetNoiconButtonFocusScale(length),
                down = GetNoiconButtonFocusScale(length),
                selected = {1, 1, 1},
                disable = GetNoiconButtonFocusScale(length)
            },
            tint = {
                normal = {74/255, 83/255, 102/255, 1},
                focus = {74/255, 83/255, 102/255, 1},
                down = {256/255, 236/255, 203/255, 1},
                selected = {236/255, 229/255, 216/255, 1},
                disable = {230/255, 219/255, 198/255, 1}
            }
        },
        -- but the last layer shows whether to have text shown
        -- [3]: the text layer
        {
            type = "text",
            font = "genshinfont",
            position = {
                normal = {0, -1, 0},
                focus = {0, -1, 0},
                down = {0, -1, 0},
                selected = {0, -1, 0},
                disable = {0, -1, 0}
            },
            colors = {
                normal = {236/255, 229/255, 216/255, 1},
                focus = {236/255, 229/255, 216/255, 1},
                down = {161/255, 146/255, 125/255, 1},
                selected = {59/255, 66/255, 85/255, 1},
                disable = {150/255, 150/255, 150/255, 1}
            },
            sizes = {
                normal = fontsize,
                focus = fontsize,
                down = fontsize,
                selected = fontsize,
                disable = fontsize
            }
        }
    }
end


--------------------------------------------------------------------------------------------
--      只有icon的圆形按钮
--------------------------------------------------------------------------------------------

------------------------------------------------------------
-- icontype
------------------------------------------------------------
-- 图标类型，支持close, back
------------------------------------------------------------
function GetIconGButtonConfig(icontype)
    return {
        -- [1] focus时的border层
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = "images/ui/icon_genshin_button.xml",  --实际上，使用同一张图即可，都是白的
                change = false,
                normal = "border.tex",
                focus = "border.tex",
                down = "border.tex",
                selected = "border.tex",
                disable = "border.tex",
            },
            scale = {
                normal = {1, 1, 1},
                focus = {0.948, 0.948, 0.948},
                down = {0.948, 0.948, 0.948},
                selected = {1, 1, 1},
                disable = {1, 1, 1}
            },
            tint = {
                normal = {236/255, 229/255, 216/255, 0.45},
                focus = {1, 1, 1, 1},
                down = {1, 1, 1, 0.05},
                selected = {236/255, 229/255, 216/255, 0.45},
                disable = {1, 1, 1, 0.05}
            }
        },
        -- [2] 普通按钮层
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = "images/ui/icon_genshin_button.xml",  --同一张白色图即可，有不同长度可选
                change = false,
                normal = "button.tex",
                focus = "button.tex",
                down = "button.tex",
                selected = "button.tex",
                disable = "button.tex",
            },
            scale = {
                normal = {1, 1, 1},
                focus = {1.03, 1.03, 1.03},
                down = {1.12, 1.12, 1.12},
                selected = {1, 1, 1},
                disable = {1, 1, 1}
            },
            tint = {
                normal = {236/255, 229/255, 216/255, 1},
                focus = {236/255, 229/255, 216/255, 1},
                down = {169/255, 156/255, 132/255, 1},
                selected = {236/255, 229/255, 216/255, 1},
                disable = {236/255, 229/255, 216/255, 0.05}
            }
        },
        -- [3] 图标层
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = "images/ui/icon_genshin_button.xml",   --同一张图，各种icon:ok, cancel, refresh, delete, setting
                change = false,
                normal = "icon_"..icontype..".tex",
                focus = "icon_"..icontype..".tex",
                down = "icon_"..icontype..".tex",
                selected = "icon_"..icontype..".tex",
                disable = "icon_"..icontype..".tex",
            },
            scale = {
                normal = {1, 1, 1},
                focus = {1, 1, 1},
                down = {1, 1, 1},
                selected = {1, 1, 1},
                disable = {1, 1, 1}
            },
            tint = {
                normal = {59/255, 66/255, 85/255, 1},
                focus = {59/255, 66/255, 85/255, 1},
                down = {255/255, 255/255, 236/255, 1},
                selected = {59/255, 66/255, 85/255, 1},
                disable = {59/255, 66/255, 85/255, 0.2}
            }
        },
    }
end

--------------------------------------------------------------------------------------------
--      特殊按钮：单层按钮，颜色是后设的，现在只有那两个单层关闭
--------------------------------------------------------------------------------------------

-- type是亮暗, image和atlas不用我多解释
function GetSingleGButtonConfig(type, atlas, image)
    return type == "light" and {
        -- [1] 单层按钮
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = atlas,  --实际上，使用同一张图即可，都是白的
                change = false,
                normal = image,
                focus = image,
                down = image,
                selected = image,
                disable = image,
            },
            scale = {
                normal = {1, 1, 1},
                focus = {1.05, 1.05, 1.05},
                down = {1, 1, 1},
                selected = {1, 1, 1},
                disable = {1, 1, 1}
            },
            tint = {
                normal = {236/255, 229/255, 216/255, 1},
                focus = {236/255, 229/255, 216/255, 1},
                down = {236/255, 229/255, 216/255, 0.22},
                selected = {236/255, 229/255, 216/255, 1},
                disable = {1, 1, 1, 0.05}
            }
        },
    }
    or
    {
        -- [1] 单层按钮
        {
            type = "image",
            position = {
                normal = {0, 0, 0},
                focus = {0, 0, 0},
                down = {0, 0, 0},
                selected = {0, 0, 0},
                disable = {0, 0, 0}
            },
            textures = {
                atlas = atlas,  --实际上，使用同一张图即可，都是白的
                change = false,
                normal = image,
                focus = image,
                down = image,
                selected = image,
                disable = image,
            },
            scale = {
                normal = {1, 1, 1},
                focus = {1, 1, 1},
                down = {1, 1, 1},
                selected = {1, 1, 1},
                disable = {1, 1, 1}
            },
            tint = {
                normal = {211/255, 188/255, 142/255, 0.75},
                focus = {211/255, 188/255, 142/255, 1},
                down = {211/255, 188/255, 142/255, 0.25},
                selected = {211/255, 188/255, 142/255, 1},
                disable = {1, 1, 1, 0.05}
            }
        },
    }
end