<#
    Optimizer by Phimenton
    Modern PowerShell PC Optimizer with GUI
    Created by Phimenton
#>

# ------------------------------
# LOAD .NET FORMS
# ------------------------------
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ------------------------------
# GLOBAL STYLE
# ------------------------------
$Form                 = New-Object System.Windows.Forms.Form
$Form.Text            = "PC Optimizer - Created by Phimenton"
$Form.Size            = New-Object System.Drawing.Size(950,600)
$Form.StartPosition   = "CenterScreen"
$Form.BackColor       = [System.Drawing.Color]::FromArgb(20,20,20)

# FONT COLORS
$primaryColor   = [System.Drawing.Color]::FromArgb(0, 200, 200)   # cyan neón
$accentColor    = [System.Drawing.Color]::FromArgb(0, 180, 80)    # verde acento
$textColor      = [System.Drawing.Color]::White

# ------------------------------
# HEADER LABEL
# ------------------------------
$Header                 = New-Object System.Windows.Forms.Label
$Header.Text            = "PC Optimizer Dashboard"
$Header.ForeColor       = $primaryColor
$Header.Font            = New-Object System.Drawing.Font("Segoe UI",20,[System.Drawing.FontStyle]::Bold)
$Header.AutoSize        = $true
$Header.Location        = New-Object System.Drawing.Point(300,20)
$Form.Controls.Add($Header)

# ------------------------------
# SIDE MENU PANEL
# ------------------------------
$SideMenu               = New-Object System.Windows.Forms.Panel
$SideMenu.Size          = New-Object System.Drawing.Size(200,550)
$SideMenu.BackColor     = [System.Drawing.Color]::FromArgb(30,30,30)
$SideMenu.Dock          = "Left"
$Form.Controls.Add($SideMenu)

# ------------------------------
# CONTENT PANEL
# ------------------------------
$Content                = New-Object System.Windows.Forms.Panel
$Content.Size           = New-Object System.Drawing.Size(730,500)
$Content.Location       = New-Object System.Drawing.Point(210,70)
$Content.BackColor      = [System.Drawing.Color]::FromArgb(25,25,25)
$Form.Controls.Add($Content)

# ------------------------------
# FOOTER (CREDIT)
# ------------------------------
$Footer                 = New-Object System.Windows.Forms.Label
$Footer.Text            = "Created by Phimenton"
$Footer.ForeColor       = $accentColor
$Footer.Font            = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Italic)
$Footer.AutoSize        = $true
$Footer.Location        = New-Object System.Drawing.Point(400,540)
$Form.Controls.Add($Footer)

# ------------------------------
# HELPER: CREATE BUTTONS
# ------------------------------
function New-MenuButton($text,$yPos,$onClick) {
    $btn                 = New-Object System.Windows.Forms.Button
    $btn.Text            = $text
    $btn.Size            = New-Object System.Drawing.Size(180,40)
    $btn.Location        = New-Object System.Drawing.Point(10,$yPos)
    $btn.FlatStyle       = "Flat"
    $btn.BackColor       = [System.Drawing.Color]::FromArgb(45,45,45)
    $btn.ForeColor       = $textColor
    $btn.Font            = New-Object System.Drawing.Font("Segoe UI",11,[System.Drawing.FontStyle]::Bold)
    $btn.Add_Click($onClick)
    $SideMenu.Controls.Add($btn)
}

function Clear-Content {
    $Content.Controls.Clear()
}

function Add-ContentLabel($text,$yPos) {
    $lbl                 = New-Object System.Windows.Forms.Label
    $lbl.Text            = $text
    $lbl.ForeColor       = $primaryColor
    $lbl.Font            = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)
    $lbl.AutoSize        = $true
    $lbl.Location        = New-Object System.Drawing.Point(20,$yPos)
    $Content.Controls.Add($lbl)
}

function Add-ContentButton($text,$yPos,$onClick) {
    $btn                 = New-Object System.Windows.Forms.Button
    $btn.Text            = $text
    $btn.Size            = New-Object System.Drawing.Size(200,35)
    $btn.Location        = New-Object System.Drawing.Point(20,$yPos)
    $btn.BackColor       = [System.Drawing.Color]::FromArgb(50,50,50)
    $btn.FlatStyle       = "Flat"
    $btn.ForeColor       = $textColor
    $btn.Font            = New-Object System.Drawing.Font("Segoe UI",10)
    $btn.Add_Click($onClick)
    $Content.Controls.Add($btn)
}

