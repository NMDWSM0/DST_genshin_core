
local icon_xoffset = {
    short = -83,
    medium = -146,
    long = -210,
    xlong = -224,
    xxlong = -243
}

local btn_size = {
    short = {x = 234, y = 64},
    medium = {x = 360, y = 64},
    long = {x = 488, y = 64},
    xlong = {x = 516, y = 64},
    xxlong = {x = 554, y = 64},
}

local function GetBorderNormalScale(length)
    local x_scale = (btn_size[length].x - 1) / (btn_size[length].x + 2)
    local y_scale = (btn_size[length].y - 1) / (btn_size[length].y + 2)
    return {x_scale, y_scale, 0.9}
end

local function GetBorderDownScale(length)
    local x_scale = btn_size[length].x / (btn_size[length].x + 2)
    local y_scale = btn_size[length].y / (btn_size[length].y + 2)
    return {x_scale, y_scale, 0.95}
end

local function GetButtonFocusScale(length)
    local x_scale = (btn_size[length].x - 6) / btn_size[length].x
    local y_scale = (btn_size[length].y - 6) / btn_size[length].y
    return {x_scale, y_scale, 1}
end

------------------------------------------------------------
-- length
------------------------------------------------------------
-- 长度，只支持short, medium, long, xlong, xxlong五档：
------------------------------------------------------------
-- short:    234*64大小, icon:-83；
-- medium:   360*64大小, icon:-146；
-- long:     488*64大小, icon:-210；
-- xlong:    518*64大小, icon:-224；
-- xxlong:   554*64大小, icon:-243；
------------------------------------------------------------
-- icontype
------------------------------------------------------------
-- 图标类型，支持ok, cancel, delete, refresh, setting, teleport
------------------------------------------------------------
function GetDefaultGButtonConfig(type, length, icontype)
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
                normal = GetBorderNormalScale(length),
                focus = {1, 1, 1},
                down = GetBorderDownScale(length),
                selected = GetBorderNormalScale(length),
                disable = GetBorderDownScale(length)
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
                focus = GetButtonFocusScale(length),
                down = GetButtonFocusScale(length),
                selected = {1, 1, 1},
                disable = {1, 1, 1}
            },
            tint = {
                normal = {236/255, 229/255, 216/255, 1},
                focus = {236/255, 229/255, 216/255, 1},
                down = {179/255, 165/255, 143/255, 1},
                selected = {59/255, 66/255, 85/255, 1},
                disable = {236/255, 229/255, 216/255, 0.05}
            }
        },
        -- [3] 图标层
        {
            type = "image",
            position = {
                normal = {icon_xoffset[length], 0, 0},
                focus = {icon_xoffset[length], 0, 0},
                down = {icon_xoffset[length], 0, 0},
                selected = {icon_xoffset[length], 0, 0},
                disable = {icon_xoffset[length], 0, 0}
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
                normal = {10, -2, 0},
                focus = {10, -2, 0},
                down = {10, -2, 0},
                selected = {10, -2, 0},
                disable = {10, -2, 0}
            },
            colors = {
                normal = {59/255, 66/255, 85/255, 1},
                focus = {59/255, 66/255, 85/255, 1},
                down = {255/255, 253/255, 212/255, 1},
                selected = {236/255, 229/255, 216/255, 1},
                disable = {150/255, 150/255, 150/255, 1}
            },
            sizes = {
                normal = 42,
                focus = 42,
                down = 42,
                selected = 42,
                disable = 42
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
                normal = GetBorderNormalScale(length),
                focus = {1, 1, 1},
                down = GetBorderDownScale(length),
                selected = GetBorderNormalScale(length),
                disable = GetBorderDownScale(length)
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
                focus = GetButtonFocusScale(length),
                down = GetButtonFocusScale(length),
                selected = {1, 1, 1},
                disable = {1, 1, 1}
            },
            tint = {
                normal = {74/255, 83/255, 102/255, 1},
                focus = {74/255, 83/255, 102/255, 1},
                down = {256/255, 236/255, 203/255, 1},
                selected = {236/255, 229/255, 216/255, 1},
                disable = {74/255, 83/255, 102/255, 0.05}
            }
        },
        -- [3] 图标层
        {
            type = "image",
            position = {
                normal = {icon_xoffset[length], 0, 0},
                focus = {icon_xoffset[length], 0, 0},
                down = {icon_xoffset[length], 0, 0},
                selected = {icon_xoffset[length], 0, 0},
                disable = {icon_xoffset[length], 0, 0}
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
                normal = {10, -2, 0},
                focus = {10, -2, 0},
                down = {10, -2, 0},
                selected = {10, -2, 0},
                disable = {10, -2, 0}
            },
            colors = {
                normal = {236/255, 229/255, 216/255, 1},
                focus = {236/255, 229/255, 216/255, 1},
                down = {161/255, 146/255, 125/255, 1},
                selected = {59/255, 66/255, 85/255, 1},
                disable = {150/255, 150/255, 150/255, 1}
            },
            sizes = {
                normal = 42,
                focus = 42,
                down = 42,
                selected = 42,
                disable = 42
            }
        }
    }
end

function GetSimpleTintConfig()
    
end