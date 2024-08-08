-- name: Hog Skin Selector 
-- description: XD
--Options--
local option = 1
local options = {
	{
		savename = 'style',
		name = 'UI Style',
		default = 1,
		toggles = {'Hog', 'Coop', 'Worst UI'}
	},
	{
		savename = 'introonscroll',
		name = 'Intro on Scroll',
		default = 1,
		toggles = {'OFF', 'ON'}
	},
	{
		savename = 'theme',
		name = 'Theme',
		default = 1,
		toggles = {'Dark', 'Light', 'Dark Blue', 'Forest Green', 'Marianus Red', "Custom"}
	},
	{
		name = 'Set as Pref Skin',
		func = function()
			savePrefSkin()
		end,
	},
	{
		name = 'Load Pref Skin',
		func = function()
			loadPrefSkin()
		end,
	},
	{
		savename = 'menuonstartup',
		name = 'Skins Menu on Startup',
		default = 2,
		toggles = {'OFF', 'ON'}
	},
	{
		savename = 'prefonstartup',
		name = 'Load Pref Skin on Startup',
		default = 2,
		toggles = {'OFF', 'ON'} 
	},
	{
		savename = 'notifiesyippee',
		name = 'Notifies',
		default = 2,
		toggles = {'OFF', 'ON'} 
	},
	{
		savename = 'camspeed',
		name = 'Rotating Cam Speed',
		default = 1,
		toggles = {'Slow', 'Mid', 'Fast'} 
	},
	{
		savename = 'bind',
		name = 'D-Pad Down Bind',
		default = 1,
		toggles = {'OFF', 'ON'} 
	},
	{
		savename = 'r',
		name = 'Custom Red',
		default = 0,
		min = 0,
		max = 255,
	},
	{
		savename = 'g',
		name = 'Custom Green',
		default = 0,
		min = 0,
		max = 255,
	},
	{
		savename = 'b',
		name = 'Custom Blue',
		default = 0,
		min = 0,
		max = 255,
	},
	{
		savename = 'scale',
		name = 'UI Scale',
		default = 2,
		min = 1,
		max = 3
	},
	{
		savename = 'pattern',
		name = 'Pattern',
		default = 2,
		toggles = {'None', 'Coin', 'Star', 'Checkboard'} 
	},
}
for i = 1, #options do
	if options[i].toggles ~= nil then
		options[i].max = #options[i].toggles
		options[i].min = 1
	end
	if options[i].savename ~= nil then
		if mod_storage_load(options[i].savename) ~= nil then
			options[i].value = tonumber(mod_storage_load(options[i].savename))
		else
			options[i].value = options[i].default
		end
	end
