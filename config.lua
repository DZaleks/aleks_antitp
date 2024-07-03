Config = {
    WarnDistance = 300.0,   -- Distance when a warning should be send
    BanDistance = 1000.0,    -- Distance when player will get banned
    WhitelistedCoords = {
        vector3(0.000000, 0.000000, 0.000000), -- default player connecting spawn (do not remove unless you know what youre doing)
        -- add your whitelisted telport locations
    },
    WhitelistPermission = "TPWhitelist" -- add ace permission for admins
    -- add_ace group.admin TPWhitelist allow 
    -- add_ace group.superadmin TPWhitelist allow 
}