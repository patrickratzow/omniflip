// Yes I know. xdd, its for da fonts
local hMod = ScrW() / 1080;

surface.CreateFont( "OmniCoinFlip_VSFont", {
font = "Montserrat",
size = 38*hMod,
weight = 800,
antialias = true;
} )

surface.CreateFont( "OmniCoinFlip_PlayerFont", {
font = "Montserrat",
size = 25*hMod,
weight = 800,
antialias = true;
} )

surface.CreateFont( "OmniCoinFlip_CurrencyFont", {
font = "Montserrat",
size = 36*hMod,
weight = 1100,
antialias = true;
} )

surface.CreateFont( "OmniCoinFlip_ChallengeFont", {
font = "Montserrat",
size = 20*hMod,
weight = 500,
antialias = true;
} )

surface.CreateFont( "OmniCoinFlip_InviteUI_Title", {
font = "Montserrat",
size = 27*hMod,
weight = 1100,
antialias = true;
} )
--
surface.CreateFont( "OmniCoinFlip_InviteUI_PlayerFont", {
font = "Montserrat",
size = 21*hMod,
weight = 500,
antialias = true;
} )

surface.CreateFont( "OmniCoinFlip_InviteUI_ButtonFont", {
font = "Montserrat",
size = 18*hMod,
weight = 800,
antialias = true;
} )

surface.CreateFont( "OmniCoinFlip_InviteUI_NumberFont", {
font = "Montserrat",
size = 30*hMod,
weight = 800,
antialias = true;
} )

surface.CreateFont( "OmniCoinFlip_FlipFont", {
font = "Montserrat",
size = 24*hMod,
weight = 500,
antialias = true;
} )

surface.CreateFont( "OmniCoinFlip_TheyAreHiding", {
font = "Montserrat",
size = 60*hMod,
weight = 500,
antialias = true;
} )

local thinkTimer = CurTime();
local wMod = ScrW() / 1920;
local hMod = ScrH() / 1080;
local gradientMaterial = Material( "gui/gradient.vtf" );
local coinRed = Material( "omni/coinflip/icons/coin_red.png", "noclamp smooth" );
local coinGreen = Material( "omni/coinflip/icons/coin_green.png", "noclamp smooth" );
local winner;
local challenger;
local receiver;
local amount;
local spinTime;

LocalPlayer().OmniCoinFlip_NotificationActive = false;
LocalPlayer().OmniCoinFlip_FlipActive = false;

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

