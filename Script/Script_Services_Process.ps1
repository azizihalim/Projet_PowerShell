function total_services_stop {
    param ()
    return (Get-Service | Where-Object {$_.status -eq "stopped"} | Measure-Object).Count  
}

function liste_services_stop {
    param ()
    return (Get-Service | Where-Object {$_.status -eq "stopped"}) 
}

function total_services_run {
    return (Get-Service | Where-Object {$_.status -eq "running"} | Measure-Object).Count  
}
function liste_services_run {
    param ()
    return (Get-Service | Where-Object {$_.status -eq "running"}) 
}

function total_services{
    param ()
    return (Get-Service | Measure-Object).Count  
}
function liste_total_services{
    param ()
    return Get-Service  
}

function cherche_service {
    param (
        [string]$nom_service
    )
    return (Get-Service | Where-Object {$_.Name -like "*$nom_service*"})
}

function charge_cpu {
    return (Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select Average)
}

function vitesse_cpu{
    return (Get-WmiObject win32_processor | select -First 1 -Property name, currentclockspeed, maxclockspeed | Format-List)
}

