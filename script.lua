local internet = require("internet")
local url = 'https://api.openweathermap.org/data/2.5/weather?zip=95828,us&units=imperial&appid=getUrOwn'

local file = internet.request(url)
local str = ''

-- Converts table to string
for line in file do str = str .. line end

local location = string.match(str, '"name":"(.-)"')

local function getValue(key)
    local pattern = '"%s*' .. key .. '%s*"%s*:%s*"?([^,}"]*)'
    local value = str:match(pattern)
    local numValue = tonumber(value)
    return numValue or value
end

local name = getValue('name')
local temp = getValue('temp')
local tempMin = getValue('temp_min')
local tempMax = getValue('temp_max')

local component = require("component")
local gpu = component.gpu

-- Set a lower resolution for larger text (80x25)
gpu.setResolution(100, 25)

while true do
    -- Clear the screen
    local name = getValue('name')
    local temp = getValue('temp')
    local tempMin = getValue('temp_min')
    local tempMax = getValue('temp_max')
    gpu.fill(1, 1, 80, 25, " ")

    -- Set cursor position and print the date in the middle of the screen
    local x = math.floor((80 - #name) / 2)
    local y = math.floor(25 / 2)

    gpu.set(x, y - 2, "Weather")
    gpu.set(x, y, "City of " .. name)
    gpu.set(x, y + 2, "Average: " .. temp .. "°F")
    gpu.set(x, y + 4, "High " .. tempMax .. "°F   Low " .. tempMin .. "°F")

    -- Sleep for 5 minutes before updating
    os.sleep(300)
end
