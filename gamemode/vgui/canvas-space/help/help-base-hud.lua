surface.CreateFont("DermaBold", {
    font = "Tahoma",
    size = 13,
    weight = 700,
    antialias = true,
})

surface.CreateFont("Disclaimer", {
    font = "Roboto",
    size = 38,
    weight = 400
})

local PANEL = {}
local BaseHUDisActive = false
local helpBase = nil
local languageMessages = {
    ["English"] = "This is a test server for a new gamemode I am working on.\nFeel free to join, but be warned you may get errors, server restarts or bugs.\nThere is also not any real \"content\" for the gamemode installed at this moment.\nYou may want to come back later :)",
    ["Spanish"] = "Este es un servidor de prueba para un nuevo modo de juego en el que estoy trabajando.\nSiéntete libre de unirte, pero ten en cuenta que podrías encontrarte con errores, reinicios del servidor o fallos.\nPor el momento, no hay contenido “real” del modo de juego instalado. Tal vez quieras volver más tarde :)",
    ["Portuguese"] = "Este é um servidor de teste para um novo modo de jogo em que estou trabalhando.\nSinta-se à vontade para entrar, mas atenção: você pode encontrar erros, reinicializações do servidor ou bugs.\nNo momento, não há nenhum “conteúdo” real do modo de jogo instalado. Talvez queira voltar mais tarde :)",
    ["Russian"] = "Это тестовый сервер для нового режима игры, над которым я работаю.\nМожете присоединяться, но учтите, что могут возникнуть ошибки, перезапуски сервера или баги.\nВ данный момент для режима игры нет никакого «реального» контента. Возможно, вы захотите вернуться позже :)",
    ["Chinese"] = "这是我正在开发的新游戏模式的测试服务器\n欢迎加入，但请注意，可能会遇到错误、服务器重启或其他漏洞。\n目前游戏模式还没有真正的“内容”，你可能想稍后再来 :)",
    ["Arabic"] = "هذا خادم تجريبي لوضع لعبة جديد أعمل عليه.\nلا تتردد في الانضمام، ولكن احذر قد تواجه أخطاء أو إعادة تشغيل للخادم أو بعض الأخطاء البرمجية.\nولا يوجد أي \"محتوى\" فعلي لوضع اللعبة مثبت في الوقت الحالي. قد ترغب في العودة لاحقًا :)"
}

vgui.Register("BaseHUD", PANEL, "EditablePanel")

