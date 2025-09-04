# ==============================
# Windows Optimizer - Created by Phimenton
# ==============================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ------------------------------
# Main Form
# ------------------------------
$form = New-Object System.Windows.Forms.Form
$form.Text = "PC Optimizer - By Phimenton"
$form.Size = New-Object System.Drawing.Size(700,500)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(40,40,40)

# Title
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "PC Optimizer"
$lblTitle.ForeColor = "White"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI",20,[System.Drawing.FontStyle]::Bold)
$lblTitle.AutoSize = $true
$lblTitle.Location = New-Object System.Drawing.Point(250,10)
$form.Controls.Add($lblTitle)

# Author
$lblAuthor = New-Object System.Windows.Forms.Label
$lblAuthor.Text = "Created by Phimenton"
$lblAuthor.ForeColor = [System.Drawing.Color]::FromArgb(0,200,100)
$lblAuthor.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Italic)
$lblAuthor.AutoSize = $true
$lblAuthor.Location = New-Object System.Drawing.Point(500,440)
$form.Controls.Add($lblAuthor)

# ------------------------------
# Tabs
# ------------------------------
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(660,400)
$tabControl.Location = New-Object System.Drawing.Point(20,50)

$tabTweaks     = New-Object System.Windows.Forms.TabPage
$tabTweaks.Text = "Tweaks"
$tabApps       = New-Object System.Windows.Forms.TabPage
$tabApps.Text = "Apps"
$tabMultimedia = New-Object System.Windows.Forms.TabPage
$tabMultimedia.Text = "Multimedia"
$tabUtilities  = New-Object System.Windows.Forms.TabPage
$tabUtilities.Text = "Utilities"

$tabControl.TabPages.AddRange(@($tabTweaks,$tabApps,$tabMultimedia,$tabUtilities))
$form.Controls.Add($tabControl)

# ------------------------------
# Helper Function - Buttons
# ------------------------------
function New-RoundedButton {
    param([string]$text,[int]$y,[scriptblock]$action)
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(200,40)
    $btn.Location = New-Object System.Drawing.Point(30,$y)
    $btn.BackColor = [System.Drawing.Color]::FromArgb(70,130,180)
    $btn.ForeColor = "White"
    $btn.FlatStyle = "Flat"
    $btn.Add_Click($action)
    return $btn
}

# ------------------------------
# Tweaks Tab
# ------------------------------
$btnRestore = New-RoundedButton "Crear punto de restauración" 30 {
    Checkpoint-Computer -Description "RestorePoint" -RestorePointType "MODIFY_SETTINGS"
    [System.Windows.Forms.MessageBox]::Show("Punto de restauración creado.")
}
$tabTweaks.Controls.Add($btnRestore)

$btnSFC = New-RoundedButton "Ejecutar SFC /scannow" 80 {
    Start-Process "sfc" "/scannow" -Verb RunAs
}
$tabTweaks.Controls.Add($btnSFC)

$btnTelemetry = New-RoundedButton "Desactivar Telemetría" 130 {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0
    [System.Windows.Forms.MessageBox]::Show("Telemetría desactivada.")
}
$tabTweaks.Controls.Add($btnTelemetry)

$btnCortana = New-RoundedButton "Desinstalar Cortana" 180 {
    Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage
    [System.Windows.Forms.MessageBox]::Show("Cortana desinstalada.")
}
$tabTweaks.Controls.Add($btnCortana)

$btnBloatware = New-RoundedButton "Eliminar Bloatware" 230 {
    Get-AppxPackage -AllUsers | Where-Object {
        $_.Name -notlike "*Store*" -and
        $_.Name -notlike "*Calculator*" -and
        $_.Name -notlike "*Photos*"
    } | Remove-AppxPackage
    [System.Windows.Forms.MessageBox]::Show("Bloatware eliminado.")
}
$tabTweaks.Controls.Add($btnBloatware)

# ------------------------------
# Apps Tab
# ------------------------------
$apps = @(
    @{ Name = "Brave"; URL = "https://laptop-updates.brave.com/latest/winx64" }
    @{ Name = "Google Chrome"; URL = "https://dl.google.com/chrome/install/latest/chrome_installer.exe" }
    @{ Name = "Discord"; URL = "https://discord.com/api/download?platform=win" }
    @{ Name = "Telegram"; URL = "https://telegram.org/dl/desktop/win64" }
)

foreach ($app in $apps) {
    $btn = New-RoundedButton $app.Name (30 + ($apps.IndexOf($app) * 50)) {
        try {
            Start-Process "msedge.exe" $app.URL
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error instalando $($app.Name): $($_.Exception.Message)")
        }
    }
    $tabApps.Controls.Add($btn)
}

# ------------------------------
# Multimedia Tab
# ------------------------------
$mediaApps = @(
    @{ Name = "Spotify"; URL = "https://download.scdn.co/SpotifySetup.exe" }
    @{ Name = "VLC"; URL = "https://get.videolan.org/vlc/last/win64/vlc-3.0.20-win64.exe" }
)

foreach ($mApp in $mediaApps) {
    $btn = New-RoundedButton $mApp.Name (30 + ($mediaApps.IndexOf($mApp) * 50)) {
        try {
            Start-Process "msedge.exe" $mApp.URL
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error instalando $($mApp.Name): $($_.Exception.Message)")
        }
    }
    $tabMultimedia.Controls.Add($btn)
}

# ------------------------------
# Utilities Tab
# ------------------------------
$utilities = @(
    @{ Name = "7-Zip"; URL = "https://www.7-zip.org/a/7z1900-x64.exe" }
    @{ Name = "WinRAR"; URL = "https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-611.exe" }
    @{ Name = "AnyDesk"; URL = "https://download.anydesk.com/AnyDesk.exe" }
    @{ Name = "TeamViewer"; URL = "https://download.teamviewer.com/download/TeamViewer_Setup.exe" }
    @{ Name = "CPU-Z"; URL = "https://download.cpuid.com/cpu-z/cpu-z_2.08-en.exe" }
    @{ Name = "CrystalDiskInfo"; URL = "https://osdn.net/projects/crystaldiskinfo/downloads/77845/CrystalDiskInfo8_17_4.exe" }
    @{ Name = "GPU-Z"; URL = "https://us2-dl.techpowerup.com/files/GPU-Z.2.52.0.exe" }
    @{ Name = "Revo Uninstaller"; URL = "https://download.revouninstaller.com/download/revosetup.exe" }
)

foreach ($uApp in $utilities) {
    $btn = New-RoundedButton $uApp.Name (30 + ($utilities.IndexOf($uApp) * 50)) {
        try {
            Start-Process "msedge.exe" $uApp.URL
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error instalando $($uApp.Name): $($_.Exception.Message)")
        }
    }
    $tabUtilities.Controls.Add($btn)
}

# ------------------------------
# Run Form
# ------------------------------
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
