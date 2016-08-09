MsgC( Color( 26,188,156 ), "[OmniGamblingFramework] ", Color( 255, 255, 255 ), "loaded\n");

-- ik thats not how its supposed to be but I made the font like dis and I switched to seperate addon format later... cba
local hMod = ScrW() / 1080;

surface.CreateFont( "OmniGambling_Menu_TabFontS", {
font = "Montserrat",
size = 16*hMod,
weight = 500,
antialias = true;
} )

surface.CreateFont( "OmniGambling_Menu_CloseFont", {
font = "Montserrat",
size = 16*hMod,
weight = 500,
antialias = true;
} )

surface.CreateFont( "OmniGambling_Menu_CommunityName", {
font = "Montserrat",
size = 35*hMod,
weight = 500,
antialias = true;
} )

local function findColorDifference( color1, color2, increaseSpeed, decreaseSpeed, buttonChangeSpeed )

        -- Made by Pat, very hacky, very very hacky, works but is shit.
        local r,g,b    = color1.r,color1.g,color1.b;
        local r2,g2,b2 = color2.r,color2.g,color2.b;

        local rDif;
        local rLe;
        local rMax;
        if(r>=r2)then
            rDif=r2;
            rMax=r;
            rLe=r2;
        else
            rDif=r;
            rMax=r2;
            rLe=r;
        end
        local gDif;
        local gLe;
        local gMax;
        if(g>=g2)then
            gDif=g2;
            gMax=g;
            gLe=g2;
        else
            gDif=g;
            gMax=g2;
            gLe=g;
        end
        local bDif;
        local bLe;
        local bMax;
        if(b>=b2)then
            bDif=b2;
            bMax=b;
            bLe=b2;
        else
            bDif=b;
            bMax=b2;
            bLe=b2;
        end

        return rDif,rLe,rMax,gDif,gLe,gMax,bDif,bLe,bMax, decreaseSpeed, increaseSpeed, buttonChangeSpeed;

end

local function DrawCircle( x, y, radius, seg )
	local cir = {}
	table.insert( cir, { x = x, y = y } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )
	end
	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )
	surface.DrawPoly( cir )
end

local PANEL = {}

function PANEL:Init()
	self.avatar = vgui.Create( "AvatarImage", self )
	self.avatar:SetPaintedManually( true )
end

function PANEL:PerformLayout()
	self.avatar:SetSize( self:GetWide(), self:GetTall() )
end

function PANEL:SetPlayer( ply, size )
	self.avatar:SetPlayer( ply, size )
end

function PANEL:Paint( w, h )
	render.ClearStencil()
	render.SetStencilEnable( true )

	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )

	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )

	draw.NoTexture()
	surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
	DrawCircle( w/2, h/2, h/2, math.max(w,h)/2 )

	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )

	self.avatar:PaintManual()

	render.SetStencilEnable( false )
	render.ClearStencil()

end

vgui.Register( "CircularAvatar", PANEL )

OmniGamblingMenu = {};
OmniGamblingMenu.Tabs = {};
OmniGamblingMenu.ActiveTab = 1;

function OmniGambling_Menu_AddTab( name, panel )

	table.insert( OmniGamblingMenu.Tabs, { Name = name, NULL, BuildPanel = panel } );

end