end
--Skins--
local curSelected = 1
skins = {
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
        name = "Bowser",
        model = E_MODEL_BOWSER, 
        credits = "Nintendo Company Ltd.",
        origin = "Super Mario 64",
    },
    {
        name = "Star",
        model = E_MODEL_STAR,
        info = {"That star got stuck in the floor."},
        credits = "Nintendo Company Ltd.",
        origin = "Super Mario 64",
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
local texts = {
	{
		{"Skins Menu:", true},
		{'Left/Right: Change Skin'},
		{'A Button: Close'},
		{'B Button: Go to Options'},
		{"Options Menu:", true},
		{'Up/Down: Change Selected Option'},
		{'Left/Right: Change Option Value'},
		{'A Button: Makes the Option do something (only if dosent have value)'},
		{'B Button: Go Back'},
	},
	{
		{'To Re-Open the Menu'},
		{'Use the command: "/open-skins-menu"'},
	}
}
local firsttime = mod_storage_load('firsttime') or 'y'
if firsttime == 'y' then
	menu = 'instructions'
else
	if options[6].value == 2 then
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
	if options[15].stringvalue ~= "None" then
		if options[15].stringvalue == "Coin" then
			tex = gTextures.coin
		elseif options[15].stringvalue == "Star" then
			tex = gTextures.star
		elseif options[15].stringvalue == "Checkboard" then
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
	offsetforbg = (offsetforbg+1)%33
	if options[14].value == 1 then
		menuscale = 0.75
	end
	if options[14].value == 2 then
		menuscale = 1
	end
	if options[14].value == 3 then
		menuscale = 1.25
	end
	if options[3].stringvalue == 'Light' then
		bg = {255,255,255}
		text = {0,0,0}
	elseif options[3].stringvalue == 'Dark' then
		bg = {0,0,0}
		text = {255,255,255}
	elseif options[3].stringvalue == 'Dark Blue' then
		bg = {0,0,100}
		text = {255,255,255}
	elseif options[3].stringvalue == 'Forest Green' then
		bg = {0,105,0}
		text = {255,255,255}
	elseif options[3].stringvalue == 'Marianus Red' then
		bg = {255,10,10}
		text = {255,255,255}
	elseif options[3].stringvalue == 'Custom' then
		bg = {options[11].value,options[12].value,options[13].value}
		text = {255,255,255}
	end
	if menu == 'instructions' then
		doABackdrop()
		djui_hud_render_outline_rect(10, 10, djui_hud_get_screen_width()-20, djui_hud_get_screen_height()-20, {0,0,0,255})
		djui_hud_set_font(FONT_HUD)
		djui_hud_set_color(255, 255, 255, 255)
		local bgmidwidth = djui_hud_get_screen_width()/2
        local textmidwidth = (djui_hud_measure_text("INSTRUCTIONS")*3.5)/2
		djui_hud_print_text("INSTRUCTIONS", bgmidwidth-textmidwidth, 30, 3.5)
		djui_hud_set_font(FONT_NORMAL)
		for i = 1, #texts[page] do
			local textmidwidth = (djui_hud_measure_text(texts[page][i][1])*(texts[page][i][2] == true and 2 or 1.5))/2
			djui_hud_print_text(texts[page][i][1], bgmidwidth-textmidwidth, 87+(20*(i-1)), texts[page][i][2] == true and 2 or 1.5)
		end
		djui_hud_set_font(FONT_HUD)
		if page < #texts then
			local textmidwidth = (djui_hud_measure_text("PRESS A TO CONTINUE")*2)/2
			djui_hud_print_text("PRESS A TO CONTINUE", bgmidwidth-textmidwidth, djui_hud_get_screen_height()-65, 2)
		else
			local textmidwidth = (djui_hud_measure_text("PRESS A TO CLOSE")*2)/2
			djui_hud_print_text("PRESS A TO CLOSE", bgmidwidth-textmidwidth, djui_hud_get_screen_height()-65, 2)
		end
    elseif menu == "skins" then
        local text1 = "< "..skins[curSelected].name.." >"
        local text2 = "By "..(skins[curSelected].credits or "Unknown Author")
        local text3 = "From "..(skins[curSelected].origin or "???")
        local text4 = skins[curSelected].info or {""}
        if options[1].stringvalue == 'Coop' then
            local scale = menuscale
            djui_hud_render_outline_rect(0, 0, djui_hud_get_screen_width()/3, djui_hud_get_screen_height(), {0,0,0,255})
            djui_hud_set_font(FONT_MENU)
            djui_hud_set_color(255, 255, 255, 255)
            local bgmidwidth = (djui_hud_get_screen_width()/3)/2
            local textmidwidth = (djui_hud_measure_text("Skins")*(scale-0.5))/2
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
        elseif options[1].stringvalue == 'Worst UI' then
	        djui_hud_print_text('< '..skins[curSelected].name..' >', 10, 10, 2)
        elseif options[1].stringvalue == 'Hog' then
	        doABackdrop()
	        tweenthing = funnyLerp(tweenthing, 0, 0.10)
	        tweenthing2 = funnyLerp(tweenthing2, 0, 0.10)
	        local scale = 3*menuscale
			local bgmidwidth = djui_hud_get_screen_width()/2
			djui_hud_set_color(text[1], text[2], text[3], 255)
	        djui_hud_set_font(FONT_NORMAL)
	        local w = djui_hud_measure_text(text1)
			djui_hud_print_text(text1, bgmidwidth-((w*scale)/2), 64-(100*tweenthing), scale)
			if skins[curSelected-1] ~= nil then
				djui_hud_print_text(skins[curSelected-1].name, 5*scale, 64-(100*tweenthing), scale)
			end
			if skins[curSelected+1] ~= nil then
				local text1 = skins[curSelected+1].name
				local w = djui_hud_measure_text(text1)
				djui_hud_print_text(text1, djui_hud_get_screen_width()-((w+5)*scale), 64-(100*tweenthing), scale)
			end
			djui_hud_set_color(bg[1], bg[2], bg[3], 100)
	        djui_hud_render_rect(0, -((21*tweenthing)*scale), djui_hud_get_screen_width(), 21*scale)
	        djui_hud_set_color(255,255,255,255)
	        djui_hud_set_font(FONT_HUD)
	        local textmidwidth = (djui_hud_measure_text("Skins")*scale)/2
	        djui_hud_print_text("Skins", bgmidwidth-textmidwidth, 10-((32*tweenthing)*scale), scale)
	        if skins[curSelected].model ~= nil then
				djui_hud_set_color(255, 255, 255, 255)
	            djui_hud_set_font(FONT_HUD)
	            local w = djui_hud_measure_text(text2)
	            djui_hud_print_text(text2, (5-((w+5)*tweenthing2))*scale, djui_hud_get_screen_height()-(33*scale), scale-0.5)
				local w = djui_hud_measure_text(text3)*(scale-1)
	            djui_hud_print_text(text3, (5-((w+5)*tweenthing2))*scale, ((djui_hud_get_screen_height())-21*(scale-1)), scale-1)
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
    if menu == "options" then
	    if options[14].value == 1 then
			limit = 14
		end
		if options[14].value == 2 then
			limit = 11
		end
		if options[14].value == 3 then
			limit = 8
		end
	    if option > limit then
		    offsetforselections = option-limit
		else
			offsetforselections = 0
		end
	    local scale = 2*menuscale
		doABackdrop()
        djui_hud_set_color(text[1], text[2], text[3], 255)
        djui_hud_set_font(FONT_NORMAL)
	    for i = 1, #options do
			local y = (10+(32*(i-(1+offsetforselections))))*scale
			if y < djui_hud_get_screen_height() then
		        djui_hud_print_text((i == option and '> ' or '')..options[i].name, 10*scale, y, scale)
				if options[i].func == nil then
					if options[i].toggles ~= nil then
						value = options[i].toggles[options[i].value]
					else
						value = options[i].value
					end
					local text = (i == option and '< ' or '')..value..(i == option and ' >' or '')
					local w = djui_hud_measure_text(text)
					djui_hud_print_text(text, djui_hud_get_screen_width()-((w+10)*scale), y, scale)
				end
			end
		end
    end
    --bg = {funnyLerp(bg[1], skins[curSelected].color[1] or 50, 0.10),funnyLerp(bg[1], skins[curSelected].color[1] or 0, 0.10),funnyLerp(bg[3], skins[curSelected].color[3] or 100, 0.10)}
end

--Update Variables--
local timer = 0
local stallFrame = 0
local prefskinloadedonstartup = false
local camAngle = 0
--Update For Almost Everything--
function mario_update_local(m)
    if options[7].value == 2 and mod_storage_load("prefskin") ~= nil then
	    if prefskinloadedonstartup == false then
			loadPrefSkin()
			prefskinloadedonstartup = true
		end
	end
	timer = math.max(timer-0.025, 0)
    if menu == "skins" then
	    if timer == 0 then
	        if m.controller.stickX < -60 then
                play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
	            change(-1)
				timer = 0.25
            end
            if m.controller.stickX > 60 then
                play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
	            change(1)
				timer = 0.25
            end
		end
		if (m.controller.buttonPressed & A_BUTTON) ~= 0 then
            play_sound(SOUND_MENU_STAR_SOUND_OKEY_DOKEY, m.marioObj.header.gfx.cameraToObject)
            menu = "none"
            tweenthing = 1
            tweenthing2 = 1
        end
        if (m.controller.buttonPressed & B_BUTTON) ~= 0 then
	        menu = "options"
		end
    elseif menu == "options" then
	    if timer == 0 then
		    if m.controller.stickY < -60 then
                play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
	            changeOptionA(1)
				timer = 0.25
            end
            if m.controller.stickY > 60 then
	            play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
	            changeOptionA(-1)
				timer = 0.25
            end
        end
        if options[option].func == nil then
	        if timer == 0 then
			    if m.controller.stickX < -60 then
	                play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
		            changeOptionB(-1)
					timer = 0.25
	            end
	            if m.controller.stickX > 60 then
		            play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
		            changeOptionB(1)
					timer = 0.25
	            end
	        end
		else
	        if (m.controller.buttonPressed & A_BUTTON) ~= 0 then
	            play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
	            options[option].func()
	        end
		end
		if (m.controller.buttonPressed & B_BUTTON) ~= 0 then
	        menu = "skins"
			saveOptions()
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
				play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
			end
		end
    elseif menu == "none" then
	    if options[10].value == 2 then
	        if (m.controller.buttonPressed & D_JPAD) ~= 0 then
		        if menu == "none" then
				    menu = "skins"
				end
	        end
        end
    end
    
    for i = 1, #options do
	    if options[i].toggles ~= nil then
		    options[i].stringvalue = options[i].toggles[options[i].value]
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
        set_mario_action(m, ACT_IDLE, 0)
	    set_mario_animation(m, MARIO_ANIM_FIRST_PERSON)
    end
end

function change(num)
    curSelected = curSelected + num
    if curSelected > #skins then
        curSelected = 1
    elseif curSelected < 1 then
        curSelected = #skins
    end
    if options[2].value == 2 then
        tweenthing2 = 1
    end
end
function anotherchangefunction(num)
    theoptionselectedonthepanel = theoptionselectedonthepanel + num
    if theoptionselectedonthepanel > #panelthings then
        theoptionselectedonthepanel = 1
    elseif curSelected < 1 then
        theoptionselectedonthepanel = #udk
    end
end
function changeOptionB(num)
    options[option].value  = options[option].value + num
    if options[option].value > options[option].max then
        options[option].value = options[option].min
    elseif options[option].value < options[option].min then
        options[option].value = options[option].max
    end
end
function changeOptionA(num)
    option = option + num
    if option > #options then
        option = 1
    elseif option < 1 then
        option = #options
    end
end
function saveOptions()
	for i = 1, #options do
		if options[i].savename ~= nil then
			mod_storage_save(options[i].savename, tostring(options[i].value))
		end
	end
end
function savePrefSkin()
	if curSelected > 1 then
		mod_storage_save("prefskin", removeSpaces(skins[curSelected].name))
		if options[8].value == 2 then
	        djui_popup_create('"' .. skins[curSelected].name .. '"\nwas set as preferred successfully!', 2)
	    end
	else
		if options[8].value == 2 then
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
                if options[8].value == 2 then
                    djui_popup_create('Your Preferred Skin\n"' .. skins[i].name .. '"\nwas applied successfully!', 3)
                end
                return true
            end
        end
        if options[8].value == 2 then
			djui_popup_create("The Skin dosen't exists or The Skin Mod isn't on,\nPlease try turn it on.", 2)
		end
	else
		if options[8].value == 2 then
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
hook_chat_command("hss_help", "| see how to use the all.", function(arg)
	if menu == "none" then
	    menu = "instructions"
		page = 1
    end
    return true
end)
hook_event(HOOK_BEFORE_PHYS_STEP, mario_before_phys_step)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_MARIO_UPDATE, mario_update)