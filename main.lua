-- name: Hog Skin Selector 
-- description: Have this Cool Skin Selector in your hands!\nYou can add \#FFAA00\Skin Mods\#ffffff\ or make yours, its your choice bud.
--Settings--
local option = 1
ref = {
	save=1,
	load=2,
	style=3,
	theme=4,
	scale=5,
	pattern=6,
	ion=7,
	r=8,
	g=9,
	b=10,
	onstart=11,
	prefskinstart=12,
	bind=13,
	notes=14,
}
settings = {
	[ref.style] = {
		savename = 'style',
		name = 'UI Style',
		default = 1,
		toggles = {'Hog', 'Coop', 'Worst UI'}
	},
	[ref.ion] = {
		savename = 'introonscroll',
		name = 'Intro on Scroll',
		default = 1,
		toggles = {'OFF', 'ON'}
	},
	[ref.theme] = {
		savename = 'theme',
		name = 'Theme',
		default = 1,
		toggles = {'Dark', 'Light', 'Dark Blue', 'Forest Green', 'Marianus Red', "Char Color", "Custom"}
	},
	[ref.load] = {
		name = 'Set as Pref Skin',
		func = function()
			savePrefSkin()
		end,
	},
	[ref.save] = {
		name = 'Load Pref Skin',
		func = function()
			loadPrefSkin()
		end,
	},
	[ref.onstart] = {
		savename = 'menuonstartup',
		name = 'Skins Menu on Startup',
		default = 2,
		toggles = {'OFF', 'ON'}
	},
	[ref.prefskinstart] = {
		savename = 'prefonstartup',
		name = 'Load Pref Skin on Startup',
		default = 2,
		toggles = {'OFF', 'ON'} 
	},
	[ref.notes] = {
		savename = 'notifiesyippee',
		name = 'Notifies',
		default = 2,
		toggles = {'OFF', 'ON'} 
	},
	[ref.bind] = {
		savename = 'bind',
		name = 'Bind',
		default = 2,
		toggles = {'OFF', 'D-Pad Down (R + D-Pad Down if OMM Rebirth Enabled)', 'R Button'} 
	},
	[ref.r] = {
		savename = 'r',
		name = 'Custom Red',
		default = 0,
		min = 0,
		max = 100,
	},
	[ref.g] = {
		savename = 'g',
		name = 'Custom Green',
		default = 0,
		min = 0,
		max = 100,
	},
	[ref.b] = {
		savename = 'b',
		name = 'Custom Blue',
		default = 0,
		min = 0,
		max = 100,
	},
	[ref.scale] = {
		savename = 'scale',
		name = 'UI Scale',
		default = 2,
		min = 1,
		max = 3
	},
	[ref.pattern] = {
		savename = 'pattern',
		name = 'Pattern',
		default = 2,
		toggles = {'None', 'Coin', 'Star', 'Checkboard'} 
	},
}
for i = 1, #settings do
	if settings[i].toggles ~= nil then
		settings[i].max = #settings[i].toggles
		settings[i].min = 1
	end
	if settings[i].savename ~= nil then
		if mod_storage_load(settings[i].savename) ~= nil then
			settings[i].value = tonumber(mod_storage_load(settings[i].savename))
		else
			settings[i].value = settings[i].default
		end
	end
end
--Skins--
local E_MODEL_YOSHI_PLAYER = smlua_model_util_get_id("yoshi_player_geo")
local E_MODEL_PEACH_PLAYER = smlua_model_util_get_id("peach_player_geo")
local E_MODEL_KOOPA_PLAYER = smlua_model_util_get_id("koopa_player_geo")
local curSelected = 1
skins = {
    {
        name = "Default"
    },
    {
        name = "Mario",
        model = E_MODEL_MARIO, 
        credits = "Nintendo Company Ltd.",
        color = {255,0,0}
    },
    {
        name = "Luigi",
        model = E_MODEL_LUIGI,
        credits = "Nintendo Company Ltd.",
        color = {0,200,0}
    },
    {
        name = "Wario",
        model = E_MODEL_WARIO, 
        credits = "Nintendo Company Ltd.",
        color = {255,255,0}
    },
    {
        name = "Toad",
        model = E_MODEL_TOAD_PLAYER, 
        credits = "Nintendo Company Ltd.",
        color = {255,255,255}
    },
    {
        name = "Koopa",
        model = E_MODEL_KOOPA_PLAYER, 
        credits = "Nintendo Company Ltd.",
        color = {0,255,0}
    },
    {
        name = "Peach",
        model = E_MODEL_PEACH_PLAYER, 
        credits = "Nintendo Company Ltd.",
        color = {255,128,128}
    },
    {
        name = "Yoshi",
        model = E_MODEL_YOSHI_PLAYER, 
        credits = "Nintendo Company Ltd.",
        color = {0,255,0}
    },
}
--Variables for Menus--
local bg = {0,0,0}
local text = {0,0,0}
local tweenthing = 1
local tweenthing2 = 1
local offsetforselections = 0
local offsetforbg = 0
local checkboard = get_texture_info('checkboard')
local page = 1
local menuscale = 1
local texts = {}
local firsttime = mod_storage_load('firsttime') or 'y'
local midScreenWidth = 0
if firsttime == 'y' then
	menu = 'instructions'
