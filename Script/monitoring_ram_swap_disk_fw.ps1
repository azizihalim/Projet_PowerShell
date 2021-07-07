# Quantité RAM totale/disponible
function RAM {
    $RAM_MAX = (Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1GB
    $RAM_FREE = (Get-WmiObject -Class Win32_OperatingSystem).FreePhysicalMemory /1MB
    $RAM_USED = ($RAM_MAX - $RAM_FREE)

    [STRING]$RAM_MAX + " GB MAX"
    $RAM_FREE = $RAM_FREE.ToString('F2') + " GB FREE"
    $RAM_USED.ToString('F2') + " GB USED"

    if ($RAM_FREE -gt 1 -and $RAM_FREE -lt 4) {
        Write-Output "WARNING : $RAM_FREE"
    }elseif ($RAM_FREE -lt 1) {
        Write-Output "CRITICAL : $RAM_FREE"
    }else {
        Write-Output "OK : $RAM_FREE"
    }
}RAM
 
# Quantité SWAP totale/disponible
function swap{
    $swap = Get-CimInstance -ClassName Win32_PageFileUsage  
    $allocated_file = ($swap | Select-Object -Property AllocatedBaseSize).AllocatedBaseSize
    $current_usage = ($swap | Select-Object -Property CurrentUsage).CurrentUsage
    $max_usage = ($swap | Select-Object -Property PeakUsage).PeakUsage

    [STRING]$allocated_file + " MB allocated"
    [STRING]$current_usage + " MB current"
    [STRING]$max_usage + " MB max"
}swap

# Nombre de règles FW enabled/disabled 
function rules_status{
    $rules_fw = Get-NetFirewallRule 
    $nb_rules = $rules_fw.Count 
    $rules_enabled = ($rules_fw | Where-Object{$_.Enabled -eq "True"})
    $rules_disabled = ($rules_fw | Where-Object{$_.Enabled -eq "False"})
    $rules_encount = $rules_enabled.Count
    $rules_dicount = $rules_disabled.Count

    if ($rules_enabled) {
        Write-Output "Number of enabled rules : $rules_encount"
    }
    if ($rules_disabled) {
        Write-Output "Number of disabled rules : $rules_dicount"
    }
}rules_status

# Espace disque total
function total_DSize {
    #$DSize = Get-WmiObject -Class Win32_LogicalDisk | 
    #Select-Object -Property DeviceID, VolumeName, @{
    #label='Size'
    #expression={($_.Size/1GB).ToString('F2')}
   # } 
    #return $DSize
    $DSize = Get-WmiObject -Class Win32_LogicalDisk | Select-Object -Property DeviceID, VolumeName, Size
    $DSize#ToString('F2')
    foreach ($s in ($DSize.Size)) {
    $s = (($s/1000000000)).ToString('F2')
    $s + " GB"
    }
}total_DSize

# Espace disque utilisé 
function total_DUsed {
    $DUsed = Get-WmiObject -Class Win32_LogicalDisk | 
    Select-Object -Property DeviceID, VolumeName, @{
    label='FreeSpace'
    expression={($_.FreeSpace * 100/$_.Size).ToString('F2')}
    }  
    foreach($d in ($DUsed).FreeSpace)
    {
        #Write-Output $d
        if ($d -gt 10 -and $d -lt 20) {
            Write-Output "WARNING : $d % free space"
        }elseif ($d -lt 10) {
            Write-Output "CRITICAL : $d"
        }else {
        Write-Output "OK : $d"
        }
    }
}total_DUsed
    