local function challengePlayerMenu(pnl)

	local ply = LocalPlayer();
	local wMod = ScrW() / 1920;
	local hMod = ScrH() / 1080;

	local playerScrollPanel = vgui.Create("DScrollPanel", pnl);
	playerScrollPanel:SetSize( pnl:GetWide(), 500*hMod );
	playerScrollPanel:SetPos( pnl:GetWide()/2 - playerScrollPanel:GetWide()/2, 92.5*hMod );
	playerScrollPanel.Paint = function( self, w, h )

		draw.RoundedBox(0, 0, 0, w - (16), h, Color( 56, 71, 92 ) );

    if ( #player.GetAll() - 1 <= 0 ) then

      draw.SimpleText( "There's nothing here", "OmniCoinFlip_TheyAreHiding", w/2, 100*hMod, Color( 0, 130, 213 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

    end

	end

	local scrollBar = playerScrollPanel:GetVBar();

	function scrollBar:Paint( w, h ) 	       draw.RoundedBox(0, 0, 0, w, h, Color( 59, 74, 95 ) ) end
	function scrollBar.btnUp:Paint( w, h )   draw.RoundedBox(0, 0, 0, w, h, Color( 45, 57, 75 ) ) end
	function scrollBar.btnDown:Paint( w, h ) draw.RoundedBox(0, 0, 0, w, h, Color( 45, 57, 75 ) ) end
	function scrollBar.btnGrip:Paint( w, h ) draw.RoundedBox(0, 0, 0, w, h, Color( 50, 62, 80, 200 ) ) end


	local layout = vgui.Create("DListLayout", playerScrollPanel)
	layout:SetSize( playerScrollPanel:GetWide() - (16), playerScrollPanel:GetTall() );
	layout:SetPos( 0, 0 );

	local differentColor = true;

	for k,v in pairs ( player.GetAll() ) do

	  if ( v != ply ) then -- had to do it like dis, if I did a return it stops the function

			local color;

			if ( differentColor ) then

				color = Color( 56, 71, 92 );
				differentColor = false;

			else

				color = Color( 52 ,64, 82 );
				differentColor = true;

			end

			local panel = vgui.Create("DPanel");
			panel:SetSize(layout:GetWide() - 10*wMod, 80*hMod);
			panel:SetPos(0,0);
			panel.Paint = function( self, w, h )

				draw.RoundedBox( 0, 0, 0, w, h, color );

				draw.SimpleText( v:Nick():upper(), "OmniCoinFlip_PlayerFont", 80*wMod, h/2 - (2*hMod), Color( 222, 222, 222), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );

			end

			local avatar = vgui.Create("CircularAvatar", panel );
			avatar:SetPos( 8*wMod, 8*hMod );
			avatar:SetSize( 64*wMod, 64*hMod );
			avatar:SetPlayer( v, 128 );

			local button = vgui.Create("DButton", panel );
			button:SetSize( 170*wMod, 50*hMod );
			button:SetPos( panel:GetWide() - button:GetWide() - (2.5*wMod), 15*hMod);
			button:SetFont("OmniCoinFlip_ChallengeFont");
			button:SetText("");

			local r2,g2,b2 = 0, 130, 213
			local alpha = 0;
			local r,rLe,rMax,g,gLe,gMax,b,bLe,bMax,decreaseSpeed,increaseSpeed,buttonChangeSpeed = findColorDifference( Color( r2,g2,b2 ), Color( 55, 67, 85), 400, 15, 400 );
			local haveTouchedHover = false;

			button.Paint = function( self, w, h )

				local hover = self:IsHovered();

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


				draw.RoundedBox(0, 0, 0, w, 2*hMod, Color(r2, g2, b2) );
				draw.RoundedBox(0, 0, 0, 2*wMod, h, Color(r2, g2, b2) );
				draw.RoundedBox(0, 0, h - (2*hMod), w, 2*hMod, Color(r2, g2, b2) );
				draw.RoundedBox(0, w - (2*wMod), 0, 2*wMod, h, Color(r2, g2, b2) );
				draw.RoundedBoxEx(6, 0, 0, w, h, Color(r2, g2, b2,alpha), false, true, false, false );
				if (haveTouchedHover) then
				draw.SimpleText( "Challenge", "OmniCoinFlip_ChallengeFont", w/2, h/2, Color(r,g,b,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
				else
				draw.SimpleText( "Challenge", "OmniCoinFlip_ChallengeFont", w/2, h/2, Color(r2,g2,b2,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
				end

			end
			button.DoClick = function( self )

				net.Start("OmniCoinFlip_RequestChallengeMenu");
					net.WriteEntity( v );
				net.SendToServer();

			end

			layout:Add(panel);

		    end

	   end

	   pnl.Paint = function( self, w, h )

		draw.RoundedBoxEx(8, 0, 0, w, h, Color( 61,77,101 ), false, false, true, true );

		draw.SimpleText( "CHALLENGE A PLAYER", "OmniCoinFlip_VSFont", w/2, 45*hMod, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

		  if ( #player.GetAll() <= 6 ) then

			     -- draw a fake scrollbar, lel
			        draw.RoundedBox(0, w - 16, 92*hMod, 16, 16, Color( 45, 57, 75 ) );
			        draw.RoundedBox(0, w - 16, 92*hMod + 16, 16, 463*hMod, Color(59, 74, 95) );
			        draw.RoundedBox(0, w - 16, 92*hMod + 16, 16, 463*hMod, Color( 50, 62, 80, 200 ) );
			        draw.RoundedBox(0, w - 16, h - 16, 16, 16, Color( 45, 57, 75 ) );

		  end

	   end

end

local allowKeyboardShortcut = true;

local function coinflipMenu(pnl)

	local ply = LocalPlayer();
	local wMod = ScrW() / 1920;
	local hMod = ScrH() / 1080;

	local countdown = CurTime() + 5;
	local material = 1;

	local points = amt or 50;
	local pointsString;

	if ( Omnicoinflip.config.currency == "DarkRP" ) then
		pointsString = math.Round(points*2).." dollars";
	else
		pointsString = math.Round(points*2).." points";
	end

	local pointsOffset;
	surface.SetFont( "OmniCoinFlip_VSFont" );
	local w,h = surface.GetTextSize( pointsString );

	pointsOffset = w;

	local size = 220*wMod;
	local speed = 85;
	local angle = size;
	local sizeY = 0;
	local face = false;
	local done = false;
	local falling = true;
	local mayShowWinner = false;
	local icon;
	local me;
	local meNumber;
	local enemy;
	local enemyNumber;
  local faceFixed = false;
	local rng = math.random(1,2);

	if ( rng == 1 ) then
		face = false;
	else
		face = true;
	end

	local spinSpeed = Omnicoinflip.config.flipStartSpeed;

	if ( challenger ==  ply ) then

		me = challenger;
		meNumber = 1;
		enemy = receiver;
		enemyNumber = 2;

	else

		me = receiver;
		meNumber = 2;
		enemy = challenger;
		enemyNumber = 1;

	end

	local leftAvatar;
	local rightAvatar;

	if ( challenger == me ) then

		leftAvatar = me;
		rightAvatar = enemy;

	else

		leftAvatar = enemy;
		rightAvatar = me;

	end

	local avatarLeft = vgui.Create("CircularAvatar", pnl);
	avatarLeft:SetSize( 128*wMod, 128*hMod );
	avatarLeft:SetPos( pnl:GetWide()/2 - (avatarLeft:GetWide()/2) - pointsOffset*wMod - 15*wMod, 25*hMod );
	avatarLeft:SetPlayer( leftAvatar, 128 );

	local avatarRight = vgui.Create("CircularAvatar", pnl);
	avatarRight:SetSize( 128*wMod, 128*hMod );
	avatarRight:SetPos( pnl:GetWide()/2 - (avatarRight:GetWide()/2) + pointsOffset*wMod + 15*wMod, 25*hMod );
	avatarRight:SetPlayer( rightAvatar, 128 );

	local coin;
	local winningPlayer;

	if ( winner == 1 ) then

		winningPlayer = challenger;

	else

		winningPlayer = receiver;

	end

	if ( timer.Exists("OmniCoinFlip_SpeedDecrease"..LocalPlayer():SteamID64() ) ) then
		timer.Destroy("OmniCoinFlip_SpeedDecrease"..LocalPlayer():SteamID64());
	end

	timer.Create("OmniCoinFlip_SpeedDecrease"..LocalPlayer():SteamID64(), 0.1, 0, function()

		if ( CurTime() >= countdown && !done ) then

			spinSpeed = spinSpeed - Omnicoinflip.config.flipSpeedDecrease;

			if ( spinSpeed < Omnicoinflip.config.flipMinSpeed ) then

				spinSpeed = Omnicoinflip.config.flipMinSpeed;

			end

		end

	end)

	pnl.Paint = function( self, w, h )

		sizeY = math.abs(Lerp((math.sin(angle) + 1)/2, -300*wMod, 300*hMod))

		draw.RoundedBoxEx(8, 0, 0, w, h, Color( 61,77,101 ), false, false, true, true);

		draw.SimpleText( pointsString, "OmniCoinFlip_VSFont", w/2, (50+(128/4))*hMod, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

		surface.SetMaterial( gradientMaterial );
		surface.SetDrawColor( 243, 92, 84 );
		surface.DrawTexturedRectRotated( 0, ( 250 - ( (250-182) /2 ) )*hMod, w, 71*hMod, 0 );

		surface.SetMaterial( gradientMaterial );
		surface.SetDrawColor( 36, 188, 166 );
		surface.DrawTexturedRectRotated( w, ( 250 - ( (250-182) /2 ) )*hMod, w, 71*hMod, 180);
 
		draw.RoundedBox( 0, 0, 180*hMod, w, 1*hMod, Color( 59, 75, 99 ) ); //  1 px

		draw.RoundedBox( 0, 0, 252*hMod, w, 1*hMod, Color(  59, 75, 99 ) ); //  1 px

		draw.RoundedBox( 0, w/2 - (1*wMod), 180*hMod, 1*wMod, 70*hMod, Color(  61,77,101 ) ); //  1 px

		// left player
		draw.SimpleText( leftAvatar:Nick(), "OmniCoinFlip_PlayerFont", w/2 - pointsOffset*wMod - 15*wMod, 215*hMod, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
		// right player
		draw.SimpleText( rightAvatar:Nick(), "OmniCoinFlip_PlayerFont", w/2 + pointsOffset*wMod + 15*wMod, 215*hMod, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

		face = ((math.sin(angle) + 1)/2) < 0.5

		if ( face ) then
			coin = coinRed;
			material = 1;
		elseif ( !face ) then
			coin = coinGreen;
			material = 2;
		end

    -- TODO: better, this is very shit.

		if ( mayShowWinner ) then

			if ( winner == 1 ) then
				coin = coinRed;
			else
				coin = coinGreen;
			end

			draw.NoTexture();
			draw.SimpleText( "Flip over", "OmniCoinFlip_FlipFont", w/2, 145*hMod, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
			surface.SetMaterial( coin );
			surface.SetDrawColor( color_white );
			surface.DrawTexturedRect( ( w/2 - (150*wMod) ), (h/2 + (122.5*hMod)) - ((300*hMod)/2) , 300*wMod, 300*hMod );
			--ent.OmniCoinFlip_FlipActive = false;
			ply.OmniCoinFlip_FlipActive = false;
		elseif ( CurTime() >= countdown ) then
			draw.NoTexture();
			draw.SimpleText( "Flipping...", "OmniCoinFlip_FlipFont", w/2, 145*hMod, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
			surface.SetMaterial( coin );
			surface.SetDrawColor( color_white );
			surface.DrawTexturedRect( ( w/2 - (150*wMod) ), (h/2 + (122.5*hMod)) - ((sizeY)/2) , 300*wMod, sizeY );
		else
			draw.NoTexture();
			draw.SimpleText( "Flipping in "..math.Round((countdown - CurTime())), "OmniCoinFlip_FlipFont", w/2, 145*hMod, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
			surface.SetMaterial( coin );
			surface.SetDrawColor( color_white );
			surface.DrawTexturedRect( ( w/2 - (150*wMod) ), (h/2 + (122.5*hMod)) - ((300*hMod)/2) , 300*wMod, 300*hMod );
		end

	end

  OmniBetButton:SetVisible(false);
	allowKeyboardShortcut = false;

	local function flip()

		hook.Add("Think", "Flip", function()

			angle = angle - (FrameTime() * spinSpeed);

			if ( done ) then

        if ( sizeY >= 210*wMod && material == 1 ) then
            faceFixed = true;
        elseif ( sizeY <= 10*wMod && material == 2 ) then
            faceFixed = true;
        end

        if ( faceFixed ) then

				if ( material == winner ) then

					hook.Remove("Think", "Flip");

					local loser;

					if ( winner == meNumber ) then

						winner = meNumber;
						loser = enemy;

					else

						winner = enemyNumber;
						loser = me;

					end

					if ( timer.Exists("OmniCoinFlip_SpeedDecrease"..LocalPlayer():SteamID64() ) ) then
						timer.Destroy("OmniCoinFlip_SpeedDecrease"..LocalPlayer():SteamID64());
					end

					net.Start("OmniCoinFlip_FlipOver");
					net.SendToServer();

					angle = size;

					mayShowWinner = true;
					me.OmniCoinFlip_FlipActive = false;

					OmniBetButton:SetVisible(true);
					allowKeyboardShortcut = true;
					return;

				end

      end

			end

		end)

	end

	timer.Simple( countdown - CurTime(), function()

		flip();

		timer.Simple( spinTime, function()

			done = true;

		end)

	end)

end

OmniGambling_Menu_AddTab( "COINFLIP", function(pnl)

		local ply = LocalPlayer();
		local wMod = ScrW() / 1920;
		local hMod = ScrH() / 1080;

		panelForCoinFlip = pnl;
		if ( !ply.OmniCoinFlip_FlipActive ) then
		challengePlayerMenu(pnl)
		else
		coinflipMenu(pnl)
		end

end)


surface.CreateFont( "OmniCoinFlip_Challenge_PopupFontTitle", {
font = "Montserrat",
size = 36*hMod,
weight = 800,
antialias = true;
} )

surface.CreateFont( "OmniCoinFlip_Challenge_PopupVS", {
font = "Montserrat",
size = 60*hMod,
weight = 3000,
antialias = true;
} )

surface.CreateFont( "OmniCoinFlip_Challenge_PopupTextEntryFont", {
font = "Montserrat",
size = 40*hMod,
weight = 500,
antialias = true,
} )

surface.CreateFont( "OmniCoinFlip_Challenge_PopupClose", {
font = "Montserrat",
size = 45*hMod,
weight = 800,
antialias = true,
} )

local blur = Material( "pp/blurscreen" )
function surface.BlurPanel( panel, amount )
	local x, y = panel:LocalToScreen( 0, 0 )
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )
	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / 3 ) * ( amount or 6 ) )
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
end

--Client then retrieves the net message and opens the menu
net.Receive("OmniCoinFlip_OpenChallengeMenu", function( len )

	local ent = net.ReadEntity();
	local ply = LocalPlayer();
	local wMod = ScrW() / 1920;
	local hMod = ScrH() / 1080;

	surface.SetFont("OmniCoinFlip_Challenge_PopupFontTitle");
	local offset,y = surface.GetTextSize( "How much do you wanna coinflip?" );

	local frame = vgui.Create("DFrame");
	frame:SetSize( ScrW(), ScrH() ); // 16:9 format
	frame:SetPos( 0, 0 );
	frame:SetTitle( "" )
	frame:SetVisible( true )
	frame:SetDraggable( false )
	frame:ShowCloseButton( false );
	frame:SetDeleteOnClose( true );
	frame:MakePopup();

	local avatar = vgui.Create("CircularAvatar", frame);
	avatar:SetSize( 156*wMod, 156*hMod );
	avatar:SetPos( ScrW()/2 - ( (124*wMod) / 2), (frame:GetTall()/2-(125*hMod)));
	avatar:SetPlayer( ent, 128 );

	local textEntry = vgui.Create( "DTextEntry", frame );
	textEntry:SetPos( 710*wMod, ScrH()/2 + (77.5*hMod) );
	textEntry:SetNumeric( true );
	textEntry:SetFont( "OmniCoinFlip_Challenge_PopupTextEntryFont" );
	textEntry:SetSize( offset, 50*hMod );--
	textEntry:SetText( "Write here" );
	textEntry.Paint = function( self, w, h )

    local lowResFix;

    if ( wMod <= 0.72 ) then
      lowResFix = 3*hMod;
    else
      lowResFix = 2*hMod;
    end

    if ( self:HasFocus() ) then
		draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 130, 213 ) );
    else
    draw.RoundedBox( 4, 0, 0, w, h, Color( 84,101,126 ) );
    end

		draw.RoundedBox( 4, 1*wMod, 1*hMod, w - (lowResFix), h - (lowResFix), Color( 61, 77, 103 ) );

		self:DrawTextEntryText(Color( 255, 255, 255 ), Color( 255, 255, 255 ),Color(255,255,255));

	end
	textEntry.OnGetFocus = function( self )

		self:SetValue( "" );

	end
	textEntry.OnEnter = function( self )

		--somewhere sends the amount to the server again
		net.Start("OmniCoinFlip_ChallengePlayer");
			net.WriteEntity( ent );
			net.WriteInt( math.Round( tonumber(textEntry:GetValue()) ), 32 );
		net.SendToServer();

		receiver = ent;
		challenger = ply;

		frame:Remove();

		OmniBetFrame:MoveTo(1920*wMod, ScrH() / 2 - (330*hMod), 0.3, 0, -5, function() OmniBetFrame:Remove() end)

	end
  textEntry:RequestFocus();

	local button = vgui.Create("DButton", frame);
	button:SetText("");
	button:SetPos( frame:GetWide()/2+(offset/2) - (20*wMod), frame:GetTall()/2 -(137*hMod) );
	button:SetSize(55*wMod, 55*hMod);

  local r2,g2,b2 = 0, 130, 213
  local alpha = 0;
  local r,rLe,rMax,g,gLe,gMax,b,bLe,bMax,decreaseSpeed,increaseSpeed,buttonChangeSpeed = findColorDifference( Color( r2,g2,b2 ), Color( 55, 67, 85), 400, 15, 400 );
  local haveTouchedHover = false;

	button.Paint = function( self, w, h )

        local hover = self:IsHovered();

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
        if (haveTouchedHover) then
        draw.SimpleText( "X", "OmniCoinFlip_Challenge_PopupClose", w/2, h/2, Color(r,g,b,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        else
        draw.SimpleText( "X", "OmniCoinFlip_Challenge_PopupClose", w/2, h/2, Color(r2,g2,b2,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        end


	end
	button.DoClick = function( self )

		frame:Remove();

	end

	frame.Paint = function( pnl, w, h )

		surface.BlurPanel( pnl, 6 );

		draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 100 ) );

		draw.RoundedBox( 6, 700*wMod, h/2-(137.5*hMod), offset + 15, 275*hMod, Color( 56, 71, 92 ) );

		if ( textEntry:GetValue() == "" ) then -- workaround pls
			draw.SimpleText( "How much do you wanna coinflip?", "OmniCoinFlip_Challenge_PopupFontTitle", 710*wMod, (h/2+(52.5*hMod)), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		elseif ( textEntry:GetValue() == "Write here" ) then
			draw.SimpleText( "How much do you wanna coinflip?", "OmniCoinFlip_Challenge_PopupFontTitle", 710*wMod, (h/2+(52.5*hMod)), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		elseif ( textEntry:GetValue() == "." ) then -- fixes a lua error
			draw.SimpleText( "How much do you wanna coinflip?", "OmniCoinFlip_Challenge_PopupFontTitle", 710*wMod, (h/2+(52.5*hMod)), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		elseif ( textEntry:GetValue() == "-" ) then -- fixes a lua error
			draw.SimpleText( "How much do you wanna coinflip?", "OmniCoinFlip_Challenge_PopupFontTitle", 710*wMod, (h/2+(52.5*hMod)), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		elseif ( tonumber(textEntry:GetValue()) <= -0 ) then
			draw.SimpleText( "Don't be so negative :(", "OmniCoinFlip_Challenge_PopupFontTitle", 710*wMod, (h/2+(52.5*hMod)), Color( 243, 92, 84  ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		elseif ( !ply:OmniCoinFlip_CanAfford( tonumber(textEntry:GetValue()) ) ) then
			draw.SimpleText( "You can't afford that!", "OmniCoinFlip_Challenge_PopupFontTitle", 710*wMod, (h/2+(52.5*hMod)), Color( 243, 92, 84 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		elseif ( !ent:OmniCoinFlip_CanAfford( tonumber(textEntry:GetValue()) ) ) then
			draw.SimpleText( ent:Nick().." can't afford that!", "OmniCoinFlip_Challenge_PopupFontTitle", 710*wMod, (h/2+(52.5*hMod)), Color( 243, 92, 84  ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		else
			draw.SimpleText( "How much do you wanna coinflip?", "OmniCoinFlip_Challenge_PopupFontTitle", 710*wMod, (h/2+(52.5*hMod)), Color( 46, 198, 166 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		end

	end

end)

-- now the client receives the notification

net.Receive("OmniCoinFlip_SendNotification", function( len )

	local ply = LocalPlayer();
	local ent = net.ReadEntity();
	local amt = net.ReadInt(32);
	local wMod = ScrW() / 1920;
	local hMod = ScrH() / 1080;

	challenger = ent;
	receiver = ply;
	amount = amt;

	LocalPlayer().OmniCoinFlip_NotificationActive = true;

	ply.OmniCoinFlip_NotificationActive = true;

	local progress = 100;

	if ( timer.Exists("OmniCoinFlipTimer"..ent:SteamID64() ) ) then

		timer.Destroy("OmniCoinFlipTimer"..ent:SteamID64());

	end

	timer.Create( "OmniCoinFlipTimer"..ent:SteamID64(), 0.1, 100, function()

		progress = progress - 1;

	end);

	local customProgress = 100;

	OmniCoinFlip_InviteUI = vgui.Create("DPanel");
	OmniCoinFlip_InviteUI:SetPos( 1920*wMod, ScrH() / 2 - (200*hMod) );
	OmniCoinFlip_InviteUI:SetSize( 420*wMod, 400*hMod );
	OmniCoinFlip_InviteUI:MoveTo( 1490*wMod, ScrH() / 2 - (200*hMod), Omnicoinflip.config.inviteAnimationSec, 0, -1 );
	OmniCoinFlip_InviteUI.Paint = function( self, w, h )

		customProgress = math.min(100, (customProgress == progress and customProgress) or Lerp(0.1, customProgress, progress))

		draw.RoundedBox( 4, 0, 0, w, 60*hMod, Color( 55,67,85 ) );
		draw.RoundedBox( 0, 0, 55*hMod, w, h, Color( 61,77,101 ) );

		draw.SimpleText( "COINFLIP", "OmniCoinFlip_InviteUI_Title", w/2, 27.5*hMod, Color( 245, 245, 245 ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

		draw.RoundedBox( 0, 0, 390*hMod, (4.2*customProgress)*wMod, 10*hMod, Color( 36, 198, 166 ) );

		if ( Omnicoinflip.config.currency == "DarkRP" ) then
		draw.SimpleText( "$"..amt, "OmniCoinFlip_InviteUI_NumberFont", 11.5*wMod, 275*hMod, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		elseif ( Omnicoinflip.config.currency == "PS2_Premium" ) then
		draw.SimpleText( amt.." Premium points", "OmniCoinFlip_InviteUI_NumberFont", 11.5*wMod, 275*hMod, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		else
		draw.SimpleText( amt.." Points", "OmniCoinFlip_InviteUI_NumberFont", 11.5*wMod, 275*hMod, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
		end

	end


	local avatar = vgui.Create("CircularAvatar", OmniCoinFlip_InviteUI);
	avatar:SetPos( 20*wMod, 80*hMod );
	avatar:SetSize( 80*wMod, 80*hMod );
	avatar:SetPlayer(challenger, 128);

	local dlabel = vgui.Create("DLabel", OmniCoinFlip_InviteUI);
	dlabel:SetSize( 310*wMod, 200*hMod );
	dlabel:SetPos( 110*wMod, 17.5*hMod );
	dlabel:SetFont( "OmniCoinFlip_InviteUI_PlayerFont" );
	dlabel:SetTextColor( Color( 245, 245, 245 ) );
	dlabel:SetWrap( true );
	dlabel:SetText( challenger:Nick().."\nwants to invite you to a coin flip" );

	local accept = vgui.Create("DButton", OmniCoinFlip_InviteUI);
	accept:SetPos( 15*wMod, 305*hMod );
	accept:SetSize( 187.5*wMod, 70*hMod );
	accept:SetText( "Accept ("..Omnicoinflip.config.acceptKeyStr..")" );
	accept:SetTextColor( color_white );
	accept:SetFont( "OmniCoinFlip_InviteUI_ButtonFont" );
	accept.Paint = function( self, w, h )

		draw.RoundedBox( 4, 0, 0, w, h, Color( 36, 198, 166 ) );

	end
	accept.DoClick = function( self )

		net.Start("OmniCoinFlip_RespondNotification");
			net.WriteBool( true );
			net.WriteEntity( challenger );
		net.SendToServer();

		OmniCoinFlip_InviteUI:MoveTo(1920*wMod, ScrH() / 2 - (200*hMod), Omnicoinflip.config.inviteAnimationSec, 0, -1, function() OmniCoinFlip_InviteUI:Remove() LocalPlayer().OmniCoinFlip_NotificationActive = false end)

	end

	local decline = vgui.Create("DButton", OmniCoinFlip_InviteUI);
	decline:SetPos( 215*wMod, 305*hMod );
	decline:SetSize( 190*wMod, 70*hMod );
	decline:SetText( "Decline ("..Omnicoinflip.config.denyKeyStr..")" );
	decline:SetTextColor( color_white );
	decline:SetFont( "OmniCoinFlip_InviteUI_ButtonFont" );
	decline.Paint = function( self, w, h )

		draw.RoundedBox( 4, 0, 0, w, h, Color( 243, 92, 84 ) );

	end
	decline.DoClick = function( self )

		net.Start("OmniCoinFlip_RespondNotification");
			net.WriteBool( false );
			net.WriteEntity( challenger );
		net.SendToServer();

		OmniCoinFlip_InviteUI:MoveTo(1920*wMod, ScrH() / 2 - (200*hMod), Omnicoinflip.config.inviteAnimationSec, 0, -1, function() OmniCoinFlip_InviteUI:Remove() LocalPlayer().OmniCoinFlip_NotificationActive = false end)

	end

	timer.Simple( 10.2, function()

		if ( IsValid( OmniCoinFlip_InviteUI ) ) then

			OmniCoinFlip_InviteUI:MoveTo(1920*wMod, ScrH() / 2 - (200*hMod), Omnicoinflip.config.inviteAnimationSec, 0, -1, function() OmniCoinFlip_InviteUI:Remove() LocalPlayer().OmniCoinFlip_NotificationActive = false end)

			net.Start("OmniCoinFlip_RespondNotification");
				net.WriteBool( false );
				net.WriteEntity( challenger );
			net.SendToServer();

		end

	end)

end)

net.Receive("OmniCoinFlip_OpenCoinFlip", function( len )

	-- ent = challenger
	local ent = net.ReadEntity();
	local ply = net.ReadEntity();
	local amount = net.ReadInt(32);
	local win = net.ReadInt(4);
	local time = net.ReadFloat();
	-- ply = receiver

	challenger = ent;
	amt = amount;
	winner = win;
	spinTime = time;

	LocalPlayer().OmniCoinFlip_FlipActive = true;

	if ( !IsValid(OmniBetFrame) ) then

		OmniGambling_Menu();

	end

	for k,v in pairs ( OmniGamblingMenu.Tabs ) do

		if ( v.Name == "COINFLIP" ) then

			OmniGamblingMenu.Tabs[OmniGamblingMenu.ActiveTab].Panel:SetVisible(false);
			OmniGamblingMenu.Tabs[k].Panel:SetVisible(true);
			OmniGamblingMenu.ActiveTab = k;

		end

	end

end)

net.Receive("OmniCoinFlip_FlipOverClient", function( len )

	LocalPlayer().OmniCoinFlip_FlipActive = false;

end)

net.Receive("OmniCoinFlip_Message", function( len )

	chat.AddText( Omnicoinflip.config.chatPrefixColor, "[OmniFlip] ", Omnicoinflip.config.chatColor, net.ReadString() );

end)--

hook.Add("Think", "OmniCoinFlip_InviteUI_Think", function()

	if ( input.IsKeyDown(Omnicoinflip.config.acceptKey) && LocalPlayer().OmniCoinFlip_NotificationActive && CurTime() >= thinkTimer + 2 ) then

		net.Start("OmniCoinFlip_RespondNotification");
			net.WriteBool( true );
			net.WriteEntity( challenger );
			net.WriteInt( amount, 32 );
		net.SendToServer();

		OmniCoinFlip_InviteUI:MoveTo(1920*wMod, ScrH() / 2 - (200*hMod), Omnicoinflip.config.inviteAnimationSec, 0, -1, function() OmniCoinFlip_InviteUI:Remove() LocalPlayer().OmniCoinFlip_ChallengeActive = false end)

		thinkTimer = CurTime();

	elseif ( input.IsKeyDown(Omnicoinflip.config.denyKey) && LocalPlayer().OmniCoinFlip_NotificationActive && CurTime() >= thinkTimer + 2 ) then

		net.Start("OmniCoinFlip_RespondNotification");
			net.WriteBool( false );
			net.WriteEntity( challenger );
			net.WriteInt( amount, 32 );
		net.SendToServer();

		OmniCoinFlip_InviteUI:MoveTo(1920*wMod, ScrH() / 2 - (200*hMod), Omnicoinflip.config.inviteAnimationSec, 0, -1, function() OmniCoinFlip_InviteUI:Remove() LocalPlayer().OmniCoinFlip_ChallengeActive = false end)

		thinkTimer = CurTime();

	end

end)
