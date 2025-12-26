HealthbarGUI = {
    Scale = 0.1,
    BarWidth = 800,
    BarHeight = 80
}
local dd = GetConVar("UIDrawDistance"):GetInt()
if dd < 64 then dd = 1024 end -- min draw distance = 64. If less default to 1024.
HealthbarGUI.DrawDistance = dd

surface.CreateFont( "PlayerTagFont", {
	font = "Arial",
	size = 96, -- change with scale, double scale, half size.
} )

cvars.AddChangeCallback("UIDrawDistance", function(name, oldValue, newValue)
    HealthbarGUI.DrawDistance = tonumber(newValue) or 1024
end, "UIDrawDistanceChanged")

function GM:PostDrawOpaqueRenderables( bDrawingDepth, bDrawingSkybox, isDraw3DSkybox )
    for _, ent in ipairs(ents.FindByClass("npc_*")) do
        if ent:GetPos():Distance(EyePos()) < HealthbarGUI.DrawDistance then
            if not IsValid(ent) then continue end
            
            -- Get position above entity
            local pos = ent:GetPos() + Vector(0,0,80)

            -- Face the player
            local ang = (LocalPlayer():GetPos() - pos):Angle()
            ang:RotateAroundAxis(ang:Right(), -90)
            ang:RotateAroundAxis(ang:Up(), 90)

            cam.Start3D2D(pos, ang, HealthbarGUI.Scale)
                -- Draw a background
                surface.SetDrawColor(50, 50, 50, 200)
                surface.DrawRect(
                    -HealthbarGUI.BarWidth/2, 
                    -HealthbarGUI.BarHeight/2, 
                    HealthbarGUI.BarWidth, 
                    HealthbarGUI.BarHeight)

                -- Draw health bar
                local hp = math.max(ent:Health(), 0)
                local maxhp = ent:GetMaxHealth()
                surface.SetDrawColor(255, 0, 0, 200)
                surface.DrawRect(
                    -HealthbarGUI.BarWidth/2, 
                    -HealthbarGUI.BarHeight/2, 
                    HealthbarGUI.BarWidth * (hp / maxhp), 
                    HealthbarGUI.BarHeight)

                surface.SetFont( "PlayerTagFont" )
                local tW, tH = surface.GetTextSize( hp .. " / " .. maxhp )
                draw.SimpleText( hp .. " / " .. maxhp, "PlayerTagFont", -tW / 2, -tH / 2, color_white )
            cam.End3D2D()
        end
    end
end