-- TODO: Maybe materials? Shouldn't be too hard to send to clients... However to replace all rendering with that material :/
-- Could be a pain to find a solution. So I'll prob not bother.
error_replacement = {
    ignoredModels = { -- TODO: Utility needed to fill this with defaults easier.
        
    },
    netMessageInterval = 0.05, -- Time between net messages being sent. (Will only go as low as your tick rate. For instance with 16 tickrate 0.0625 is the shortest it will go.)
    -- This will make a queue if multiple people are requesting models. Any queue should empty quickly as it's 20 per second.
}