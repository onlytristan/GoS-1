supportedHero = {["Ryze"] = true}
class "Ryze"

function Ryze:__init()

OnLoop(function(myHero) self:Loop(myHero) end)

MainMenu = Menu("Ryze", "Ryze")
MainMenu:SubMenu("Combo", "Combo")
MainMenu.Combo:Boolean("Q", "Use Q", true)
MainMenu.Combo:Boolean("W", "Use W", true)
MainMenu.Combo:Boolean("E", "Use E", true)
MainMenu.Combo:Boolean("R", "Use R", true)
MainMenu.Combo:Boolean("RR", "Use R if rooted", true)
	
MainMenu:SubMenu("LaneClear", "Lane Clear")
MainMenu.LaneClear:Boolean("Q", "Use Q", true)
MainMenu.LaneClear:Boolean("W", "Use W", true)
MainMenu.LaneClear:Boolean("E", "Use E", true)
MainMenu.LaneClear:Boolean("R", "Use R", false)

MainMenu:SubMenu("JungleClear", "Jungle Clear")
MainMenu.JungleClear:Boolean("Q", "Use Q", true)
MainMenu.JungleClear:Boolean("W", "Use W", true)
MainMenu.JungleClear:Boolean("E", "Use E", true)
MainMenu.JungleClear:Boolean("R", "Use R", false)

MainMenu:SubMenu("Misc", "Misc")
MainMenu.Misc:Boolean("AutoLevelS", "Auto-Level Spells", true)
	
MainMenu:SubMenu("Drawings", "Drawings")
MainMenu.Drawings:Boolean("ED", "Enable Drawings", true)
MainMenu.Drawings:Boolean("DQ", "Draw Q Range", true)
MainMenu.Drawings:Boolean("DWE", "Draw W + E Range", true)
MainMenu.Drawings:Slider("DrawHD", "Quality Circles", 255, 1, 255, 1)
	
end
--Updated 5.17.

function Ryze:Loop(myHero)
if _G.IOW:Mode() == "Combo" then 
	self:DoCombo1()
	end
	
if _G.IOW:Mode() == "Combo" then 
	self:DoCombo2()
	end

if 	IOW:Mode() == "LaneClear" then
	self:LaneClear()
	end	
	
if 	IOW:Mode() == "JungleClear" then
	self:JungleClear()
	end		

if	MainMenu.Misc.AutoLevelS:Value() then
	self:AutoLevelS()
	end

if 	MainMenu.Drawings.ED:Value() then
	self:Drawings()
	end
end


function Ryze:DoCombo1()
if IOW:Mode() == "Combo" and GotBuff(myHero, "ryzepassivestacks") >= 2 then 
	local target = IOW:GetTarget()
			
	if GoS:ValidTarget(target, 900) then					
		if CanUseSpell(myHero, _W) == READY and MainMenu.Combo.W:Value() then
			CastTargetSpell(target, _W)
			end                     	
		
		local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),900,250,GetCastRange(myHero,_Q),55,false,true)
		local ChampEnemy = GetOrigin(target)		
		if CanUseSpell(myHero, _Q) == READY and (GotBuff(target, "RyzeW") == 1) and MainMenu.Combo.Q:Value() then
			CastSkillShot(_Q,ChampEnemy.x,ChampEnemy.y,ChampEnemy.z)						
		elseif CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and not (GotBuff(target, "RyzeW") == 1) and MainMenu.Combo.Q:Value() then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)						
			end

		if CanUseSpell(myHero, _E) == READY and MainMenu.Combo.E:Value() then
			CastTargetSpell(target, _E)
			end

		if CanUseSpell(myHero, _R) == READY and MainMenu.Combo.R:Value() and (GotBuff(myHero, "ryzepassivecharged") > 0) then
			CastSpell(_R)
		elseif CanUseSpell(myHero, _R) == READY and MainMenu.Combo.RR:Value() and (GotBuff(myHero, "ryzepassivecharged") > 0) and (GotBuff(target , "RyzeW") == 1) then
			CastSpell(_R)
			end
		end
	end
end

