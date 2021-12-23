local objectives = {
    {expansion="BFA", name="Doomsoul Surprise", achievement=13435, quest=54689},
    {expansion="BFA", name="Bless the Rains Down in Freehold", achievement=13050, quests={52159,53196}},
    {expansion="BFA", name="Sabertron Assemble", achievement=13054, quests={51978,51976,51947,51977,51974}},
    {expansion="BFA", name="It's Really Getting Out of Hand", achievement=13023, quests={50559,51127}},
    {expansion="BFA", name="Revenge is Best Served Speedily", achievement=13022, quest=50786},
    {expansion="BFA", name="A Most Efficient Apocalypse", achievement=13021, quest=50665},
    {expansion="BFA", name="Hungry, Hungry Ranishu", achievement=13041, quests={51991,52798}},
    {expansion="SL", name="Flight School Graduate", achievement=14735, quest=60858},
    {expansion="SL", name="What Bastion Remembered", achievement=14737, quests={59717,59705}},
    {expansion="SL", name="Something's Not Quite Right....", achievement=14671, quest=60739},
    {expansion="SL", name="A Bit of This, A Bit of That", achievement=14672, quest=60475},
    {expansion="SL", name="Aerial Ace", achievement=14741, quest=60911},
    {expansion="SL", name="Breaking the Stratus Fear", achievement=14762, quest=60858},
    {expansion="SL", name="Ramparts Racer", achievement=14765, quest=59643},
    {expansion="SL", name="Parasoling", achievement=14766, quest=59718},
    {expansion="SL", name="Friend of Ooz", achievement=15055, quest=64016},
    {expansion="SL", name="Friend of Bloop", achievement=15055, quest=64017},
    {expansion="SL", name="Friend of Plaguey", achievement=15055, quest=63989},
    {expansion="SL", name="Krrprripripkraak's Heroes", achievement=15044, quest=63823},
    {expansion="SL", name="Rooting Out the Evil", achievement=15036, quest=63823},
    {expansion="SL", name="Jailer's Personal Stash", achievement=15001, quest=63823},
    {expansion="SL", name="Tea for the Troubled", achievement=15042, quests={64554,63822}},
    {expansion="SL", name="Wings Against the Flames", achievement=15034, quest=63824},
    {expansion="SL", name="The Zovaal Shuffle", achievement=15041, quest=63824},
    {expansion="SL", name="Up For Grabs", achievement=15039, quest=63543},
    {expansion="SL", name="This Army", achievement=15037, quest=63543},
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

aura_env.update_display = function()
    aura_env.text = ""
    local v, r
    for _, objective in ipairs(objectives) do
        if needs_achieving(objective) then
            local exp = objective.expansion
            local _, Name = GetAchievementInfo(objective.achievement)
            aura_env.text = aura_env.text .. exp .. ": " .. Name
            if objective.quest then
                v = C_TaskQuest.GetQuestTimeLeftSeconds(objective.quest)
            end
            if objective.quests then
                
                for _, q in ipairs(objective.quests) do
                    r = C_TaskQuest.GetQuestTimeLeftSeconds(q)
                    if r == nil then
                        -- do nothing
                    else
                        v = r
                    end
                end                
            end
            aura_env.text = aura_env.text .. " (" .. tostring(v) .. "s)"
            aura_env.text = aura_env.text .. "\n"
        end        
    end    
end

aura_env.update_display()
