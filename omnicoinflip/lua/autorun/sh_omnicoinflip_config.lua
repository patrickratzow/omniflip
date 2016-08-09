Omnicoinflip = {};
Omnicoinflip.config = {};

-- Color the [OmniFlip] should be.
Omnicoinflip.config.chatPrefixColor = Color( 0, 130, 213 );
-- Color the rest of the message should be.
Omnicoinflip.config.chatColor = Color( 255, 255, 255 );
-- Lowest amount of seconds the coin can spin
Omnicoinflip.config.spinTimeMin = 5.5;
-- Highest amount of seconds the coin can spin
Omnicoinflip.config.spinTimeMax = 5.5;
-- What currency do you use? Pointshop 1, maybe 2 or even DarkRP? Be sure to configure this.
-- PS1 = Pointshop 1
-- PS2_Standard = Pointshop 2 standard points
-- PS2_Premium = Pointshop 2 premium points
-- DarkRP = DarkRP money
Omnicoinflip.config.currency = "DarkRP";
-- What key to accept?
Omnicoinflip.config.acceptKey = KEY_F7;
-- Should be the keys actual name, like F7, J, F9, K, etc
Omnicoinflip.config.acceptKeyStr = "F7";
-- What key to deny?
Omnicoinflip.config.denyKey = KEY_F8;
-- Should be the keys actual name, like F7, J, F9, K, etc
Omnicoinflip.config.denyKeyStr = "F8";
-- What do you wanna download with? In my opinion you SHOULD use workshop.
-- fastdl = FastDL
-- workshop = Workshop
-- everything else = it doesnt download shit
Omnicoinflip.config.downloadMethod = "workshop";
-- How fast should the coin start out?
Omnicoinflip.config.flipStartSpeed = 14;
-- How much should it decrease by every 0.1 sec? This is linear interpolated, don't worry about smoothness
Omnicoinflip.config.flipSpeedDecrease = 0.17;
-- How much is the minimum the coin speed can be at?
Omnicoinflip.config.flipMinSpeed = 3;
-- How many seconds should it take for invite animation to finish?
Omnicoinflip.config.inviteAnimationSec = 0.35;
-- Allow the system to ban someone if it detects a net exploiter? It shouldn't have any false positives, but not 100% sure
Omnicoinflip.config.banExploiters = false;
-- Allow the system to kick someone if it detects a net exploiter? If ban is set to true, the person will get banned, not kicked.
Omnicoinflip.config.kickExploiters = true;







































-- DO NOT TOUCH BELOW
local meta = FindMetaTable("Player");

function meta:OmniCoinFlip_CanAfford( amt )

	local c = Omnicoinflip.config.currency;

	if ( c == "PS1" ) then

		if ( self:PS_HasPoints( amt ) ) then

			return true;

		else

			return false;

		end

	elseif ( c == "PS2_Standard" ) then

		if ( self.PS2_Wallet.points >= amt ) then

			return true;

		else

			return false;

		end

	elseif ( c == "PS2_Premium" ) then

		if ( self.PS2_Wallet.premiumPoints >= amt ) then

			return true;

		else

			return false;

		end

	elseif ( c == "DarkRP" ) then

		if ( self:canAfford(amt) ) then

			return true;

		else

			return false;

		end

	end

end

function meta:OmniCoinFlip_AddPoints( amt )

	local c = Omnicoinflip.config.currency;

	if ( c == "PS1" ) then

		self:PS_GivePoints( amt );

	elseif ( c == "PS2_Standard" ) then

		self:PS2_AddStandardPoints( amt );

	elseif ( c == "PS2_Premium" ) then

		self:PS2_AddPremiumPoints( amt );

	elseif ( c == "DarkRP" ) then

		self:addMoney( amt );

	end

end
