Config = {}

Config.EnableWebhook = true         --> if true you need to have DFNZ_LOGGER installed (also set Config.UseLogger to true) or implement your own system in server.lua line 19
Config.UseLogger = true             --> if true you need to have DFNZ_LOGGER installed and started it before this script
                                    --> to set your webhook link go to server.lua line 1

Config.UseTarget = false            --> if true you need to have ox_target installed

Config.Command = 'guidetour'        --> shows the last text again
Config.AdminCommand = 'reset_guide' --> resets the guide status to not done for the chosen player (EXAMPLE: reset_guide 1) 1 = PlayerID 1

Config.TextUi = {
    position = 'right-center',
    icon = 'circle-info',
    animation = 'beatFade',
    iconColor = '#fffff',
    key = 'E'                       --> your interaction key 
}

Config.Notify = {
    position = 'top',
    duration = 4,                   --> in seconds
    animation = 'beatFade'
}

Config.Location = {
    coords = vec4(-1037.08, -2736.68, 20.16, 149.94),
    ped = 'a_m_y_smartcaspat_01',
    blip = true,
    blipSettings = {sprite = 280, color = 53, size = 0.8, name = 'Guidetour'}
}

Config.RouteBlip = {
    size = 0.8,
    sprite = 119,
    color = 53
}

Config.Car = {
    plate = 'guide',
    model = 'blista',
    coords = vec4(-1035.4093, -2728.9424, 20.0894, 240.9389)
}

Config.Route = {                    --> you can add more if you want, simply follow the exmaple
    [1] = {
        coords = vec3(24.7408, -1374.4160, 29.3485),
        text = 'To your left side is one of our 24/7 stores, here you can buy and sell items'
    }, 
    [2] = {
        coords = vec3(232.4296, -1394.9630, 30.5056),
        text = 'Here is our driving school, better make your license if you dont want trouble with the LSPD'
    },
    [3] = {
        coords = vec3(-50.1008, -1129.2181, 25.8981),
        text = 'To your right is our vehicleshop, here can you buy a lot of nice cars and bikes'
    },
    [4] = {
        coords = vec3(402.9027, -991.3781, 29.3623),
        text = 'To your right is the LSPD, better only be here if you need help'
    },
    [5] = {
        coords = vec3(410.2342, -810.0514, 29.2231),
        text = 'To your right is a Binco store, here can you buy new clothes or change your current outfit'
    },
    [6] = {
        coords = vec3(256.0829, -835.1949, 29.5153),
        text = 'To your left is the Legion Square here you can met a lot of new people'
    },
    [7] = {
        coords = vec3(230.5457, -798.7048, 30.5697),
        text = 'You have sucessfully done the guidetour, here is your reward'
    },
    -- [8] = {
    --     coords = vec3(),
    --     text = ''
    -- },
}

Config.SuccessItems = {             --> you can add more if you want, simply follow the exmaple
    ['money'] = 1000,
    ['phone'] = 1,
    ['water'] = 5,
    ['burger'] = 5,
    --  ['item'] = amount
}

Config.Text = {                     --> english translation
    ['textui'] = 'Press ['..Config.TextUi.key..'] to start the guidetour',
    ['target'] = 'start guidetour',
    ['keyInfo'] = 'Press to start the guidetour',
    ['allready_done'] = 'You does the guidetour allready!',
    ['no_parking_space'] = 'Something blocks the vehicle spawnpoint!',
    ['new_waypoint'] = 'A new waypoint is marked on your map',
    ['command_info'] = 'To show your last point again use the command: '..Config.Command,
    ['next_stop'] = 'Next Stop',
    ['accept'] = 'Okay!',
    ['show_text_header'] = 'Guidetour',
    ['guide_complete_wbh'] = 'has completed the guidetour',
    ['guide_complete'] = 'Guidetour completed',
    ['admin_help_info'] = 'Enter the player id',
    ['admin_help'] = 'Resets the player guidetour status',
    ['resource_stop'] = 'The script has been stopped, your guidetour ended. Please try again later'
}

-- Config.Text = {                     --> german translation
--     ['textui'] = '['..Config.TextUi.key..'] Einführung starten',
--     ['target'] = 'Einführung starten',
--     ['keyInfo'] = 'Um die Einführung zu starten',
--     ['allready_done'] = 'Du hast die Einführung schon erledigt!',
--     ['no_parking_space'] = 'Etwas blockiert den Ausparkpunkt!',
--     ['new_waypoint'] = 'Eine neue Location wurde markiert',
--     ['command_info'] = 'Um den letzten Text nochmal zu sehen benutze diesen Befehl: '..Config.Command,
--     ['next_stop'] = 'Nächster Halt',
--     ['accept'] = 'Okay!',
--     ['show_text_header'] = 'Einführung',
--     ['guide_complete_wbh'] = 'hat die Einführung abgeschlossen',
--     ['guide_complete'] = 'Einführung abgeschlossen',
--     ['admin_help_info'] = 'Gebe die Spieler ID ein',
--     ['admin_help'] = 'Setz den Einführungsstatus für den Spieler zurück',
--     ['resource_stop'] = 'Das Script wurde gestoppt, bitte versuch es später noch einmal'
-- }