else
	if settings[ref.onstart].value == 2 then
		menu = "skins"
	else
		menu = "none"
	end
end
--Menus--
function doABackdrop()
	djui_hud_set_color(bg[1], bg[2], bg[3], 100)
	djui_hud_render_rect(0, 0, djui_hud_get_screen_width(), djui_hud_get_screen_height())
	local tex = gTextures.star
	if settings[ref.pattern].stringvalue ~= "None" then
		if settings[ref.pattern].stringvalue == "Coin" then
			tex = gTextures.coin
		elseif settings[ref.pattern].stringvalue == "Star" then
			tex = gTextures.star
		elseif settings[ref.pattern].stringvalue == "Checkboard" then
			tex = checkboard
		end
		for x = 1, 16 do
			for y = 1, 8 do
				djui_hud_render_texture(tex, ((32*(x-1))-offsetforbg)*4, ((32*(y-1))-offsetforbg)*4, 4, 4)
			end
		end
	end
end
function on_hud_render()
	local texts = {
		{
			{"Skins Menu:", true},
			{'Left/Right: Change Skin'},
			{'A Button: Close'},
			{'B Button: Go to Settings'},
			{"Settings Menu:", true},
			{'Up/Down: Change Selected Option'},
			{'Left/Right: Change Option Value'},
			{'A Button: Makes the Option do something (only if dosent have value)'},
			{'B Button: Go Back'}
		},
		{
			{'To Re-Open the Menu'},
			{'Use the command: "/open-skins-menu"'},
			{'Or Press '..(_G.OmmEnabled and "R + D-Pad Down" or "D-Pad Down")}
		},
		{
			{'Tips', true},
			{'Press L to scroll faster'}
		}
	}
	midScreenWidth = djui_hud_get_screen_width()/2
	offsetforbg = (offsetforbg+1)%33
	if settings[ref.scale].value == 1 then
		menuscale = 0.75
	end
	if settings[ref.scale].value == 2 then
		menuscale = 1
	end
	if settings[ref.scale].value == 3 then
		menuscale = 1.25
	end
	if settings[ref.theme].stringvalue == 'Light' then
		bg = {255,255,255}
		text = {0,0,0}
	elseif settings[ref.theme].stringvalue == 'Dark' then
		bg = {0,0,0}
		text = {255,255,255}
	elseif settings[ref.theme].stringvalue == 'Dark Blue' then
		bg = {0,0,100}
		text = {255,255,255}
	elseif settings[ref.theme].stringvalue == 'Forest Green' then
		bg = {0,105,0}
		text = {255,255,255}
	elseif settings[ref.theme].stringvalue == 'Marianus Red' then
		bg = {255,10,10}
		text = {255,255,255}
	elseif settings[ref.theme].stringvalue == 'Custom' then
		bg = {255*(settings[ref.r].value/100),255*(settings[ref.g].value/100),255*(settings[ref.b].value/100)}
		text = {255,255,255}
	elseif settings[ref.theme].stringvalue == "Char Color" then
		if skins[curSelected].color ~= nil then
		    bg[1] = funnyLerp(bg[1], skins[curSelected].color[1] or 0, 0.10)
			bg[2] = funnyLerp(bg[2], skins[curSelected].color[2] or 0, 0.10)
		    bg[3] = funnyLerp(bg[3], skins[curSelected].color[3] or 0, 0.10)
		else
			bg[1] = funnyLerp(bg[1], 0, 0.10)
			bg[2] = funnyLerp(bg[2], 0, 0.10)
		    bg[3] = funnyLerp(bg[3], 0, 0.10)
		end
		text = {255,255,255}
	end
	if menu ~= "none" then
		if not ((menu == "skins" and settings[ref.style].stringvalue ~= 'Hog') or menu == "instructions") then
			local scale = 3*menuscale
			doABackdrop()
			djui_hud_set_color(bg[1], bg[2], bg[3], 100)
		    djui_hud_render_rect(0, -((21*tweenthing)*scale), djui_hud_get_screen_width(), 21*scale)
		    djui_hud_set_color(255,255,255,255)
		    djui_hud_set_font(FONT_HUD)
		    local textmidwidth = (djui_hud_measure_text(menu)*scale)/2
		    djui_hud_print_text(menu, (djui_hud_get_screen_width()/2)-textmidwidth, 10-((32*tweenthing)*scale), scale)
			tweenthing = funnyLerp(tweenthing, 0, 0.10)
	        tweenthing2 = funnyLerp(tweenthing2, 0, 0.10)
		end
	end
	if menu == 'instructions' then
		doABackdrop()
		djui_hud_render_outline_rect(10, 10, djui_hud_get_screen_width()-20, djui_hud_get_screen_height()-20, {0,0,0,255})
		djui_hud_set_font(FONT_HUD)
		djui_hud_set_color(255, 255, 255, 255)
        local textmidwidth = (djui_hud_measure_text("INSTRUCTIONS")*3.5)/2
		djui_hud_print_text("INSTRUCTIONS", midScreenWidth-textmidwidth, 30, 3.5)
		djui_hud_set_font(FONT_NORMAL)
		for i = 1, #texts[page] do
			local textmidwidth = (djui_hud_measure_text(texts[page][i][1])*(texts[page][i][2] == true and 2 or 1.5))/2
			djui_hud_print_text(texts[page][i][1], midScreenWidth-textmidwidth, 87+(20*(i-1)), texts[page][i][2] == true and 2 or 1.5)
		end
		djui_hud_set_font(FONT_HUD)
		if page < #texts then
			local textmidwidth = (djui_hud_measure_text("PRESS A TO CONTINUE")*2)/2
			djui_hud_print_text("PRESS A TO CONTINUE", midScreenWidth-textmidwidth, djui_hud_get_screen_height()-65, 2)
		else
			local textmidwidth = (djui_hud_measure_text("PRESS A TO CLOSE")*2)/2
			djui_hud_print_text("PRESS A TO CLOSE", midScreenWidth-textmidwidth, djui_hud_get_screen_height()-65, 2)
		end
    elseif menu == "skins" then
        local text1 = "< "..skins[curSelected].name.." >"
        local text2 = "By "..(skins[curSelected].credits or "Unknown Author")
        local text4 = skins[curSelected].info or {""}
        if settings[ref.style].stringvalue == 'Coop' then
            local scale = 1.5*menuscale
            djui_hud_render_outline_rect(0, 0, djui_hud_get_screen_width()/3, djui_hud_get_screen_height(), {0,0,0,255})
            djui_hud_set_font(FONT_MENU)
            djui_hud_set_color(255, 255, 255, 255)
            local textmidwidth = (djui_hud_measure_text("SKINS")*(scale-0.5))/2
            djui_hud_print_text("SKINS", ((djui_hud_get_screen_width()/3)/2)-textmidwidth, 10, scale-0.5)
            djui_hud_set_font(FONT_NORMAL)
            djui_hud_render_outline_rect(10, 50*scale, djui_hud_get_screen_width()/3.2, 32*scale, {255,255,255,255})
            djui_hud_set_color(0, 0, 0, 255)
            djui_hud_print_text(text1, 12*scale, 50*scale, scale)
            if skins[curSelected].model ~= nil then
                djui_hud_set_color(255, 255, 255, 255)
                djui_hud_print_text(text2, 10*scale, 87*scale, scale-0.5)
                djui_hud_set_color(0, 0, 0, 255)
				for i = 1, #text4 do
		            local w = djui_hud_measure_text(text4[i])
					local scale = 1.5*menuscale
		            djui_hud_print_text(text4[i], (djui_hud_get_screen_width()-((w+5)*scale)), (djui_hud_get_screen_height()-(48*#text4))+(48*(i-1)), scale)
				end
            end
        elseif settings[ref.style].stringvalue == 'Worst UI' then
	        djui_hud_print_text('< '..skins[curSelected].name..' >', 10, 10, 2)
        elseif settings[ref.style].stringvalue == 'Hog' then
	        local scale = 3*menuscale
			djui_hud_set_color(text[1], text[2], text[3], 255)
	        djui_hud_set_font(FONT_NORMAL)
	        local w = djui_hud_measure_text(text1)
			djui_hud_print_text(text1, midScreenWidth-((w*scale)/2), 64-(100*tweenthing), scale)
			if skins[curSelected-1] ~= nil then
				djui_hud_print_text(skins[curSelected-1].name, 5*scale, 64-(100*tweenthing), scale)
			end
			if skins[curSelected+1] ~= nil then
				local text1 = skins[curSelected+1].name
				local w = djui_hud_measure_text(text1)
				djui_hud_print_text(text1, djui_hud_get_screen_width()-((w+5)*scale), 64-(100*tweenthing), scale)
			end
	        if skins[curSelected].model ~= nil then
				djui_hud_set_color(255, 255, 255, 255)
	            djui_hud_set_font(FONT_HUD)
	            local w = djui_hud_measure_text(text2)
	            djui_hud_print_text(text2, (5-((w+5)*tweenthing2))*scale, djui_hud_get_screen_height()-(20*scale), scale-0.5)
				djui_hud_set_color(text[1], text[2], text[3], 255)
	            djui_hud_set_font(FONT_NORMAL)
				for i = 1, #text4 do
		            local w = djui_hud_measure_text(text4[i])
					local scale = 1.5*menuscale
		            djui_hud_print_text(text4[i], (djui_hud_get_screen_width()-((w+5)*scale))+(((w+5)*tweenthing2)*scale), (djui_hud_get_screen_height()-(48*#text4))+(48*(i-1)), scale)
				end
	        end
		end
    end
    if menu == "settings" then
	    if settings[ref.scale].value == 1 then
			limit = 13
		end
		if settings[ref.scale].value == 2 then
			limit = 10
		end
		if settings[ref.scale].value == 3 then
			limit = 7
		end
	    if option > limit then
		    offsetforselections = option-limit
		else
			offsetforselections = 0
		end
		local scale = 2*menuscale
        djui_hud_set_color(text[1], text[2], text[3], 255)
        djui_hud_set_font(FONT_NORMAL)
	    for i = 1, #settings do
			local y = (10+(32*(i-offsetforselections)))*scale
			if settings[i].func == nil then
				if settings[i].toggles ~= nil then
					value = settings[i].toggles[settings[i].value]
				else
					value = settings[i].value
				end
			else
				value = ""
			end
			if y < djui_hud_get_screen_height() then
				if value == "" then
			        djui_hud_print_text((i == option and '> ' or '')..settings[i].name, 10*scale, y, scale)
				else
					djui_hud_print_text((i == option and '> ' or '')..settings[i].name..': '..(i == option and '< ' or '')..value..(i == option and ' >' or ''), 10*scale, y, scale)
				end
			end
		end
    end
end

--Update Variables--
local timer = 0
local stallFrame = 0
local prefskinloadedonstartup = false
local camAngle = 0
--Update For Almost Everything--
function mario_update_local(m)
    if settings[ref.prefskinstart].value == 2 and mod_storage_load("prefskin") ~= nil then
	    if prefskinloadedonstartup == false then
			loadPrefSkin()
			prefskinloadedonstartup = true
		end
	end
	local stall = (m.controller.buttonDown & L_TRIG) ~= 0 and 0.05 or 0.25
	timer = math.max(timer-0.025, 0)
    if menu == "skins" then
	    if timer == 0 then
	        if m.controller.stickX < -60 then
                play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
	            change(-1)
				timer = stall
            end
            if m.controller.stickX > 60 then
                play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
	            change(1)
				timer = stall
            end
		end
		if (m.controller.buttonPressed & A_BUTTON) ~= 0 then
            play_sound(SOUND_MENU_STAR_SOUND_OKEY_DOKEY, m.marioObj.header.gfx.cameraToObject)
            menu = "none"
            tweenthing = 1
            tweenthing2 = 1
        end
        if (m.controller.buttonPressed & B_BUTTON) ~= 0 then
	        menu = "settings"
		end
    elseif menu == "settings" then
	    if timer == 0 then
		    if m.controller.stickY < -60 then
                play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
	            changeOptionA(1)
				timer = stall
            end
            if m.controller.stickY > 60 then
	            play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
	            changeOptionA(-1)
				timer = stall
            end
        end
        if settings[option].func == nil then
	        if timer == 0 then
			    if m.controller.stickX < -60 then
	                play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
		            changeOptionB(-1)
					timer = stall
	            end
	            if m.controller.stickX > 60 then
		            play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
		            changeOptionB(1)
					timer = stall
	            end
	        end
		else
	        if (m.controller.buttonPressed & A_BUTTON) ~= 0 then
	            play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
	            settings[option].func()
	        end
		end
		if (m.controller.buttonPressed & B_BUTTON) ~= 0 then
	        menu = "skins"
			saveSettings()
		end
	elseif menu == "instructions" then
		if (m.controller.buttonPressed & A_BUTTON) ~= 0 then
			if page < #texts then
				play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
				page = page + 1
			else
		        if firsttime == 'y' then
					menu = "skins"
					firsttime = 'n'
					mod_storage_save('firsttime', 'n')
				else
					menu = "none"
				end
				play_sound(SOUND_COIN, m.marioObj.header.gfx.cameraToObject)
			end
		end
    elseif menu == "none" then
	    local bind = false
	    if settings[ref.bind].value ~= 1 then
			if settings[ref.bind].value == 2 then
				if _G.OmmEnabled then
					bind = ((m.controller.buttonPressed & D_JPAD) ~= 0 and (m.controller.buttonDown & R_TRIG) ~= 0) and true
				else
					bind = ((m.controller.buttonPressed & D_JPAD) ~= 0) and true
				end
			end
			if settings[ref.bind].value == 3 then
				bind = ((m.controller.buttonPressed & R_BUTTON) ~= 0) and true
			end
	        if bind then
		        if menu == "none" then
				    menu = "skins"
				end
	        end
        end
    end
    
    if menu ~= "none" then
	    set_mario_action(m, ACT_IDLE, 0)
	    set_mario_animation(m, MARIO_ANIM_FIRST_PERSON)
    end
    
    for i = 1, #settings do
	    if settings[i].toggles ~= nil then
		    settings[i].stringvalue = settings[i].toggles[settings[i].value]
		end
	end
	
    gPlayerSyncTable[0].modelId = skins[curSelected].model
	gPlayerSyncTable[0].skin = curSelected
	
end
for i = 0, (MAX_PLAYERS-1) do
	local s = gPlayerSyncTable[i]
	s.skin = 1
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
    if menu ~= "none" then
        m.vel.x = 0
        m.vel.y = math.min(m.vel.y,0)
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
    if settings[ref.ion].value == 2 then
        tweenthing2 = 1
    end
end
function anotherchangefunction(num)
    thesettingselectedonthepanel = thesettingselectedonthepanel + num
    if thesettingselectedonthepanel > #panelthings then
        thesettingselectedonthepanel = 1
    elseif curSelected < 1 then
        thesettingselectedonthepanel = #udk
    end
end
function changeOptionB(num)
    settings[option].value  = settings[option].value + num
    if settings[option].value > settings[option].max then
        settings[option].value = settings[option].min
    elseif settings[option].value < settings[option].min then
        settings[option].value = settings[option].max
    end
end
function changeOptionA(num)
    option = option + num
    if option > #settings then
        option = 1
    elseif option < 1 then
        option = #settings
    end
end
function saveSettings()
	for i = 1, #settings do
		if settings[i].savename ~= nil then
			mod_storage_save(settings[i].savename, tostring(settings[i].value))
		end
	end
end
function savePrefSkin()
	if curSelected > 1 then
		mod_storage_save("prefskin", removeSpaces(skins[curSelected].name))
		if settings[ref.notes].value == 2 then
	        djui_popup_create('"' .. skins[curSelected].name .. '"\nwas set as preferred successfully!', 2)
	    end
	else
		if settings[ref.notes].value == 2 then
	        djui_popup_create("You can't set the Default One as preferred", 2)
	    end
	end
end
function loadPrefSkin()
	local prefskin = mod_storage_load("prefskin")
	if prefskin ~= nil then
        for i = 2, #skins do
            if removeSpaces(skins[i].name) == prefskin then
                curSelected = i
                if settings[ref.notes].value == 2 then
                    djui_popup_create('Your Preferred Skin\n"' .. skins[i].name .. '"\nwas applied successfully!', 3)
                end
                return true
            end
        end
        if settings[ref.notes].value == 2 then
			djui_popup_create("The Skin dosen't exists or The Skin Mod isn't on,\nPlease try turn it on.", 2)
		end
	else
		if settings[ref.notes].value == 2 then
			djui_popup_create("You don't have a preferred skin yet!\nYou need to set a preferred skin to load it.", 2)
		end
	end
end
hook_chat_command("open-skins-menu", "| open the skins menu", function(arg)
	if menu == "none" then
	    menu = "skins"
    end
    return true
end)
hook_chat_command("hss-help", "| see how to use the all.", function(arg)
	if menu == "none" then
	    menu = "instructions"
		page = 1
    end
    return true
end)
hook_event(HOOK_BEFORE_PHYS_STEP, mario_before_phys_step)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_MARIO_UPDATE, mario_update)
