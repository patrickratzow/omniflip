MsgC( Color( 26,188,156 ), "[OmniCoinFlip] ", Color( 255, 255, 255 ), "serverside loaded\n");

util.AddNetworkString("OmniCoinFlip_RequestChallengeMenu");
util.AddNetworkString("OmniCoinFlip_OpenChallengeMenu");
util.AddNetworkString("OmniCoinFlip_ChallengePlayer");
util.AddNetworkString("OmniCoinFlip_SendNotification");
util.AddNetworkString("OmniCoinFlip_RespondNotification");
util.AddNetworkString("OmniCoinFlip_OpenCoinFlip");
util.AddNetworkString("OmniCoinFlip_FlipOverClient");
util.AddNetworkString("OmniCoinFlip_FlipOver");
util.AddNetworkString("OmniCoinFlip_Message");

if ( Omnicoinflip.config.downloadMethod == "fastdl" ) then
resource.AddFile("materials/omni/coinflip/icons/coin_green.png");
resource.AddFile("materials/omni/coinflip/icons/coin_red.png");
elseif ( Omnicoinflip.config.downloadMethod == "workshop" ) then
resource.AddWorkshop("730338969");
end

hook.Add("PlayerInitialSpawn", "OmniCoinFlip_PlayerInitialSpawn", function( ply )

	ply.OmniCoinFlip_Amount = 0;
	ply.OmniCoinFlip_Winner = 0;
	ply.OmniCoinFlip_FlipActive = false;
	ply.OmniCoinFlip_NotificationActive = false;
  ply.OmniCoinFlip_IsRequestor = false;

end)

-- Server now reacts
net.Receive("OmniCoinFlip_RequestChallengeMenu", function( len, ply )

	local ent = net.ReadEntity();

	-- Make options that should disable opening the challenge turn this false

	-- Always check the player sending the request first, makes stuff easier
	if ( ply.OmniCoinFlip_NotificationActive || ply.OmniCoinFlip_FlipActive ) then

		ply:OmniCoinFlip_Message( "You can't do a coinflip now, you're already in one or preparing for one");
		return false;

	end

	if ( ent.OmniCoinFlip_NotificationActive || ent.OmniCoinFlip_FlipActive ) then

		ply:OmniCoinFlip_Message( ent:Nick().." is already in a coinflip");
		return false;

	end

	net.Start("OmniCoinFlip_OpenChallengeMenu");
		net.WriteEntity( ent );
	net.Send( ply );


end)

--Now the server has to verify that the player can actually afford it and that it ain't a negative number.
net.Receive("OmniCoinFlip_ChallengePlayer", function( len, ply )

	local ent = net.ReadEntity();
	local amt = net.ReadInt(32);

	-- I know it's rounded, but checking is better than not.
	-- Also make sure the number aren't negative.
	if ( amt <= 0.99 ) then

		ply:OmniCoinFlip_Message( "You need to enter a number above 1!");
		return false;

	end

	-- Allows check the player that sends the net message first
	if ( !ply:OmniCoinFlip_CanAfford( amt ) ) then

		ply:OmniCoinFlip_Message( "You cannot afford that!");
		return false;

	end

	if ( !ent:OmniCoinFlip_CanAfford( amt ) ) then

		ply:OmniCoinFlip_Message( ent:Nick().." cannot afford that!");
		return false;

	end

	-- Check if they're already active
	-- Always check the player sending the request first, makes stuff easier
	if ( ply.OmniCoinFlip_NotificationActive || ply.OmniCoinFlip_FlipActive ) then

		ply:OmniCoinFlip_Message( "You can't do a coinflip now, you're already in one or preparing for one");
		return false;

	end

	if ( ent.OmniCoinFlip_NotificationActive || ent.OmniCoinFlip_FlipActive ) then

		ply:OmniCoinFlip_Message( ent:Nick().." is already in a coinflip");
		return false;

	end

	ent.OmniCoinFlip_NotificationActive = true;
	ent.OmniCoinFlip_Amount = amt;
  ent.OmniCoinFlip_AcceptedChallenge = false;
  ply.OmniCoinFlip_IsRequestor = true;
	ply.OmniCoinFlip_NotificationActive = true;
	ply.OmniCoinFlip_Amount = amt;

	net.Start("OmniCoinFlip_SendNotification");
		net.WriteEntity( ply );
		net.WriteInt( amt, 32 );
	net.Send( ent );

end)

