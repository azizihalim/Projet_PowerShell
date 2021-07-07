Install-Module Dashimo -Force
Update-Module Dashimo
Import-Module D:\ESGI\Powershell\Monitoring\Projet_PowerShell\Script\monitoring.ps1
Import-Module D:\ESGI\Powershell\Monitoring\Projet_PowerShell\Script\Script_Services_Process.ps1

$filepath = 'D:\ESGI\Powershell\Monitoring\dashboard.html'
$time = Get-Date
$FirewallRule = Get-NetFirewallRule

Dashboard -Name 'Monitoring' -FilePath $filepath  {
    Tab -Name 'Accueil' {
        Section -Name 'Heure' {
            Table -HideFooter -DataTable $time}
                    }
    Tab -Name 'Hardware' {
        Section -Name 'Processeur : Charges - Vitesses'  {
            Panel {
                Table -HideFooter -DataTable (charge_cpu) {
                    TableConditionalFormatting -Name 'Average' -ComparisonType number -Operator gt -Value 10 -Color White -BackgroundColor Crimson -Row
            }
            }
            Panel {
                Table -HideFooter -DataTable (vitesse_cpu)
                }
        }
        Section -Name 'Mémoire' {
            Table -HideFooter -DataTable (RAM)
            }
        Section -Name 'Informations du disque' {
            Panel{
                Table -HideFooter -DataTable (total_DSize)
            }
            Panel {
                Chart -Title 'Disque utilisé' -TitleAlignment center {}
                Table -HideFooter -DataTable (total_DUsed) 
                }           
            }
        }
    Tab -Name 'Software' {
        Section -Name 'Nombre de services: total, running, stoppés' {
            Panel {
                Table -HideFooter -DataTable (total_services)
            }
            Panel {
                Table -HideFooter -DataTable (total_services_run)
            }
            Panel {
                Table -HideFooter -DataTable (total_services_stop)
            }
        }
        Section -Name 'Liste des services' {
            Table -HideFooter -DataTable (liste_total_services) {
                TableConditionalFormatting -Name 'Status' -ComparisonType string -Operator eq -Value 'Stopped' -Color BlueViolet -Row
            }
            }
        Section -Name 'Règles de Firewall' {
           Table -HideFooter -DataTable (rules_status)
            }
        Section -Name 'Liste des règles Firewall' {
            Table -HideFooter -DataTable $FirewallRule
            }
    }
}
