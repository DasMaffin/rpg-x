surface.CreateFont("DermaBold", {
    font = "Tahoma",
    size = 13,
    weight = 700,
    antialias = true,
})

local PANEL = {}
local BaseHUDisActive = false
local helpBase = nil

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
    self.registerCards:SetSize(315, self.lineY - 10) -- Height up to the line
    self.registerCards:SetSpaceX(5) -- Spacing between cards
    
    -- Add register cards
    -- self:AddRegisterCard("Active Quests")
    -- self:AddRegisterCard("Finished Quests")
    
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

    -- Quest container layout
    self.questLayout = vgui.Create("DIconLayout", self.scrollPanel)
    self.questLayout:SetSpaceY(5)
    self.questLayout:SetSize(self.scrollPanel:GetWide(), 1000)

    self.finishedQuestLayout = vgui.Create("DIconLayout", self.scrollPanel)
    self.finishedQuestLayout:SetSpaceY(5)
    self.finishedQuestLayout:SetSize(self.scrollPanel:GetWide() - self.scrollPanel:GetVBar():GetWide() - 5, 1000)
    self.finishedQuestLayout:SetVisible(false)
end

function RPGX:ToggleHelpMenu()
    print("A")
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
    end
end
