Locales = Locales or {}

local function applyLocale()
    Config = Config or {}
    Config.GLOBAL = Config.GLOBAL or {}

    local locale = Config.GLOBAL.locale or 'en'
    local selected = Locales[locale] or Locales['en'] or {}

    Config.GLOBAL.lang = selected
end

applyLocale()
