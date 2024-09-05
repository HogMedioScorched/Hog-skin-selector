function addSkin(name, info, credits, model, color)
	local info = info
    if type(info) == "string" then
	    info = split(info, '\n')
    end
    skins[#skins+1] = {
        name = name,
        info = info,
        credits = credits,
        model = model,
        color = color
    }
end
function editSkin(skin, name, info, credits, model, color)
	local id = 0
	for i = 2, #skins do
        if skins[i].name == skin then
            id = i
        end
    end
    local info = info
    if type(info) == "string" then
	    info = split(info, '\n')
    end
    skins[id] = {
        name = name,
        info = info,
        credits = credits,
        model = model,
        color = color
    }
end
function addToggle(savename, name, defaultValue)
    options[#options+1] = {
    	savename = savename,
		name = name,
		default = defaultValue == true and 2 or 1,
		toggles = {'OFF', 'ON'}
	}
end
function addFunction(savename, name, func)
    options[#options+1] = {
		name = name,
		func = func,
	}
end
function addText(savename, name, defaultValue, texts)
    options[#options+1] = {
		name = name,
		savename = savename,
		name = name,
		default = defaultValue,
		toggles = texts
	}
end
function addNumber(savename, name, minimumValue, maximumValue, defaultValue)
    options[#options+1] = {
    	savename = savename,
		name = name,
		default = defaultValue,
		min = minimumValue,
		max = maximumValue
	}
end
function getConfig(ref)
	return options[ref]
end
_G.hogSkinSelectorLoaded = true
_G.hogSkinSelector = {
	--Functions--
    addSkin = addSkin,
    addOption = {
		toggle = addToggle,
		text = addText,
		number = addNumber,
		func = addFunction
	},
    --Variables--
    getConfig = getConfig,
}
local function deluxetohss(name, description, credit, color, modelInfo, forceChar, lifeIcon, camScale)
    addSkin(name, description, credit, modelInfo, {color.r,color.g,color.b})
    return #skins
end
local function nono()
    return ":)"
end
_G.charSelectExists = true
_G.charSelect = _G.charSelect or {}
_G.charSelect.character_add = deluxetohss
_G.charSelect.character_edit = nono
_G.charSelect.character_add_voice = nono
_G.charSelect.character_add_caps = nono
_G.charSelect.character_add_celebration_star = nono
_G.charSelect.character_add_palette_preset = nono
_G.charSelect.character_get_current_table = nono
_G.charSelect.character_get_current_number = nono
_G.charSelect.character_get_number_from_string = nono
_G.charSelect.character_get_voice = nono
_G.charSelect.character_get_life_icon = nono
_G.charSelect.character_get_star_icon = nono

function update(m)
	_G.hogSkinSelector.options = options
end
hook_event(HOOK_UPDATE, update)
-- the text options have a text value (example: options[3].stringvalue)
