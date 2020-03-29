Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$config = get-content config.ini | ConvertFrom-StringData

$doomLauncher = New-Object system.Windows.Forms.Form
$doomLauncher.ClientSize = "500,300"
$doomLauncher.text = "DOOM UV Speedrun Launcher"
$doomLauncher.BackColor = "#FFFFFF"
$doomLauncher.FormBorderStyle = "FixedSingle"

$WADNameLbl = New-Object System.Windows.Forms.Label
$WADNameLbl.Text = $config.wadLocation
$WADNameLbl.Width = 130
$WADNameLbl.Height = 80
$WADNameLbl.Location = New-Object System.Drawing.Point(20,40)

$crispDoomLocation = New-Object System.Windows.Forms.Label
$crispDoomLocation.Text = $config.crispyDoomLocation
$crispDoomLocation.Width = 130
$crispDoomLocation.Height = 80
$crispDoomLocation.Location = New-Object System.Drawing.Point(20,120)

$crispDoomConfigLbl = New-Object System.Windows.Forms.Label
$crispDoomConfigLbl.Text = $config.configFileLocation
$crispDoomConfigLbl.Width = 130
$crispDoomConfigLbl.Height = 80
$crispDoomConfigLbl.Location = New-Object System.Drawing.Point(20,190)

$chooseEpisodeLbl = New-Object System.Windows.Forms.Label
$chooseEpisodeLbl.Text = "Choose episode:"
$chooseEpisodeLbl.Location = New-Object System.Drawing.Point(250,30)

$chooseMonstersLbl = New-Object System.Windows.Forms.Label
$chooseMonstersLbl.Text = "Nomonsters?"
$chooseMonstersLbl.Location = New-Object System.Drawing.Point(250,110)

$chooseRecordingLbl = New-Object System.Windows.Forms.Label
$chooseRecordingLbl.Text = "Record demo?"
$chooseRecordingLbl.Location = New-Object System.Drawing.Point(250,190)

$chooseEpisode = New-Object system.Windows.Forms.ComboBox
$chooseEpisode.Width = 150
$chooseEpisode.Height = 50
$chooseEpisode.Location = New-Object System.Drawing.Point(250,55)
$chooseEpisode.Items.Add("Doom1") | Out-Null
$chooseEpisode.Items.Add("Knee Deep in the Dead") | Out-Null
$chooseEpisode.Items.Add("Shores of Hell") | Out-Null
$chooseEpisode.Items.Add("Inferno") | Out-Null
$chooseEpisode.Items.Add("The Flesh Consumed") | Out-Null
$chooseEpisode.SelectedIndex = 1

$chooseMonsters = New-Object system.Windows.Forms.ComboBox
$chooseMonsters.Width = 100
$chooseMonsters.Height = 50
$chooseMonsters.Location = New-Object System.Drawing.Point(250,135)
$chooseMonsters.Items.Add("False") | Out-Null
$chooseMonsters.Items.Add("True") | Out-Null
$chooseMonsters.SelectedIndex = 0

$chooseRecording = New-Object system.Windows.Forms.ComboBox
$chooseRecording.Width = 100
$chooseRecording.Height = 50
$chooseRecording.Location = New-Object System.Drawing.Point(250,215)
$chooseRecording.Items.Add("False") | Out-Null
$chooseRecording.Items.Add("True") | Out-Null
$chooseRecording.SelectedIndex = 0

$handler_chooseWADbtn = 
{
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    Filter = 'Doom WAD (*.WAD)|*.WAD'
    }
    $FileBrowser.ShowDialog()

    $WADNameLbl.Text = $FileBrowser.FileNames
}

$handler_chooseCrispLocation =
{
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    Filter = 'Chocolate Doom (*.EXE)|*.EXE'
    }
    $FileBrowser.ShowDialog()

    $crispDoomLocation.Text = $FileBrowser.FileNames
}

$handler_chooseCrispConfig =
{
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    Filter = 'Config File (*.CFG)|*.CFG'
    }
    $FileBrowser.ShowDialog()

    $crispDoomConfigLbl.Text = $FileBrowser.FileNames
}

