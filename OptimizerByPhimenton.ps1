# ---------------------------------------------------------
# COMPLETE PC OPTIMIZER - MODERN GUI
# Created by Phimenton
# ---------------------------------------------------------
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Drawing.Drawing2D

# Fuente moderna
$fontMain = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Regular)

# Formulario principal
$form = New-Object System.Windows.Forms.Form
$form.Text = "Complete PC Optimizer"
$form.Size = [System.Drawing.Size]::new(700,500)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Gradiente de fondo
$form.Paint.Add({
    $g = $_.Graphics
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush `
        ($form.DisplayRectangle, [System.Drawing.Color]::FromArgb(30,30,30), [System.Drawing.Color]::FromArgb(0,122,204), 90)
    $g.FillRectangle($brush, $form.DisplayRectangle)
    $brush.Dispose()
})

# Función para crear botones redondeados
Function New-RoundedButton {
    param($Text, $Size, $Location, $Action)
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $Text
    $btn.Size = $Size
    $btn.Location = $Location
    $btn.FlatStyle = "Flat"
    $btn.Font = $fontMain
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.BackColor = [System.Drawing.Color]::FromArgb(0,122,204)
    # Bordes redondeados
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc(0,0,20,20,180,90)
    $path.AddArc($btn.Width-20,0,20,20,270,90)
    $path.AddArc($btn.Width-20,$btn.Height-20,20,20,0,90)
    $path.AddArc(0,$btn.Height-20,20,20,90,90)
    $path.CloseFigure()
    $btn.Region = New-Object System.Drawing.Region($path)
    $btn.Add_Click($Action)
    return $btn
}

# TabControl
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = [System.Drawing.Size]::new(680,430)
$tabControl.Location = [System.Drawing.Point]::new(10,10)
$tabControl.Font = $fontMain

# =======================
# TAB TWEAKS
# =======================
$tabTweaks = New-Object System.Windows.Forms.TabPage
$tabTweaks.Text = "Tweaks"
$tabTweaks.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)

# Ejemplo de botón Tweaks
$btnServices = New-RoundedButton "Disable Services" ([System.Drawing.Size]::new(300,35)) ([System.Drawing.Point]::new(20,20)) {
    Start-Process powershell -Verb RunAs -ArgumentList {
        sc config "DiagTrack" start= disabled
        sc stop "DiagTrack"
        sc config "SysMain" start= disabled
        sc stop "SysMain"
        [System.Windows.Forms.MessageBox]::Show("Services disabled successfully.")
    }
}
$tabTweaks.Controls.Add($btnServices)

# Agregar más botones Tweaks aquí: Registry, Telemetry, Cortana, Restore Point, SFC, Bloatware
# Por ejemplo: Optimize Registry
$btnRegistry = New-RoundedButton "Optimize Registry" ([System.Drawing.Size]::new(300,35)) ([System.Drawing.Point]::new(20,70)) {
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Value "2000"
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -Value "2000"
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Value "1"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
    [System.Windows.Forms.MessageBox]::Show("Registry optimized.")
}
$tabTweaks.Controls.Add($btnRegistry)

# =======================
# TAB APPS
# =======================
$tabApps = New-Object System.Windows.Forms.TabPage
$tabApps.Text = "Apps"
$tabApps.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)

$apps = @(
    @{Name="Google Chrome";URL="https://dl.google.com/chrome/install/latest/chrome_installer.exe"},
    @{Name="Brave Browser";URL="https://laptop-updates.brave.com/latest/winx64"},
    @{Name="Discord";URL="https://discord.com/api/download?platform=win"},
    @{Name="Telegram";URL="https://telegram.org/dl/desktop/win"}
)

$yPos=20
foreach ($app in $apps) {
    $btn = New-RoundedButton ("Install " + $app.Name) ([System.Drawing.Size]::new(200,35)) ([System.Drawing.Point]::new(20,$yPos)) {
        $tempPath = "$env:TEMP\$($app.Name).exe"
        Invoke-WebRequest -Uri $app.URL -OutFile $tempPath
        Start-Process $tempPath -Wait
        Remove-Item $tempPath
        [System.Windows.Forms.MessageBox]::Show("$($app.Name) installed successfully.")
    })
    $tabApps.Controls.Add($btn)
    $yPos += 45
}

# =======================
# TAB MULTIMEDIA
# =======================
$tabMedia = New-Object System.Windows.Forms.TabPage
$tabMedia.Text = "Multimedia"
$tabMedia.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)

$mediaApps = @(
    @{Name="Spotify";URL="https://download.scdn.co/SpotifySetup.exe"},
    @{Name="VLC Media Player";URL="https://get.videolan.org/vlc/last/win64/vlc-3.0.18-win64.exe"},
    @{Name="OBS Studio";URL="https://cdn-fastly.obsproject.com/downloads/OBS-Studio-29.1.3-Full-Installer-x64.exe"}
)

$yPos=20
foreach ($mApp in $mediaApps) {
    $btn = New-RoundedButton ("Install " + $mApp.Name) ([System.Drawing.Size]::new(200,35)) ([System.Drawing.Point]::new(20,$yPos)) {
        $tempPath = "$env:TEMP\$($mApp.Name).exe"
        Invoke-WebRequest -Uri $mApp.URL -OutFile $tempPath
        Start-Process $tempPath -Wait
        Remove-Item $tempPath
        [System.Windows.Forms.MessageBox]::Show("$($mApp.Name) installed successfully.")
    })
    $tabMedia.Controls.Add($btn)
    $yPos += 45
}

# =======================
# TAB UTILITIES
# =======================
$tabUtils = New-Object System.Windows.Forms.TabPage
$tabUtils.Text = "Utilities"
$tabUtils.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)

$utilities = @(
    @{Name="AnyDesk";URL="https://download.anydesk.com/AnyDesk.exe"},
    @{Name="TeamViewer";URL="https://download.teamviewer.com/download/TeamViewer_Setup.exe"},
    @{Name="7-Zip";URL="https://www.7-zip.org/a/7z2301-x64.exe"},
    @{Name="WinRAR";URL="https://www.rarlab.com/rar/win/rarx64.exe"},
    @{Name="CPU-Z";URL="https://www.cpuid.com/downloads/cpu-z/cpu-z_2.09-en.exe"},
    @{Name="CrystalDiskInfo";URL="https://crystalmark.info/download/index-e.php?file=CrystalDiskInfo8_12_0.exe"},
    @{Name="GPU-Z";URL="https://www.techpowerup.com/download/techpowerup-gpu-z/"},
    @{Name="Revo Uninstaller";URL="https://www.revouninstaller.com/revo_uninstaller_free_download.html"}
)

$yPos=20
foreach ($uApp in $utilities) {
    $btn = New-RoundedButton ("Install " + $uApp.Name) ([System.Drawing.Size]::new(200,35)) ([System.Drawing.Point]::new(20,$yPos)) {
        $tempPath = "$env:TEMP\$($uApp.Name).exe"
        Invoke-WebRequest -Uri $uApp.URL -OutFile $tempPath
        Start-Process $tempPath -Wait
        Remove-Item $tempPath
        [System.Windows.Forms.MessageBox]::Show("$($uApp.Name) installed successfully.")
    })
    $tabUtils.Controls.Add($btn)
    $yPos += 45
}

# =======================
# Añadir Tabs al TabControl
$tabControl.TabPages.AddRange(@($tabTweaks,$tabApps,$tabMedia,$tabUtils))
$form.Controls.Add($tabControl)

# Label de autor
$lblAuthor = New-Object System.Windows.Forms.Label
$lblAuthor.Text = "Created by Phimenton"
$lblAuthor.ForeColor = [System.Drawing.Color]::FromArgb(0,255,128)
$lblAuthor.Font = $fontMain
$lblAuthor.Size = [System.Drawing.Size]::new(200,20)
$lblAuthor.Location = [System.Drawing.Point]::new(480,445)
$form.Controls.Add($lblAuthor)

$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
