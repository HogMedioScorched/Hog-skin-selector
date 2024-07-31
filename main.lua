-- name: Hog Skin Selector 
-- description: XD
local curSelected = 1
local menu = "skins"

local skins = {
    {
        name = "Default"
    },
    {
        name = "Goomba",
        model = E_MODEL_GOOMBA, 
        credits = "Nintendo Company Ltd.",
        origin = "Super Mario 64",
    },
    {
        name = "Star",
        model = E_MODEL_STAR, 
        info = "That star got stuck in the floor.",
        credits = "Nintendo Company Ltd.",
        origin = "Super Mario 64",
    },
}
local bg = {255,255,255}
local tweenthing = 1
local tweenthing2 = 1
local coopstyle = mod_storage_load("coopstyle") or "n"
local introonscroll = mod_storage_load("introonscroll") or "y"

function djui_hud_render_outline_rect(x, y, width, height, color)
    djui_hud_set_color(color[1], color[2], color[3], color[4]/2)
    djui_hud_render_rect(x, y, width, height)
    djui_hud_set_color(color[1], color[2], color[3], color[4])
    djui_hud_render_rect(x+5, y+5, width-10, height-10)
end
function on_hud_render()
    if menu == "skins" then
        local text1 = skins[curSelected].name
        local text2 = "By "..(skins[curSelected].credits or "Unknown Author")
        local text3 = "From "..(skins[curSelected].origin or "???")
        local text4 = skins[curSelected].info or ""
        if coopstyle == "y" then
            local scale = 1.5
            djui_hud_render_outline_rect(0, 0, djui_hud_get_screen_width()/3, djui_hud_get_screen_height(), {0,0,0,255})
            djui_hud_set_font(FONT_MENU)
            djui_hud_set_color(255, 255, 255, 255)
            local bgmidwidth = (djui_hud_get_screen_width()/3)/2
            local textmidwidth = (djui_hud_measure_text("Skins")*scale)/2
            djui_hud_print_text("Skins", bgmidwidth-textmidwidth, 10, scale-0.5)
            djui_hud_set_font(FONT_NORMAL)
            djui_hud_render_outline_rect(10, 50*scale, djui_hud_get_screen_width()/3.2, 32*scale, {255,255,255,255})
            djui_hud_set_color(0, 0, 0, 255)
            djui_hud_print_text(text1, 12*scale, 50*scale, scale)
            djui_hud_set_color(0, 0, 0, 128)
            djui_hud_print_text("< >", 295*scale, 47*scale, scale)
            if skins[curSelected].model ~= nil then
                djui_hud_set_color(255, 255, 255, 255)
                djui_hud_print_text(text2, 10*scale, 87*scale, scale-0.5)
                djui_hud_print_text(text3, 10*scale, (87+21)*scale, scale-0.5)
                djui_hud_set_color(0, 0, 0, 255)
                djui_hud_print_text(text4, 360*scale, 5*scale, scale)
            end
            return
        end
        tweenthing = funnyLerp(tweenthing, 0, 0.10)
        tweenthing2 = funnyLerp(tweenthing2, 0, 0.10)
        local scale = 3
        djui_hud_set_color(bg[1], bg[2], bg[3], 100)
        djui_hud_render_rect(0, 0, djui_hud_get_screen_width(), djui_hud_get_screen_height())
        djui_hud_render_rect(0, -(65*tweenthing), djui_hud_get_screen_width(), 64)
        djui_hud_set_color(bg[1], bg[2], bg[3], 255)
        djui_hud_set_font(FONT_MENU)
        local bgmidwidth = djui_hud_get_screen_width()/2
        local textmidwidth = (djui_hud_measure_text("Skins"))/2
        djui_hud_print_text("Skins", bgmidwidth-textmidwidth, 5-(70*tweenthing), 1)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_set_font(FONT_NORMAL)
        local w = djui_hud_measure_text(text1)
        djui_hud_print_text(text1, (5-((w+5)*tweenthing2))*scale, 64, scale)
        if skins[curSelected].model ~= nil then
            djui_hud_set_font(FONT_HUD)
            local w = djui_hud_measure_text(text2)
            djui_hud_print_text(text2, (5-((w+5)*tweenthing2))*scale, 64+(32*scale), scale-0.5)
            djui_hud_print_text(text3, 5*scale, ((djui_hud_get_screen_height())-21*(scale-1))+(200*tweenthing2), scale-1)
            djui_hud_set_font(FONT_MENU)
            local w = djui_hud_measure_text(text4)
            djui_hud_print_text(text4, (5-((w+5)*tweenthing2))*scale, 65*scale, scale-2.2)
        end
    end
    --bg = {funnyLerp(bg[1], skins[curSelected].color[1] or 50, 0.10),funnyLerp(bg[1], skins[curSelected].color[1] or 0, 0.10),funnyLerp(bg[3], skins[curSelected].color[3] or 100, 0.10)}