-- now server reacts to that
net.Receive("OmniCoinFlip_RespondNotification", function( len, ply )

	local bool = net.ReadBool();
	local ent = net.ReadEntity();
	local amt = ply.OmniCoinFlip_Amount; -- trust the guy thats getting challenged more than the guy challenging even through its serverside.

	if ( !bool ) then

		ent:OmniCoinFlip_Message( ply:Nick().." denied your coin flip request");
		ent.OmniCoinFlip_NotificationActive = false;
		ply.OmniCoinFlip_NotificationActive = false;
  --  ply.OmniCoinFlip_IsRequestor = false;
		return false;

	end

/*
  if ( ent.OmniCoinFlip_IsRequestor ) then

      if ( Omnicoinflip.config.banExploiters ) then
        if ( IsValid(ent) ) then
          ent:Ban(0, "OmniFlip, network exploiter");
        end
      end

      if ( Omnicoinflip.config.kickExploiters ) then
        if ( IsValid(ent) ) then
          ent:Kick("OmniFlip, network exploiter");
        end
      end

      -- attempting to net exploit;
      return false;

  end*/

	-- Is their notification active??
	if ( !ent.OmniCoinFlip_NotificationActive && !ply.OmniCoinFlip_NotificationActive ) then

		return false;

	end

	-- Allows check the player that sends the net message first
	if ( !ply:OmniCoinFlip_CanAfford( amt ) ) then

		ply:OmniCoinFlip_Message( "You can't afford that!");
		return false;

	end

	if ( !ent:OmniCoinFlip_CanAfford( amt ) ) then

		ply:OmniCoinFlip_Message( ent:Nick().." can't afford that!")
		return false;

	end


	local winner = math.random(1,2);

	local time = math.Rand(Omnicoinflip.config.spinTimeMin, Omnicoinflip.config.spinTimeMax);

	ent.OmniCoinFlip_Winner = winner;
	ply.OmniCoinFlip_Winner = winner;
	ent.OmniCoinFlip_Number = 1;
	ply.OmniCoinFlip_Number = 2;
	ent.OmniCoinFlip_FlipActive = true;
	ply.OmniCoinFlip_FlipActive = true;
	ent.OmniCoinFlip_NotificationActive = false;
	ply.OmniCoinFlip_NotificationActive = false;

  ent.OmniCoinFlip_AcceptedChallenge = false;

	ply:OmniCoinFlip_AddCurrency( -amt );
	ent:OmniCoinFlip_AddCurrency( -amt );

	net.Start("OmniCoinFlip_OpenCoinFlip");
		net.WriteEntity( ent );
		net.WriteEntity( ply );
		net.WriteInt( ent.OmniCoinFlip_Amount, 32 );
		net.WriteInt( winner, 4 );
		net.WriteFloat( time );
	net.Send( ent );

	net.Start("OmniCoinFlip_OpenCoinFlip");
		net.WriteEntity( ent );
		net.WriteEntity( ply );
		net.WriteInt( ent.OmniCoinFlip_Amount, 32 );
		net.WriteInt( winner, 4 );
		net.WriteFloat( time );
	net.Send( ply );

	-- In case something goes wrong, we have this timer.
	timer.Simple( 13, function()

		if ( ply.OmniCoinFlip_FlipActive ) then

			ply.OmniCoinFlip_FlipActive = false;

		end

		if ( ent.OmniCoinFlip_FlipActive ) then

			ent.OmniCoinFlip_FlipActive = false;

		end

		net.Start("OmniCoinFlip_FlipOverClient");
		net.Send( ent );

		net.Start("OmniCoinFlip_FlipOverClient");
		net.Send( ply );

	end)

end)

--server gets it back
net.Receive("OmniCoinFlip_FlipOver", function( len, ply )

	/* If any exploits come up, then activate this but otherwise security should be fine so sending a net message won't do shit anyway
	if ( !ply.OmniCoinFlip_FlipActive ) then

		-- message already sent;
		return false;

	end*/

	if ( ply.OmniCoinFlip_Winner != ply.OmniCoinFlip_Number ) then

		ply:OmniCoinFlip_Message( "You lost the coin flip :(" );
		ply.OmniCoinFlip_NotificationActive = false;
		ply.OmniCoinFlip_FlipActive = false;

		net.Start("OmniCoinFlip_FlipOverClient");
		net.Send( ply );

		return false;

	end

	local amt = ply.OmniCoinFlip_Amount * 2;

	ply:OmniCoinFlip_AddCurrency( math.Round(amt) );
	ply:OmniCoinFlip_Message( "You won "..math.Round(amt).." from the coin flip!" );

	ply.OmniCoinFlip_NotificationActive = false;
	ply.OmniCoinFlip_FlipActive = false;
	ply.OmniCoinFlip_Amount = 0;
	ply.OmniCoinFlip_Winner = 0;
  ply.OmniCoinFlip_IsRequestor = false;

	net.Start("OmniCoinFlip_FlipOverClient");
	net.Send( ply );

end)

local meta = FindMetaTable("Player");

function meta:OmniCoinFlip_AddCurrency( amt )

	if ( Omnicoinflip.config.currency == "PS1" ) then

		self:PS_GivePoints( amt );

	elseif ( Omnicoinflip.config.currency == "PS2_Standard" ) then

		self:PS2_AddStandardPoints( amt );

	elseif ( Omnicoinflip.config.currency == "PS2_Premium" ) then

		self:PS2_AddPremiumPoints( amt );

	elseif ( Omnicoinflip.config.currency == "DarkRP" ) then

		self:addMoney( amt );

	end

end

function meta:OmniCoinFlip_Message( msg )

	net.Start("OmniCoinFlip_Message");
		net.WriteString( msg );
	net.Send( self );

end
