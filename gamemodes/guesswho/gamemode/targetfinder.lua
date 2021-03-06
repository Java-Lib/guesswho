function GM:TargetFinderThink()
	for _, ply in pairs(player.GetAll()) do
		if ply:IsSeeking() then
			local minDist = -1
			for _, target in pairs( team.GetPlayers(TEAM_HIDING) ) do
				local dist = ply:GetPos():Distance(target:GetPos())
				if minDist == -1 or dist < minDist then
					minDist = dist

					-- if target is to close dont show actual distance jsut show "close" clientside
					if dist < GetConVar( "gw_target_finder_threshold" ):GetInt() then
						minDist = 0
					end
				end
			end
			ply:SetNWFloat("gwClosestTargetDistance", minDist)
		end
	end
end
