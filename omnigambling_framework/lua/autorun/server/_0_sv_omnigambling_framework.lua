util.AddNetworkString("OmniGambling_Menu");

hook.Add( "PlayerSay", "OmniGambling_PlayerSay", function( ply, text )

	local command = string.Explode(" ", text)[1];

	if ( string.lower(command) == "!gambling" ) then

		if (istable(Omnibet)) then
			net.Start("OmniBet_UpdateTable");
				net.WriteTable( Omnibet_BettingTable );
			net.Send( ply );
		end

		net.Start("OmniGambling_Menu");
		net.Send( ply );

	end

end)

resource.AddFile("resource/fonts/montserrat.ttf");
