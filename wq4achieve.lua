local objectives = {
  {expansion="LEG", name="Commander of Argus/Umbraliss", achievement=12078, quest=48728},
  {expansion="LEG", name="Mission Accomplished", achievement=11475, quest=41896},
  {expansion="LEG", name="Saddle Sore", achievement=11476, quest=42025},
  {expansion="LEG", name="Off the Top Rook", achievement=11477, quest=42023},    
  {expansion="LEG", name="The Darkbrul-oh", achievement=11478, quest=41013},
  {expansion="LEG", name="They See Me Rolling (Rolling Thunder/Broken Shore)", achievement=11607, quest=46175},
  {expansion="BFA", name="Boxing Match", achievement=13438, quest=54516},
  {expansion="BFA", name="Doomsoul Surprise", achievement=13435, quest=54689},
  {expansion="BFA", name="Bless the Rains Down in Freehold", achievement=13050, quests={52159,53196}},
  {expansion="BFA", name="Sabertron Assemble", achievement=13054, quests={51978,51976,51947,51977,51974}}, -- Orange, Green, ?, Yellow, Copper
  {expansion="BFA", name="It's Really Getting Out of Hand", achievement=13023, quests={50559,51127}},
  {expansion="BFA", name="Revenge is Best Served Speedily", achievement=13022, quest=50786},
  {expansion="BFA", name="A Most Efficient Apocalypse", achievement=13021, quest=50665},
  {expansion="BFA", name="Hungry, Hungry Ranishu", achievement=13041, quests={51991,52798}},
  {expansion="BFA", name="Adept Sandfisher", achievement=13009, quest=51173},
  {expansion="SL", name="Flight School Graduate", achievement=14735, quest=60858},
  {expansion="SL", name="What Bastion Remembered", achievement=14737, quests={59717,59705}},
  {expansion="SL", name="Something's Not Quite Right....", achievement=14671, quest=60739},
  {expansion="SL", name="A Bit of This, A Bit of That", achievement=14672, quest=60475},
  {expansion="SL", name="Aerial Ace", achievement=14741, quest=60911},
  {expansion="SL", name="Breaking the Stratus Fear", achievement=14762, quest=60858},
  {expansion="SL", name="Ramparts Racer", achievement=14765, quest=59643},
  {expansion="SL", name="Parasoling", achievement=14766, quest=59718},
  {expansion="SL", name="Friend of Ooz", achievement=15055, quest=64016},
  {expansion="SL", name="Friend of Bloop", achievement=15056, quest=64017},
  {expansion="SL", name="Friend of Plaguey", achievement=15057, quest=63989},
  {expansion="SL", name="Krrprripripkraak's Heroes", achievement=15044, quest=63823},
  {expansion="SL", name="Rooting Out the Evil", achievement=15036, quest=63823},
  {expansion="SL", name="Jailer's Personal Stash", achievement=15001, quest=63823},
  {expansion="SL", name="Tea for the Troubled", achievement=15042, quests={64554,63822}},
  {expansion="SL", name="Wings Against the Flames", achievement=15034, quest=63824},
  {expansion="SL", name="The Zovaal Shuffle", achievement=15041, quest=63824},
  {expansion="SL", name="A Sly Fox", achievement=15004, quest=63824},
  {expansion="SL", name="Up For Grabs", achievement=15039, quest=63543},
  {expansion="SL", name="This Army", achievement=15037, quest=63543},
  {expansion="SL", name="Harvester of Sorrow", achievement=14626, quest=57205},
  {expansion="SL", name="Tea Tales", achievement=14233, quests={59848,59850,59852,59853}},
  {expansion="SL", name="Frog'it (Zereth Mortis)", achievement=15331, quest=65089},
  {expansion="SL", name="Annelid-ilation (for Helmix Rare)", achievement=15391, quest=65232},
  {expansion="SL", name="Impressing Zo'Sorg", achievement=14516, quests={59658,59825,59803,60231}},
  {expansion="DF", name="A Champion's Tour: Dragon Isles", achievement=16590, quests={67005,70439,70209,69949}},
  {expansion="DF", name="Friends In Feathers", achievement=19293, quest=78370},
  {expansion="TWW", name="For the Collective", achievement=40630, quest=82580}
}

-- this tell us if we need to do this achievement
local needs_achieving = function(objective)
  if not objective.achievement then
    return false
  end 
  local _, _, _, Completed = GetAchievementInfo(objective.achievement)
  if Completed then 
    return false
  end
  -- see if WQ is up somehow and not completed
  if objective.quest then
    local v = C_TaskQuest.GetQuestTimeLeftSeconds(objective.quest)
    if v == nil then -- WQ not up
      return false
    end
  end 
  if objective.quests then
    for _, q in ipairs(objective.quests) do
      local v = C_TaskQuest.GetQuestTimeLeftSeconds(q)
      if v == nil then
        -- do nothing
      else
        return true
      end
    end
    return false
  end
  return true
end

local sec_to_hms = function(t)
  local d, h, m, s, st
  d = 0
  h = 0
  m = 0
  s = 0
  st = ""
  if t >= 86400 then
    while t >= 86400 do
      t = t - 86400
      d = d + 1
    end
    st = d .. "d"
  end
  if t >= 3600 then
    while t >= 3600 do
      t = t - 3600
      h = h + 1
    end
    if string.len(st) > 0 then
      st = st .. ", "
    end
    st = st .. h .. "h"
  end
  if t >= 60 then
    while t >= 60 do
      t = t - 60
      m = m + 1
    end
    if string.len(st) > 0 then
      st = st .. ", "
    end
    st = st .. m .. "m"
  end
  s = t
  if s > 0 then
    if string.len(st) > 0 then
      st = st .. ", "
    end
    st = st .. s .. "s"
  end
  return st
end

aura_env.update_display = function()
  aura_env.text = ""
  local v, r
  for _, objective in ipairs(objectives) do
    if needs_achieving(objective) then
      local exp = objective.expansion
      local _, Name = GetAchievementInfo(objective.achievement)
      aura_env.text = aura_env.text .. exp .. ": " .. Name
      --- Single quest requirement
      if objective.quest then
        v = C_TaskQuest.GetQuestTimeLeftSeconds(objective.quest)
      end
      --- Multiple quests requirement
      if objective.quests then
        for _, q in ipairs(objective.quests) do
          r = C_TaskQuest.GetQuestTimeLeftSeconds(q)
          if r == nil then
            -- do nothing
          else
            -- show which quest we care about for cross reference
            aura_env.text = aura_env.text .. " [" .. q .. "]"
            v = r
          end
        end
      end
      aura_env.text = aura_env.text .. " (" .. tostring(sec_to_hms(v)) .. ")"
      aura_env.text = aura_env.text .. "\n"
      
      --- If quests have enumeratable criteria, display it
      local numCriteria = GetAchievementNumCriteria(objective.achievement)
      local cS, comp, qty
      if numCriteria > 0 then
        for addl=1,numCriteria,1 do
          cS,_,comp,qty = GetAchievementCriteriaInfo(objective.achievement, addl)
          aura_env.text = aura_env.text .. ">>> " .. cS .. ": " .. qty
          if comp then
            aura_env.text = aura_env.text .. " (done)"
          end
          aura_env.text = aura_env.text .. "\n"                    
        end
      end
    end
  end
end

aura_env.update_display()
