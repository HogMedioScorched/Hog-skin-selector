-- name: Hog Skin Selector
-- info: Version: 2023/12/17 Preview
gLang = {
	["English"] = {
		INVALIDBOOL = "sorry, but the value you entered is invalid.\ntry with Y or N",
		BY = "By",
		DEFAULT = "Default",
		FROM = "From",
		CPDDESC = "make the selector look like the sm64ex-coop menu",
		MMODESC = "open the selector manually",
		TONDESC = "makes the info make an smooth introduction everytime you scroll. (if it's off only will happen everytime you open the menu)",
	},

	["Spanish"] = {
		INVALIDBOOL = "perdon, pero el valor que pusiste es invalido.\nintenta con Y o N",
		BY = "Hecho Por",
		DEFAULT = "Por defecto",
		FROM = "de",
		CPDDESC = "haz que el selector se vea como el menu de sm64ex-coop",
		MMODESC = "abre el selector manualmente",
		TONDESC = "hace que la info haga una suave introducción al cambiar la skin. (si está desactivado, solo sucederá cuando abras el menú)",
	},

	["Portuguese"] = {
		INVALIDBOOL = "desculpe, mas o valor digitado é inválido.\ntente Y ou N",
        BY = "Feito Por",
        DEFAULT = "Padrão",
        FROM = "de",
        CPDDESC = "faça o seletor parecer com o menu sm64ex-coop",
        MMODESC = "abra o seletor manualmente",
        TONDESC = "faz com que a informação faça uma introdução suave ao mudar a pele. (se estiver desabilitado só acontecerá quando você abrir o menu)",
	},

}
local function lang()
	local l = gLang[smlua_text_utils_get_language()]
	return l == nil and gLang["English"] or l
end
local curSelected = tonumber(mod_storage_load("lastusedskin")) or 1
local skinSelect = true

local skins = {
	{
		name = lang().DEFAULT
	},
	{
		name = "Goomba",
		model = "goomba", 
		credits = "Nintendo Company Ltd.",
		origin = "Super Mario 64",
	},
	{
		name = "Star",
		model = "star", 
		info = "That star got stuck in the floor.",
		credits = "Nintendo Company Ltd.",
		origin = "Super Mario 64",
	},
	{
		name = "Yoshi",
		model = "yoshi", 
		info = "Cursed arms and legs.",
		credits = "Nintendo Company Ltd.",
		origin = "Super Mario 64",
	},
	{
		name = "Chain Chomp",
		model = "chain_chomp", 
		info = "Holy Damn, this is ultra cursed.",
		credits = "Nintendo Company Ltd.",
		origin = "Super Mario 64",
	},
}
local bg = {50,0,100}
local tweenthing = 1
local tweenthing2 = 1
local coopstyle = mod_storage_load("coopstyle") or "n"
local tweenonscroll = mod_storage_load("tweenonscroll") or "y"

local function djui_hud_render_outline_rect(x, y, width, height, color)
	djui_hud_set_color(color[1], color[2], color[3], color[4]/2)
    djui_hud_render_rect(x, y, width, height)
    djui_hud_set_color(color[1], color[2], color[3], color[4])
    djui_hud_render_rect(x+5, y+5, width-10, height-10)
end
local function on_hud_render()
	if skinSelect == true then
		local text1 = skins[curSelected].name
		local text2 = lang().BY.." "..(skins[curSelected].credits or "Unknown Author")
		local text3 = lang().FROM.." "..(skins[curSelected].origin or "???")
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
end

function mario_update_local(m)

    if skinSelect == true then
        set_mario_animation(m, MARIO_ANIM_STAND_AGAINST_WALL)
    end
    
    if skinSelect == true then
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
            skinSelect = false
            tweenthing = 1
            tweenthing2 = 1
            mod_storage_save("lastusedskin", tostring(curSelected))
		end
	else
		if (m.controller.buttonPressed & D_JPAD) ~= 0 then
            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
            skinSelect = true
		end
	end
	
    gPlayerSyncTable[0].modelId = skins[curSelected].model
    
end

function mario_update(m)
    if m.playerIndex == 0 then
        mario_update_local(m)
    end
	if gPlayerSyncTable[m.playerIndex].modelId ~= nil then
        obj_set_model_extended(m.marioObj, smlua_model_util_get_id(gPlayerSyncTable[m.playerIndex].modelId.."_geo"))
    end
end

function mario_before_phys_step(m)
    if skinSelect == true then
        m.vel.x = 0
        if m.vel.y > 0 then
            m.vel.y = 0
        end
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
	if tweenonscroll == "y" then
	tweenthing2 = 1
	end
end
hook_chat_command("tween-on-scroll", "- tween-on-scroll [y|n] | "..lang().TONDESC, function(arg)
	if string.lower(arg) == "y" then
		tweenonscroll = "y"
		mod_storage_save("tweenonscroll", "y")
		return true
	elseif string.lower(arg) == "n" then
		tweenonscroll = "n"
		mod_storage_save("tweenonscroll", "n")
		return true
	else
		djui_chat_message_create(lang().INVALIDBOOL)
		return true
	end
end)
function funnyLerp(value, target, ratio)
	return value + ((target - value) / (ratio*100))
end
hook_chat_command("manual-menu-open", "- manual-menu-open [no args] | "..lang().MMODESC, function(arg)
	skinSelect = true
end)
hook_chat_command("coop-style", "- coop-style [y|n] | "..lang().CPDDESC, function(arg)
	if string.lower(arg) == "y" then
		coopstyle = "y"
		mod_storage_save("coopstyle", "y")
		return true
	elseif string.lower(arg) == "n" then
		coopstyle = "n"
		mod_storage_save("coopstyle", "n")
		return true
	else
		djui_chat_message_create(lang().INVALIDBOOL)
		return true
	end
end)
hook_chat_command("tween-on-scroll", "- tween-on-scroll [y|n] | "..lang().TONDESC, function(arg)
	if string.lower(arg) == "y" then
		tweenonscroll = "y"
		mod_storage_save("tweenonscroll", "y")
		return true
	elseif string.lower(arg) == "n" then
		tweenonscroll = "n"
		mod_storage_save("tweenonscroll", "n")
		return true
	else
		djui_chat_message_create(lang().INVALIDBOOL)
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
            obj_set_model_extended(o, smlua_model_util_get_id(gPlayerSyncTable[i].modelId.."_geo"))
        end
    end
end)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)