function PANEL:Init()
    self:SetSize(ScrW() * 0.6, ScrH() * 0.6)
    self:SetPos(ScrW() * 0.2, ScrH() * 0.2)
    self:SetVisible(false)
    
    self.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30, 30, 40, 240))
    end
    
    self.closeButton = vgui.Create("DButton", self)
    self.closeButton:SetSize(32, 32)
    self.closeButton:SetPos(self:GetWide() - 40, 8)
    self.closeButton:SetText("")
    self.closeButton.Paint = function(s, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, Color(25, 25, 35, 255), true, true, true, true)
        draw.SimpleText("×", "DermaBold", (w / 2) - 2, (h / 2) - 2, Color(255, 128, 128), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.closeButton.DoClick = function()
        self:SetVisible(false)
        BaseHUDisActive = false
        gui.EnableScreenClicker(false)
    end

    -- Horizontal line below the close button
    self.lineY = 50 -- Y position of the line
    self.PaintOver = function(s, w, h)
        surface.SetDrawColor(Color(255, 255, 255, 50)) -- Light gray line
        surface.DrawLine(10, self.lineY, w - 10, self.lineY)
    end
    
    -- Register cards container
    self.registerCards = vgui.Create("DIconLayout", self)
    self.registerCards:SetPos(10, 10) -- Position below the close button
    self.registerCards:SetSize(630, self.lineY - 10) -- Height up to the line
    self.registerCards:SetSpaceX(5) -- Spacing between cards
    
    
    
    -- Styled scroll panel
    self.scrollPanel = vgui.Create("DScrollPanel", self)
    self.scrollPanel:SetPos(10, self.lineY + 10)
    self.scrollPanel:SetSize(self:GetWide() - 20, self:GetTall() - self.lineY - 20)
    self.scrollPanel:Dock(FILL)
    self.scrollPanel:DockMargin(10, self.lineY + 10, 10, 10)

    -- Style the scrollbar
    local sbar = self.scrollPanel:GetVBar()
    sbar:SetHideButtons(true)
    sbar.Paint = function(_, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(200, 200, 200))
    end
    sbar.btnGrip.Paint = function(_, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(150, 150, 150))
    end
    
    self:AddRegisterCard("English", self:CreateLanguageLayout("English"))
    self:AddRegisterCard("Español", self:CreateLanguageLayout("Spanish"))
    self:AddRegisterCard("Português", self:CreateLanguageLayout("Portuguese"))
    self:AddRegisterCard("Русский", self:CreateLanguageLayout("Russian"))
    self:AddRegisterCard("中文", self:CreateLanguageLayout("Chinese"))
    self:AddRegisterCard("العربية", self:CreateLanguageLayout("Arabic"))

    self:CloseAllCards()
    self:DrawCards(1)
    cards.layouts[1]:SetVisible(true)
end

function PANEL:CreateLanguageLayout(language)
    self.languageLayout = vgui.Create("DPanel", self.scrollPanel)
    self.languageLayout:SetSize(self.scrollPanel:GetWide(), self.scrollPanel:GetTall())
    self.languageLayout.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 10))
    end
    local languageRichText = vgui.Create("RichText", self.languageLayout)
    languageRichText:SetSize(self.languageLayout:GetWide(), self.languageLayout:GetTall())
    languageRichText:InsertColorChange(230, 230, 230, 255)
    languageRichText:SetPos(10, 10)
    languageRichText.PerformLayout = function(self)
        self:SetFontInternal("Disclaimer")
    end
    languageRichText:AppendText(languageMessages[language])
    return self.languageLayout
end

cards = {
    tabs = {},
    layouts = {}
}
local names = {}
local switchTabs = {}
local lastSelectedIndex = 1
function PANEL:AddRegisterCard(name, layout)
    local card = vgui.Create("DButton", self.registerCards)
    card:SetSize(100, self.lineY - 10)
    card:SetText("")
    card.Paint = function(s, w, h)
        draw.SimpleText(name, "DermaDefault", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    switchTabs[name] = {}
    switchTabs[name].index = #names +1
    switchTabs[name].method = function()
        lastSelectedIndex = switchTabs[name].index
        self:DrawCards(lastSelectedIndex)
        layout:SetVisible(true)
    end
    card.DoClick = function()
        self:CloseAllCards()
        if switchTabs[name].method then
            switchTabs[name].method()
        end
    end
    table.insert(names, name)
    table.insert(cards.tabs, card)
    table.insert(cards.layouts, layout)
end

function PANEL:DrawCards(activeID)
    for _, card in ipairs(cards.tabs) do   
        card.Paint = function(s, w, h)
            if(_ == activeID) then
                draw.RoundedBoxEx(8, 0, 5, w, h - 5, Color(50, 50, 70, 255), true, true, false, false)
            else
                draw.RoundedBoxEx(8, 0, 0, w, h, Color(50, 50, 70, 255), true, true, false, false)
            end
            draw.SimpleText(names[_], "DermaDefault", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end        
    end

end

function PANEL:CloseAllCards()
    for _, layout in pairs(cards.layouts) do
        layout:SetVisible(false)
    end
end

function RPGX:ToggleHelpMenu()
    if not IsValid(helpBase) then
        helpBase = vgui.Create("BaseHUD")
    end

    -- Toggle visibility
    if helpBase:IsVisible() then
        helpBase:SetVisible(false)
        gui.EnableScreenClicker(false)
    else
        helpBase:SetVisible(true)
        helpBase:MakePopup()
        gui.EnableScreenClicker(true)
        helpBase:DrawCards(lastSelectedIndex)
    end
end