function Ryze:DoCombo2()
if IOW:Mode() == "Combo" and GotBuff(myHero, "ryzepassivestacks") <= 1 then 
	local target = IOW:GetTarget()
			
	if GoS:ValidTarget(target, 900) then							                     			
		local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),900,250,GetCastRange(myHero,_Q),55,false,true)
		local ChampEnemy = GetOrigin(target)		
		if CanUseSpell(myHero, _Q) == READY and (GotBuff(target, "RyzeW") == 1) and MainMenu.Combo.Q:Value() then
			CastSkillShot(_Q,ChampEnemy.x,ChampEnemy.y,ChampEnemy.z)						
		elseif CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and not (GotBuff(target, "RyzeW") == 1) and MainMenu.Combo.Q:Value() then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)						
			end

		if CanUseSpell(myHero, _W) == READY and MainMenu.Combo.W:Value() then
			CastTargetSpell(target, _W)
			end
		
		if CanUseSpell(myHero, _E) == READY and MainMenu.Combo.E:Value() then
			CastTargetSpell(target, _E)
			end

		if CanUseSpell(myHero, _R) == READY and MainMenu.Combo.R:Value() then
			CastSpell(_R)
			end
		end
	end
end

function Ryze:LaneClear()
if IOW:Mode() == "LaneClear" then      
                for i,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do    
                        if GoS:IsInDistance(minion, 600) then
                        local PMinion = GetOrigin(minion)
						if CanUseSpell(myHero, _W) == READY and MainMenu.LaneClear.W:Value() then
						CastTargetSpell(minion, _W)
						end
						
						if CanUseSpell(myHero, _Q) == READY  and MainMenu.LaneClear.Q:Value() then
						CastSkillShot(_Q,PMinion.x,PMinion.y,PMinion.z)
						end		
						
						if CanUseSpell(myHero, _E) == READY and MainMenu.LaneClear.E:Value() then
						CastTargetSpell(minion, _E)
						end 		
             
						if CanUseSpell(myHero, _R) == READY and MainMenu.LaneClear.R:Value() and (GotBuff(myHero, "ryzepassivecharged") > 0) then
						CastSpell(_R)			 
						end
					end
		end
    end    
end

function Ryze:JungleClear()
if IOW:Mode() == "JungleClear" then      
                for i,minion in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do    
                        if GoS:IsInDistance(minion, 600) then
                        local PMinion = GetOrigin(minion)
						if CanUseSpell(myHero, _W) == READY and MainMenu.JungleClear.W:Value() then
						CastTargetSpell(minion, _W)
						end
						
						if CanUseSpell(myHero, _Q) == READY  and MainMenu.JungleClear.Q:Value() then
						CastSkillShot(_Q,PMinion.x,PMinion.y,PMinion.z)
						end		
						
						if CanUseSpell(myHero, _E) == READY and MainMenu.JungleClear.E:Value() then
						CastTargetSpell(minion, _E)
						end 		
             
						if CanUseSpell(myHero, _R) == READY and MainMenu.JungleClear.R:Value() and (GotBuff(myHero, "ryzepassivecharged") > 0) then
						CastSpell(_R)			 
						end
          		end
       		end
		end    
end

function Ryze:AutoLevelS()
if GetLevel(myHero) == 1 then
	LevelSpell(_Q)
elseif GetLevel(myHero) == 2 then
	LevelSpell(_W)
elseif GetLevel(myHero) == 3 then
	LevelSpell(_E)
elseif GetLevel(myHero) == 4 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 5 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 6 then
	LevelSpell(_R)
elseif GetLevel(myHero) == 7 then
	LevelSpell(_Q)
elseif GetLevel(myHero) == 8 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 9 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 10 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 11 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 12 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 13 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 14 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 15 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 16 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 17 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 18 then
        LevelSpell(_E)
end
end

function Ryze:Drawings()
if MainMenu.Drawings.DQ:Value() then
	DrawCircle(GetOrigin(myHero),895,3,MainMenu.Drawings.DrawHD:Value(),0xff7B68EE)
	end
if MainMenu.Drawings.DWE:Value() then
	DrawCircle(GetOrigin(myHero),600,3,MainMenu.Drawings.DrawHD:Value(),0xff7B68EE)
	end
end

if supportedHero[GetObjectName(myHero)] == true then
if _G[GetObjectName(myHero)] then
  _G[GetObjectName(myHero)]()
end 
end