end

function mario_update_local(m)

    if menu == "skins" then
        if (m.controller.buttonPressed & R_JPAD) ~= 0 then
            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
            change(1)
        end
        if (m.controller.buttonPressed & L_JPAD) ~= 0 then
            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
            change(-1)
        end
        if (m.controller.buttonPressed & A_BUTTON) ~= 0 then
            play_sound(SOUND_MENU_STAR_SOUND_OKEY_DOKEY, m.marioObj.header.gfx.cameraToObject)
            menu = "none"
            tweenthing = 1
            tweenthing2 = 1
            mod_storage_save("lastusedskin", tostring(curSelected))
        end
    elseif menu == "none" then
        if (m.controller.buttonPressed & D_JPAD) ~= 0 then
		    play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
		    menu = "skins"
        end
    end

    gPlayerSyncTable[0].modelId = skins[curSelected].model

end

function mario_update(m)
    if m.playerIndex == 0 then
        mario_update_local(m)
    end
    if gPlayerSyncTable[m.playerIndex].modelId ~= nil and gPlayerSyncTable[m.playerIndex].modelId ~= E_MODEL_ERROR_MODEL then
        obj_set_model_extended(m.marioObj, gPlayerSyncTable[m.playerIndex].modelId)
    end
end

function mario_before_phys_step(m)
    if menu == "skins" then
        m.vel.x = 0
        m.vel.y = math.min(m.vel.y, 0)
        m.vel.z = 0
    end
end

function change(num)
    curSelected = curSelected + num
    if curSelected > #skins then
        curSelected = 1
    elseif curSelected < 1 then
        curSelected = #skins
    end
    if introonscroll == "y" then
        tweenthing2 = 1
    end
end
function character_add(name, description, credit, color, modelInfo, forceChar, lifeIcon, camScale, offset)
    if type(color) == TYPE_STRING then
        color = {r = tonumber(color:sub(1,2), 16), g = tonumber(color:sub(3,4), 16), b = tonumber(color:sub(5,6), 16) }
    end
    table_insert(skins, {
        name = name,
        info = description,
        credits = credit,
        color = color,
        model = modelInfo,
        lifeIcon = lifeIcon or nil,
    })
    return #skins
end
function funnyLerp(value, target, ratio)
    return value + ((target - value) / (ratio*100))
end
hook_chat_command("manual-menu-open", "| open the selector manually", function(arg)
	if menu == "none" then
	    menu = "skins"
    end
end)
hook_chat_command("coop-style", "- coop-style [y|n] | make the selector look like the sm64ex-coop menu", function(arg)
    if string.lower(arg) == "y" then
        coopstyle = "y"
        mod_storage_save("coopstyle", "y")
        return true
    elseif string.lower(arg) == "n" then
        coopstyle = "n"
        mod_storage_save("coopstyle", "n")
        return true
    else
        djui_chat_message_create("sorry, but the value you entered is invalid.\ntry with Y or N")
        return true
    end
end)
hook_chat_command("intro-on-scroll", "- intro-on-scroll [y|n] | makes the info make an smooth introduction everytime you scroll. (if it's off only will happen everytime you open the menu)", function(arg)
    if string.lower(arg) == "y" then
        introonscroll = "y"
        mod_storage_save("introonscroll", "y")
        return true
    elseif string.lower(arg) == "n" then
        introonscroll = "n"
        mod_storage_save("introonscroll", "n")
        return true
    else
        djui_chat_message_create("sorry, but the value you entered is invalid.\ntry with Y or N")
        return true
    end
end)
hook_event(HOOK_BEFORE_PHYS_STEP, mario_before_phys_step)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_OBJECT_SET_MODEL, function(o, id)
    if id == E_MODEL_MARIO then
        local i = network_local_index_from_global(o.globalPlayerIndex)
        if gPlayerSyncTable[i].modelId ~= nil then
            obj_set_model_extended(m.marioObj, gPlayerSyncTable[i].modelId)
        end
    end
end)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
