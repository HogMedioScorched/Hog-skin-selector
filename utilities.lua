function funnyLerp(value, target, ratio)
    return value + ((target - value) / (ratio*100))
end
function djui_hud_render_outline_rect(x, y, width, height, color)
    djui_hud_set_color(color[1], color[2], color[3], color[4]/2)
    djui_hud_render_rect(x, y, width, height)
    djui_hud_set_color(color[1], color[2], color[3], color[4])
    djui_hud_render_rect(x+5, y+5, width-10, height-10)
end
function removeSpaces(string)
    local s = ''
    for i = 1, #string do
        local c = string:sub(i,i)
        if c ~= " " then
            s = s .. c
        else
            s = s
        end
    end
    return s
end
function split(str, sep)
    local result = {}
    for match in (str):gmatch(string.format("[^%s]+", sep or "\n")) do
        table.insert(result, match)
    end
    return result
end
function floorDecimal(value, decimals) --just a port of Highscore.floorDecimal
	if decimals < 1 then
		return math.floor(value)
	end
	
	local tempMult = 1
	for i=1, decimals do
		tempMult = tempMult * 10
	end
	newValue = math.floor(value * tempMult)
	return newValue / tempMult
end
function min_max(v, min, max)
return math.max(math.min(v, max), min)
end
function djui_hud_render_stat(icon, display, separator, x, y, scale)
	djui_hud_render_texture(icon, x+0, y, scale)
    if separator then
        djui_hud_print_text(separator, x+(16*scale), y, scale)
        djui_hud_print_text(""..display, x+(32*scale), y, scale)
    else
        djui_hud_print_text(""..display, x+(16*scale), y, scale)
    end
end
function hexToRGB(hex_string)
    local r, g, b, a = 0, 0, 0, 0
    local colorhex = string.gsub(hex_string, "#", "")
    if (string.len(colorhex) == 6) then
        r = string.sub(colorhex, 0, 2)
        g = string.sub(colorhex, 3, 4)
        b = string.sub(colorhex, 5, 6)

        r = tonumber(r, 16)
        g = tonumber(g, 16)
        b = tonumber(b, 16)
        return {r = r, g = g, b = b}
    elseif (string.len(colorhex) == 8) then
        r = string.sub(colorhex, 0, 2)
        g = string.sub(colorhex, 3, 4)
        b = string.sub(colorhex, 5, 6)
        a = string.sub(colorhex, 7, 8)

        r = tonumber(r, 16)
        g = tonumber(g, 16)
        b = tonumber(b, 16)
        a = tonumber(a, 16)
        return {r = r, g = g, b = b, a = a}
    else
        print("Color format is invalid.")
        return
    end
end