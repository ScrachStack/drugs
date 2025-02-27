--Support? https://discord.gg/JPYfWsUswu
Config = {}

Config.CrackHeadModel = 'a_m_o_tramp_01'
Config.SpawnDistance = 5.0
Config.ApproachSpeed = 1.0
Config.DrugDealer = {
    Enabled = true,
}



Config.progressBar = {
    type = "bar",  -- Choose either "bar" or "circle"
    duration = 10000,  -- in milliseconds
    useWhileDead = false,
    canCancel = true,
    controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    },
    animation = {
        animDict = "mp_safehouselost@",
        anim = "package_dropoff",
    }
}


Config.Drugs = {
    ['weed'] = {
        processTime = 5000,
        sellPrice = 200,
        harvestLocation = {x = 1061.8760, y = -82.0950, z = 13.7795},
        processLocation = {x = 167.551651, y = 2015.195557, z = 18.428589},
        sellLocation = {x = 204.2683, y = 210.6775, z = 14.6903},
        harvestRewards = {
            ["weed"] = 2
        },
        processRewards = {
            ["processed_weed"] = 1
        },
        blip = {
            enable = true,
            sprite = 501,
            color = 2,
            label = 'Weed Harvest',
            processLabel = 'Weed Process',
            sellLabel = 'Weed Sell'
        },
    },
    ['cocaine'] = {
        processTime = 7000,
        sellPrice = 300,
        harvestLocation = {x = 1561.9441, y = 581.6257, z = 26.0603},
        processLocation = {x = 400.1, y = 500.1, z = 600.1},
        sellLocation = {x = 700.1, y = 800.1, z = 900.1},
        harvestRewards = {
            ["cocaine"] = 2
        },
        processRewards = {
            ["coke_bag"] = 1
        },
        blip = {
            enable = true, 
            sprite = 501,
            color = 4,
            label = 'Cocaine Harvest',
            processLabel = 'Cocaine Process',
            sellLabel = 'Cocaine Sell'
        },
    },

}
-- If using NDCore dont reffer check ND_ITEMS.lua to this and blame anddyy for making a wack ass framework 
Config.UsableItems = {
    ['backwoods_grape'] = {
        requirements = {
            {item = 'lighter', label = 'You need a lighter to use the weed!'},
            {item = 'weed', label = 'You need weed to roll a blunt!'}
        },
        removeItems = {
            {item = 'backwoods_grape', count = 1},
            {item = 'weed', count = 1}
        },
        addItems = {
            {item = 'blunt', count = 1}
        },
        notification = 'Rolling a leaf...',
        
    },
    ['backwoods_honey'] = {
        requirements = {
            {item = 'lighter', label = 'You need a lighter to use the weed!'},
            {item = 'weed', label = 'You need weed to roll a blunt!'}
        },
        removeItems = {
            {item = 'backwoods_honey', count = 1},
            {item = 'weed', count = 1}
        },
        addItems = {
            {item = 'blunt', count = 1}
        },
        notification = 'Rolling a leaf...',
        
    },
      ['backwoods_russian_cream'] = {
        requirements = {
            {item = 'lighter', label = 'You need a lighter to use the weed!'},
            {item = 'weed', label = 'You need weed to roll a blunt!'}
        },
        removeItems = {
            {item = 'backwoods_russian_cream', count = 1},
            {item = 'weed', count = 1}
        },
        addItems = {
            {item = 'blunt', count = 1}
        },
        notification = 'Rolling a leaf...',
        
    },
    ['blunt'] = {
        requirements = {
            {item = 'lighter', label = 'You need a lighter to use the weed!'}        },
        removeItems = {
            {item = 'blunt', count = 1},
        },
        addItems = {
        },
        notification = 'Lit a blunt',
        clientEffect = 'esx_drug_effects:startWeedEffect'  -- specify client-side effect here
    },
}
