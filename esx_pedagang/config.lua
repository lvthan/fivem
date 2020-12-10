Config                            = {}
Config.DrawDistance               = 100.0

Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.EnableVaultManagement      = true
Config.EnableHelicopters          = false
Config.EnableMoneyWash            = false
Config.MaxInService               = -1
Config.Locale                     = 'es'

Config.MissCraft                  = 0 -- %


Config.AuthorizedVehicles = {
    { name = 'boxville2',  label = 'Burger Truck' },
}

Config.Blips = {
    
    Blip = {
      Pos     = { x = -629.45867919922, y = 240.05395507813, z = 81.895629882813 },
      Sprite  = 89,
      Display = 4,
      Scale   = 0.8,
      Colour  = 49,
    },

}

Config.Zones = {

    Cloakrooms = {
        Pos   = { x = -634.68615722656, y = 225.95527648926, z = 80.881462097168 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 255, g = 0, b = 0 },
        Type  = 27,
    },

    --[[Vaults = {
        Pos   = { x = -631.92504882813, y = 227.78857421875, z= -8000.881484985352 },
        Size  = { x = 1.3, y = 1.3, z = 1.0 },
        Color = { r = 30, g = 144, b = 255 },
        Type  = 27,
    },

    Fridge = {
        Pos   = { x = -635.45989990234, y = 233.65476989746, z = 80.881469726563 },
        Size  = { x = 1.6, y = 1.6, z = 1.0 },
        Color = { r = 255, g = 0, b = 0 },
        Type  = 27,
    },]]
	
	Cook = {
        Pos   = { x = -631.5791015625, y = 224.5111541748, z = 80.881507873535 },
        Size  = { x = 1.6, y = 1.6, z = 1.0 },
        Color = { r = 0, g = 200, b = 220 },
        Type  = 27,
    },
    Cook2 = {
        Pos   = { x = -628.18621826172, y = 223.83624267578, z = 80.881507873535 },
        Size  = { x = 1.6, y = 1.6, z = 1.0 },
        Color = { r = 0, g = 100, b = 220 },
        Type  = 27,
    },
	
	--[[Vehicles = {
        Pos          = { x =-636.81127929688, y = 238.17799377441, z = 80.900268554688 },
        SpawnPoint   = { x = -641.34124755859, y = 236.78913879395, z = 81.75902557373 },
        Size         = { x = 1.8, y = 1.8, z = 1.0 },
        Color        = { r = 255, g = 255, b = 0 },
        Type         = 27,
        Heading      = 7.91,
    },

    VehicleDeleters = {
        Pos   = { x = -641.34124755859, y = 236.78913879395, z = 80.75902557373 },
        Size  = { x = 3.0, y = 3.0, z = 0.2 },
        Color = { r = 255, g = 255, b = 0 },
        Type  = 27,
    },]]
    
    BossActions = {
        Pos   = { x = -635.10302734375, y = 235.93492126465, z = 81.240104675293 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 27,
    },
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
  barman_outfit = {
    male = {
        ['tshirt_1'] = 22,  ['tshirt_2'] = 0,
        ['torso_1'] = 40,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 6,
        ['pants_1'] = 28,   ['pants_2'] = 0,
        ['shoes_1'] = 10,   ['shoes_2'] = 0,
        ['chain_1'] = 22,  ['chain_2'] = 4
    },
    female = {
        ['tshirt_1'] =39,   ['tshirt_2'] = 2,
        ['torso_1'] = 6,    ['torso_2'] = 7,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 5,
        ['pants_1'] = 23,   ['pants_2'] = 0,
        ['shoes_1'] = 15,    ['shoes_2'] = 4,
        ['chain_1'] = 0,    ['chain_2'] = 0
    }
  }
}
