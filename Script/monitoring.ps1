# Quantité RAM totale/disponible
function RAM {
$RAM_MAX = (Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1GB
$RAM_FREE = (Get-WmiObject -Class Win32_OperatingSystem).FreePhysicalMemory /1MB
$RAM_USED = ($RAM_MAX - $RAM_FREE)

[STRING]$RAM_MAX + " GB MAX"
$RAM_FREE.ToString('F2') + " GB FREE"
$RAM_USED.ToString('F2') + " GB USED"
}RAM

# Quantité SWAP totale/disponible
$swap = Get-CimInstance -ClassName Win32_PageFileUsage  
$allocated_file = ($swap | Select-Object -Property AllocatedBaseSize).AllocatedBaseSize
$current_usage = ($swap | Select-Object -Property CurrentUsage).CurrentUsage
$max_usage = ($swap | Select-Object -Property PeakUsage).PeakUsage

[STRING]$allocated_file + " MB allocated"
[STRING]$current_usage + " MB current"
[STRING]$max_usage + " MB max"


# Nombre de règles FW enabled/disabled 
function rules_status{
$rules_fw = Get-NetFirewallRule 
$nb_rules = $rules_fw.Count 
$rules_enabled = ($rules_fw | Where-Object{$_.Enabled -eq "True"})
$rules_disabled = ($rules_fw | Where-Object{$_.Enabled -eq "False"})

    if ($rules_enabled) {
        Write-Output "Number of enabled rules : " {$rules_enabled.Count}
    }
    if ($rules_disabled) {
        Write-Output "Number of disabled rules : " $rules_disabled.Count
    }
}rules_status

# Espace disque total
function total_DSize {
    Get-WmiObject -Class Win32_LogicalDisk | 
        Select-Object -Property DeviceID, VolumeName, @{
        label='Size'
        expression={($_.Size/1GB).ToString('F2')}
     } 
}total_DSpace

# Espace disque utilisé 
function total_DUsed {
    Get-WmiObject -Class Win32_LogicalDisk | 
    Select-Object -Property DeviceID, VolumeName, @{
    label='FreeSpace'
    expression={($_.FreeSpace/1GB).ToString('F2')}
 } 

}total_DUsed
    