$handler_updateConfigBtn =
{
    Clear-content config.ini

    "wadLocation = $($WADNameLbl.Text.Replace("\", "\\"))" >> config.ini
    "crispyDoomLocation = $($crispDoomLocation.Text.Replace("\", "\\"))" >> config.ini
    "configFileLocation = $($crispDoomConfigLbl.Text.Replace("\", "\\"))" >> config.ini
}
Function LaunchCrisp($episode, $noMonsters, $record)
{
    $path = $crispDoomLocation.Text | Get-ChildItem
    Set-Location $path.DirectoryName | Out-Null

    $params = "-config $($crispDoomConfigLbl.Text) -IWAD $($WADNameLbl.Text) -skill 4 -longtics -episode $($episode)"

    If ($noMonsters -eq 1)
    {
        $params += " -nomonsters"
    }

    If ($record -eq 1)
    {
        $date = get-date
        $filename = "Demos/" + $date.Day.ToString() + $date.Month.ToString() + $date.Year.ToString() + $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString()
        $params += " -record $($filename)"
    }
    Start-Process -FilePath $crispDoomLocation.Text -ArgumentList $params
}

$handler_launchCrispDoom =
{
    LaunchCrisp -episode $chooseEpisode.SelectedIndex -noMonsters $chooseMonsters.SelectedIndex -record $chooseRecording.SelectedIndex
}

$chooseWADBtn = New-Object system.Windows.Forms.Button
$chooseWADBtn.Text = "Choose Doom 1 WAD location"
$chooseWADBtn.Width = 100
$chooseWADBtn.Height = 50
$chooseWADBtn.Location = New-Object System.Drawing.Point(150,30)
$chooseWADBtn.Visible = $True
$chooseWADBtn.add_Click($handler_chooseWADbtn)

$crispDoomLocationBtn = New-Object system.Windows.Forms.Button
$crispDoomLocationBtn.Text = "Location of crispy-doom.exe"
$crispDoomLocationBtn.Width = 100
$crispDoomLocationBtn.Height = 50
$crispDoomLocationBtn.Location = New-Object System.Drawing.Point(150,110)
$crispDoomLocationBtn.Visible = $True
$crispDoomLocationBtn.add_Click($handler_chooseCrispLocation)

$crispDoomConfigBtn = New-Object system.Windows.Forms.Button
$crispDoomConfigBtn.Text = "Config file location"
$crispDoomConfigBtn.Width = 100
$crispDoomConfigBtn.Height = 50
$crispDoomConfigBtn.Location = New-Object System.Drawing.Point(150,180)
$crispDoomConfigBtn.Visible = $True
$crispDoomConfigBtn.add_Click($handler_chooseCrispConfig)

$launchCrispDoomBtn = New-Object system.Windows.Forms.Button
$launchCrispDoomBtn.Text = "Launch CRISP Doom"
$launchCrispDoomBtn.Width = 100
$launchCrispDoomBtn.Height = 50
$launchCrispDoomBtn.Location = New-Object System.Drawing.Point(375,110)
$launchCrispDoomBtn.Visible = $True
$launchCrispDoomBtn.add_Click($handler_launchCrispDoom)

$updateConfigBtn = New-Object system.Windows.Forms.Button
$updateConfigBtn.Text = "Update config.ini"
$updateConfigBtn.Width = 100
$updateConfigBtn.Height = 50
$updateConfigBtn.Location = New-Object System.Drawing.Point(375,180)
$updateConfigBtn.Visible = $True
$updateConfigBtn.add_Click($handler_updateConfigBtn)

$doomLauncher.Controls.Add($WADNameLbl)
$doomLauncher.Controls.Add($chooseEpisodeLbl)
$doomLauncher.Controls.Add($chooseMonstersLbl)
$doomLauncher.Controls.Add($chooseRecordingLbl)
$doomLauncher.Controls.Add($crispDoomConfigLbl)
$doomLauncher.Controls.Add($chooseEpisode)
$doomLauncher.Controls.Add($chooseMonsters)
$doomLauncher.Controls.Add($chooseRecording)
$doomLauncher.Controls.Add($crispDoomLocation)
$doomLauncher.Controls.Add($crispDoomLocationBtn)
$doomLauncher.Controls.Add($crispDoomConfigBtn)
$doomLauncher.Controls.Add($chooseWADBtn)
$doomLauncher.Controls.Add($launchCrispDoomBtn)
$doomLauncher.Controls.Add($updateConfigBtn)
$doomLauncher.ShowDialog()