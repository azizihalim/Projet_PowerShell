#retourne le nombre de services stoppés
function total_services_stop {
    param ()
    return (Get-Service | Where-Object {$_.status -eq "stopped"} | Measure-Object).Count  
}
#retourne la liste des services stoppés
function liste_services_stop {
    param ()
    return (Get-Service | Where-Object {$_.status -eq "stopped"}) 
}
#retourne le nombre de services en cours
function total_services_run {
    return (Get-Service | Where-Object {$_.status -eq "running"} | Measure-Object).Count  
}
#retourne la liste des services en cours
function liste_services_run {
    param ()
    return (Get-Service | Where-Object {$_.status -eq "running"}) 
}
#retourne le nombre de services présent sur le serveur 
function total_services{
    param ()
    return (Get-Service | Measure-Object).Count  
}
#retourne la liste de services sur le serveur 
function liste_total_services{
    param ()
    return Get-Service  
}
#retourne la liste de services recherché en passant paramettre le nom du service
function cherche_service {
    param (
        [string]$nom_service
    )
    return (Get-Service | Where-Object {$_.Name -like "*$nom_service*"})
}
#retourne le pourcentage de charge utilisée du cpu

function charge_cpu {
    return (Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select Average)
}
#retourne la vitesse actuelle et max du cpu
function vitesse_cpu{
    return (Get-WmiObject win32_processor | select -First 1 -Property name, currentclockspeed, maxclockspeed | Format-List)
}