function OmniGambling_Menu()

	local ply = LocalPlayer();
	local wMod = ScrW() / 1920;
	local hMod = ScrH() / 1080;

	OmniGamblingMenu.ActiveTab = 1;

	OmniBetFrame = vgui.Create("DFrame");
	OmniBetFrame:SetSize( 1000*wMod, 660*hMod );
	OmniBetFrame:SetPos(-1000*wMod, ScrH() / 2 - (330*hMod));
	OmniBetFrame:SetTitle( "" )
	OmniBetFrame:SetVisible( true )
	OmniBetFrame:SetDraggable( false )
	OmniBetFrame:ShowCloseButton( false )
	OmniBetFrame:SetDeleteOnClose( false )
  OmniBetFrame:MakePopup();
	OmniBetFrame.Paint = function( pnl, w, h )

		draw.RoundedBoxEx(6,0,0,w,70*hMod, Color( 55,67,85 ), true, true, false, false);

		-- Community name
		draw.SimpleText( OmniGamblingFramework.CommunityName, "OmniGambling_Menu_CommunityName", 10*wMod, 35*hMod, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );

	end

  local function ease_outback(t, b, c, d )
    local tbl = OmniGamblingFramework.easeAnimation;
    t = t / d
    local ts = t * t
    local tc = ts * t;
    return b+c*(tbl.tc*tc*ts + tbl.ts*ts*ts + tbl.tcc*tc + tbl.tss*ts + tbl.t*t);

  end

  local anim = OmniBetFrame:NewAnimation(1)
  anim.Pos = Vector(ScrW() / 2 - (500*wMod), ScrH() / 2 - (330*hMod), 0) -- x, y destination coordinates
  anim.Think = function(anim, pnl, fract)
      local newFract = ease_outback(fract, 0, 1, 1);

      -- Use newFract to interpolate variable, such as panel position
      if not anim.StartPos then anim.StartPos = Vector(pnl.x, pnl.y, 0) end
      local pos = LerpVector(newFract, anim.StartPos, anim.Pos)
      pnl:SetPos(pos.x, pos.y)
  end



	OmniBetButton = vgui.Create("DButton",OmniBetFrame)
	OmniBetButton:SetPos( OmniBetFrame:GetWide() - (70*wMod), 0);
	OmniBetButton:SetSize(71*wMod, 71*hMod)
	OmniBetButton:SetText("");

	  local r2,g2,b2 = 0, 130, 213
    local alpha = 0;
    local r,rLe,rMax,g,gLe,gMax,b,bLe,bMax,decreaseSpeed,increaseSpeed,buttonChangeSpeed = findColorDifference( Color( r2,g2,b2 ), Color( 55, 67, 85), 400, 15, 400 );
    local haveTouchedHover = false;

	OmniBetButton.Paint = function(s,w,h)

	       local hover = s:IsHovered();

			if ( !hover && alpha >= 1 ) then
				alpha = math.Approach(0, 255, alpha - (RealFrameTime()*buttonChangeSpeed) );
				r = math.Approach(rLe, rMax, r - (RealFrameTime()*decreaseSpeed) );
				g = math.Approach(gLe, gMax, g - (RealFrameTime()*decreaseSpeed) );
				b = math.Approach(bLe, bMax, b - (RealFrameTime()*decreaseSpeed) );
        -- fixes a flickering issue with low fps
        if ( alpha <= 8 ) then
          alpha = 0;
        end
			elseif ( hover && alpha <= 255 ) then
				alpha = math.Approach(0, 255, alpha + (RealFrameTime()*buttonChangeSpeed) );
				r = math.Approach(rLe, 55, r + (RealFrameTime()*increaseSpeed) );
				g = math.Approach(gLe, 67,  g + (RealFrameTime()*increaseSpeed) );
				b = math.Approach(bLe, 85, b + (RealFrameTime()*increaseSpeed) );
				haveTouchedHover = true;
			end

			draw.RoundedBoxEx(6, 0, 0, w, h, Color(r2, g2, b2,alpha), false, true, false, false );

      draw.NoTexture();
      if ( haveTouchedHover ) then
        surface.SetDrawColor( r,g,b );
      else
        surface.SetDrawColor( r2,g2,b2 );
      end

      local width = math.Round(22*hMod);
      local thick = math.max( math.Round(3*wMod), 2);
      surface.DrawTexturedRectRotated( w/2, h/2, width, thick, 45);
      surface.DrawTexturedRectRotated( w/2, h/2, width, thick, 135);

	end
	OmniBetButton.DoClick = function(s)

		OmniBetFrame:MoveTo(1920*wMod, ScrH() / 2 - (330*hMod), 0.3, 0, -5, function() OmniBetFrame:Remove() end)

	end

	local offset;
	surface.SetFont( "OmniGambling_Menu_CommunityName" );
	local w,h = surface.GetTextSize( OmniGamblingFramework.CommunityName );
	offset = w;
	if ( OmniGamblingFramework.CommunityName == "" ) then
		offset = -35;
	end

	for c = 1,table.Count(OmniGamblingMenu.Tabs) do
	v = OmniGamblingMenu.Tabs[c]
	local button = vgui.Create("DButton",OmniBetFrame)
	button:SetPos( ( offset + 35 ) + (c-1)*165*hMod, 0);
	button:SetSize(165*wMod, 70*hMod)
	button:SetText("")
	button.Info = v
	button.Index = c
	button.Paint = function(s,w,h)

		draw.RoundedBox(0,0,h - (3*hMod),w,3*hMod,OmniGamblingMenu.ActiveTab == s.Index and Color( 0, 130, 213 )  or Color( 0, 0, 0, 0 ) );

		draw.SimpleText(s.Info.Name:upper() or "NIL","OmniGambling_Menu_TabFontS",w/2 - (1*wMod),h/2,Color( 220, 220, 220 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

	end 

	button.DoClick = function(s)
		for k,v in pairs(OmniGamblingMenu.Tabs) do
			v.Panel:SetVisible(false)
		end
		OmniGamblingMenu.Tabs[s.Index].Panel:SetVisible(true)
		OmniGamblingMenu.ActiveTab = s.Index
	end


	local panel = vgui.Create("DPanel",OmniBetFrame);
	panel:SetPos(0*wMod, 70*hMod)
	panel:SetSize( OmniBetFrame:GetWide(), OmniBetFrame:GetTall() - (70*hMod) );

	v.Panel = panel
	v.BuildPanel(panel)

	if c == 1 then
		v.Panel:SetVisible(true)
	else
		v.Panel:SetVisible(false)
	end

	end

end

net.Receive("OmniGambling_Menu", function() OmniGambling_Menu() end)

local wMod = ScrW() / 1920;
local hMod = ScrH() / 1080;

local thinkTimer = CurTime();

hook.Add("Think", "OmniGamblingMenu_Think", function()

	if ( input.IsKeyDown(OmniGamblingFramework.openKey) && CurTime() >= thinkTimer + 0.32 ) then

		if ( !IsValid(OmniBetFrame) ) then

      if (istable(Omnibet)) then
        net.Start("OmniBet_RequestTable");
        net.SendToServer();
      end

			OmniGambling_Menu();

		else

			OmniBetFrame:MoveTo(1920*wMod, ScrH() / 2 - (330*hMod), 0.3, 0, -5, function() OmniBetFrame:Remove() end)

		end

		thinkTimer = CurTime();

	end

end)