# ------------------------------
# TWEAKS PAGE
# ------------------------------
function Show-Tweaks {
    Clear-Content
    Add-ContentLabel "System Tweaks" 10

    Add-ContentButton "Create Restore Point" 50 { Checkpoint-Computer -Description "PhimentonOptimizer" -RestorePointType "MODIFY_SETTINGS" }
    Add-ContentButton "Run SFC ScanNow" 90 { Start-Process "sfc.exe" "/scannow" -Verb RunAs }
    Add-ContentButton "Disable Telemetry" 130 { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name AllowTelemetry -Value 0 -Force }
    Add-ContentButton "Disable Cortana" 170 { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name AllowCortana -Value 0 -Force }
    Add-ContentButton "Remove Bloatware (UWP)" 210 { Get-AppxPackage -AllUsers | Remove-AppxPackage }
    Add-ContentButton "Disable Animations" 250 { Set-ItemProperty "HKCU:\Control Panel\Desktop" "UserPreferencesMask" ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) }
    Add-ContentButton "Faster Shutdown" 290 { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name WaitToKillServiceTimeout -Value 2000 }
    Add-ContentButton "Disable Windows Search Index" 330 { Stop-Service WSearch -Force; Set-Service WSearch -StartupType Disabled }
    Add-ContentButton "Disable OneDrive" 370 { Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue; Start-Process "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" "/uninstall" }
    Add-ContentButton "Optimize Network (Low Latency)" 410 { New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\MSMQ\Parameters" -Name TCPNoDelay -PropertyType DWord -Value 1 -Force }
}

# ------------------------------
# APPS PAGE
# ------------------------------
function Show-Apps {
    Clear-Content
    Add-ContentLabel "General Apps" 10

    $apps = @(
        @{ Name="Brave"; URL="https://laptop-updates.brave.com/latest/winx64" }
        @{ Name="Google Chrome"; URL="https://dl.google.com/chrome/install/latest/chrome_installer.exe" }
        @{ Name="Firefox"; URL="https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US" }
        @{ Name="Discord"; URL="https://discord.com/api/download?platform=win" }
        @{ Name="Telegram"; URL="https://telegram.org/dl/desktop/win64" }
        @{ Name="Notepad++"; URL="https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.4/npp.8.6.4.Installer.x64.exe" }
        @{ Name="Visual Studio Code"; URL="https://update.code.visualstudio.com/latest/win32-x64-user/stable" }
    )

    $y=50
    foreach ($app in $apps) {
        Add-ContentButton $app.Name $y { Start-Process $app.URL }
        $y+=40
    }
}

# ------------------------------
# MULTIMEDIA PAGE
# ------------------------------
function Show-Multimedia {
    Clear-Content
    Add-ContentLabel "Multimedia Tools" 10

    $apps = @(
        @{ Name="Spotify"; URL="https://download.scdn.co/SpotifySetup.exe" }
        @{ Name="VLC"; URL="https://get.videolan.org/vlc/last/win64/vlc-3.0.20-win64.exe" }
        @{ Name="OBS Studio"; URL="https://cdn-fastly.obsproject.com/downloads/OBS-Studio-30.0.2-Full-Installer-x64.exe" }
        @{ Name="GIMP"; URL="https://download.gimp.org/gimp/v2.10/windows/gimp-2.10.36-setup.exe" }
        @{ Name="Audacity"; URL="https://github.com/audacity/audacity/releases/download/Audacity-3.4.2/audacity-win-3.4.2-64bit.exe" }
    )

    $y=50
    foreach ($app in $apps) {
        Add-ContentButton $app.Name $y { Start-Process $app.URL }
        $y+=40
    }
}

# ------------------------------
# UTILITIES PAGE
# ------------------------------
function Show-Utilities {
    Clear-Content
    Add-ContentLabel "Utilities" 10

    $apps = @(
        @{ Name="7-Zip"; URL="https://www.7-zip.org/a/7z1900-x64.exe" }
        @{ Name="WinRAR"; URL="https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-611.exe" }
        @{ Name="AnyDesk"; URL="https://download.anydesk.com/AnyDesk.exe" }
        @{ Name="TeamViewer"; URL="https://download.teamviewer.com/download/TeamViewer_Setup.exe" }
        @{ Name="CPU-Z"; URL="https://download.cpuid.com/cpu-z/cpu-z_2.08-en.exe" }
        @{ Name="CrystalDiskInfo"; URL="https://osdn.net/projects/crystaldiskinfo/downloads/77845/CrystalDiskInfo8_17_4.exe" }
        @{ Name="GPU-Z"; URL="https://us2-dl.techpowerup.com/files/GPU-Z.2.52.0.exe" }
        @{ Name="Revo Uninstaller"; URL="https://download.revouninstaller.com/download/revosetup.exe" }
        @{ Name="HWMonitor"; URL="https://download.cpuid.com/hwmonitor/hwmonitor_1.52.exe" }
        @{ Name="Rufus"; URL="https://github.com/pbatard/rufus/releases/download/v4.4/rufus-4.4.exe" }
        @{ Name="Everything Search"; URL="https://www.voidtools.com/Everything-1.4.1.1024.x64-Setup.exe" }
        @{ Name="Autoruns"; URL="https://download.sysinternals.com/files/Autoruns.zip" }
    )

    $y=50
    foreach ($app in $apps) {
        Add-ContentButton $app.Name $y { Start-Process $app.URL }
        $y+=40
    }
}

# ------------------------------
# ADD MENU BUTTONS
# ------------------------------
New-MenuButton "Tweaks" 50 { Show-Tweaks }
New-MenuButton "Apps" 100 { Show-Apps }
New-MenuButton "Multimedia" 150 { Show-Multimedia }
New-MenuButton "Utilities" 200 { Show-Utilities }

# ------------------------------
# SHOW FORM
# ------------------------------
[void]$Form.ShowDialog()
