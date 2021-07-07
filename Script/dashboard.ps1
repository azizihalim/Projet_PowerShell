#Install-Module Dashimo -Force
#Update-Module Dashimo
Import-Module D:\ESGI\Powershell\Monitoring\Projet_PowerShell\Script\monitoring.ps1
Import-Module D:\ESGI\Powershell\Monitoring\Projet_PowerShell\Script\Script_Services_Process.ps1

$filepath = 'D:\ESGI\Powershell\Monitoring\dashboard.html'
$time = Get-Date
$FirewallRule = Get-NetFirewallRule

Dashboard -Name 'Monitoring' -FilePath $filepath  {
    TabOptions -SlimTabs -SelectorColor AntiqueWhite -Transition -LinearGradient -SelectorColorTarget DodgerBlue

    Tab -IconSolid user-alt -IconColor Green -Name 'Accueil' {
        Section -Name 'Heure' {
            Panel {
                Table -HideFooter -DataTable $time {
                    TableConditionalFormatting -Name 'Name' -ComparisonType number -Operator ge -Value 'rezrzer' -BackgroundColor Green -row
                    }
                }
            }
      }

    Tab -Name 'Hardware' {
        Section -Name 'Processeur : Charges - Vitesses'  {
            Panel{
                Table -HideFooter -DataTable (charge_cpu) {
                    TableConditionalFormatting -Name 'Average' -ComparisonType number -Operator gt -Value 10 -Color White -BackgroundColor Crimson -Row
                    }
            }
            Panel {
                Table -HideFooter -DataTable (vitesse_cpu) {
                    TableConditionalFormatting -Name 'currentclockspeed' -ComparisonType number -Operator lt -Value 3000 -Color White -BackgroundColor Green -Row
                    TableConditionalFormatting -Name 'currentclockspeed' -ComparisonType number -Operator ge -Value 3000 -Color White -BackgroundColor Red -Row
                    }
                }
        }
        Section -Name 'Mémoire' {
            Table -HideFooter -DataTable (RAM) {
                    TableConditionalFormatting -Name 'Name' -ComparisonType string -Operator contains -Value 'OK' -Color White -BackgroundColor Green -Row
                    TableConditionalFormatting -Name 'Name' -ComparisonType string -Operator contains -Value 'WARNING' -Color White -BackgroundColor Orange -Row
                    TableConditionalFormatting -Name 'Name' -ComparisonType string -Operator contains -Value 'CRITICAL' -Color White -BackgroundColor Crimson -Row
                    }
            }
        Section -Name 'Informations du disque' {
            Panel{
                Table -HideFooter -DataTable (total_DSize)
                    
            }
            Panel {
                Table -HideFooter -DataTable (total_DUsed) {
                    TableConditionalFormatting -Name 'Name' -ComparisonType string -Operator contains -Value 'OK' -Color White -BackgroundColor Green -Row
                    TableConditionalFormatting -Name 'Name' -ComparisonType string -Operator contains -Value 'CRITICAL' -Color White -BackgroundColor Crimson -Row
                    }
                }           
            }
        }
    Tab -Name 'Software' {
        Section -Name 'Nombre de services: total, running, stoppés'{
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
                TableConditionalFormatting -Name 'Status' -ComparisonType string -Operator eq -Value 'Stopped' -Color Crimson -Row
                TableConditionalFormatting -Name 'Status' -ComparisonType string -Operator eq -Value 'Running' -Color BlueViolet -Row
            }
            }
        Section -Name 'Règles de Firewall' {
           Table -HideFooter -DataTable (rules_status)
            }
        Section -Name 'Liste des règles Firewall' {
            Table -HideFooter -DataTable $FirewallRule -PagingOptions @(5){
                TableConditionalFormatting -Name 'Enabled' -ComparisonType string -Operator eq -Value 'False' -Color Crimson -Row
                TableConditionalFormatting -Name 'Enabled' -ComparisonType string -Operator eq -Value 'True' -Color BlueViolet -Row
                }
            }
    }
}
