Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$config = get-content config.ini | ConvertFrom-StringData

$doomLauncher = New-Object system.Windows.Forms.Form
$doomLauncher.ClientSize = "500,320"
$doomLauncher.text = "DOOM Speedrun Launcher"
$doomLauncher.FormBorderStyle = "FixedSingle"

$WADNameLbl = New-Object System.Windows.Forms.Label
$WADNameLbl.Text = $config.wadLocation
$WADNameLbl.Width = 130
$WADNameLbl.Height = 80
$WADNameLbl.Location = New-Object System.Drawing.Point(10,40)

$crispDoomLocation = New-Object System.Windows.Forms.Label
$crispDoomLocation.Text = $config.crispyDoomLocation
$crispDoomLocation.Width = 130
$crispDoomLocation.Height = 80
$crispDoomLocation.Location = New-Object System.Drawing.Point(10,120)

$crispDoomConfigLbl = New-Object System.Windows.Forms.Label
$crispDoomConfigLbl.Text = $config.configFileLocation
$crispDoomConfigLbl.Width = 130
$crispDoomConfigLbl.Height = 80
$crispDoomConfigLbl.Location = New-Object System.Drawing.Point(10,200)

$chooseEpisodeLbl = New-Object System.Windows.Forms.Label
$chooseEpisodeLbl.Text = "Choose episode:"
$chooseEpisodeLbl.Height = 15
$chooseEpisodeLbl.Location = New-Object System.Drawing.Point(250,10)

$chooseDifficultyLbl = New-Object System.Windows.Forms.Label
$chooseDifficultyLbl.Text = "Difficulty:"
$chooseDifficultyLbl.Height = 15
$chooseDifficultyLbl.Location = New-Object System.Drawing.Point(250,60)

$chooseFastLbl = New-Object System.Windows.Forms.Label
$chooseFastLbl.Text = "Fast?"
$chooseFastLbl.Height = 15
$chooseFastLbl.Location = New-Object System.Drawing.Point(250,110)

$chooseRespawnLbl = New-Object System.Windows.Forms.Label
$chooseRespawnLbl.Text = "Respawn?"
$chooseRespawnLbl.Height = 15
$chooseRespawnLbl.Location = New-Object System.Drawing.Point(250,160)

$chooseMonstersLbl = New-Object System.Windows.Forms.Label
$chooseMonstersLbl.Text = "Nomonsters?"
$chooseMonstersLbl.Height = 15
$chooseMonstersLbl.Location = New-Object System.Drawing.Point(250,210)

$chooseRecordingLbl = New-Object System.Windows.Forms.Label
$chooseRecordingLbl.Text = "Record demo?"
$chooseRecordingLbl.Height = 15
$chooseRecordingLbl.Location = New-Object System.Drawing.Point(250,260)

$chooseEpisode = New-Object system.Windows.Forms.ComboBox
$chooseEpisode.Width = 150
$chooseEpisode.Height = 50
$chooseEpisode.Location = New-Object System.Drawing.Point(250,30)
$chooseEpisode.Items.Add("Knee Deep in the Dead") | Out-Null
$chooseEpisode.Items.Add("Shores of Hell") | Out-Null
$chooseEpisode.Items.Add("Inferno") | Out-Null
$chooseEpisode.Items.Add("The Flesh Consumed") | Out-Null
$chooseEpisode.SelectedIndex = $config.startingEpisode

$chooseDifficulty = New-Object system.Windows.Forms.ComboBox
$chooseDifficulty.Width = 150
$chooseDifficulty.Height = 50
$chooseDifficulty.Location = New-Object System.Drawing.Point(250,80)
$chooseDifficulty.Items.Add("I'm too young to die") | Out-Null
$chooseDifficulty.Items.Add("Hey, not too rough") | Out-Null
$chooseDifficulty.Items.Add("Hurt me plenty") | Out-Null
$chooseDifficulty.Items.Add("Ultra-Violence") | Out-Null
$chooseDifficulty.Items.Add("Nightmare!") | Out-Null
$chooseDifficulty.SelectedIndex = $config.difficulty

$chooseFast = New-Object system.Windows.Forms.ComboBox
$chooseFast.Width = 100
$chooseFast.Height = 50
$chooseFast.Location = New-Object System.Drawing.Point(250,130)
$chooseFast.Items.Add("No") | Out-Null
$chooseFast.Items.Add("Yes") | Out-Null
$chooseFast.SelectedIndex = $config.fast

$chooseRespawn = New-Object system.Windows.Forms.ComboBox
$chooseRespawn.Width = 100
$chooseRespawn.Height = 50
$chooseRespawn.Location = New-Object System.Drawing.Point(250,180)
$chooseRespawn.Items.Add("No") | Out-Null
$chooseRespawn.Items.Add("Yes") | Out-Null
$chooseRespawn.SelectedIndex = $config.respawn

$chooseMonsters = New-Object system.Windows.Forms.ComboBox
$chooseMonsters.Width = 100
$chooseMonsters.Height = 50
$chooseMonsters.Location = New-Object System.Drawing.Point(250,230)
$chooseMonsters.Items.Add("No") | Out-Null
$chooseMonsters.Items.Add("Yes") | Out-Null
$chooseMonsters.SelectedIndex = $config.noMonsters

$chooseRecording = New-Object system.Windows.Forms.ComboBox
$chooseRecording.Width = 100
$chooseRecording.Height = 50
$chooseRecording.Location = New-Object System.Drawing.Point(250,280)
$chooseRecording.Items.Add("No") | Out-Null
$chooseRecording.Items.Add("Yes") | Out-Null
$chooseRecording.SelectedIndex = $config.recordDemo

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
    Filter = 'Crisp Doom (*.EXE)|*.EXE'
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
    "startingEpisode = $($chooseEpisode.SelectedIndex)" >> config.ini
    "difficulty = $($chooseDifficulty.SelectedIndex)" >> config.ini
    "fast = $($chooseFast.SelectedIndex)" >> config.ini
    "respawn = $($chooseRespawn.SelectedIndex)" >> config.ini
    "noMonsters = $($chooseMonsters.SelectedIndex)" >> config.ini
    "recordDemo = $($chooseRecording.SelectedIndex)" >> config.ini
}
Function LaunchCrisp($skill, $episode, $noMonsters, $record, $fast, $respawn)
{
    $path = $crispDoomLocation.Text | Get-ChildItem
    Set-Location $path.DirectoryName | Out-Null

    $testDemosFolder = Test-Path Demos
    If ($testDemosFolder -eq $False)
    {
        New-Item -ItemType Directory -Path .\Demos
    }

    $params = "-config $($crispDoomConfigLbl.Text) -IWAD $($WADNameLbl.Text) -skill $($skill + 1) -longtics -episode $($episode + 1)"

    If ($noMonsters -eq 1)
    {
        $params += " -nomonsters"
    }

    If ($fast -eq 1)
    {
        $params += " -fast"
    }

    If ($respawn -eq 1)
    {
        $params += " -respawn"
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
    LaunchCrisp -skill $chooseDifficulty.SelectedIndex -episode $chooseEpisode.SelectedIndex -noMonsters $chooseMonsters.SelectedIndex `
    -record $chooseRecording.SelectedIndex -fast $chooseFast.SelectedIndex -respawn $chooseRespawn.SelectedIndex
}

Function PlayDemo($demoPath)
{
    $path = $crispDoomLocation.Text | Get-ChildItem
    Set-Location $path.DirectoryName | Out-Null

    $params = "-IWAD $($WADNameLbl.Text) -playdemo $($demoPath)"

    Start-Process -FilePath $crispDoomLocation.Text -ArgumentList $params
}

$handler_playDemoBtn =
{
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
        Filter = 'Doom demos (*.lmp)|*.lmp'
    }
    $FileBrowser.ShowDialog()

    PlayDemo -demoPath $FileBrowser.FileNames
}

$chooseWADBtn = New-Object system.Windows.Forms.Button
$chooseWADBtn.Text = "Doom 1 WAD"
$chooseWADBtn.Width = 100
$chooseWADBtn.Height = 50
$chooseWADBtn.Location = New-Object System.Drawing.Point(140,30)
$chooseWADBtn.Visible = $True
$chooseWADBtn.add_Click($handler_chooseWADbtn)

$crispDoomLocationBtn = New-Object system.Windows.Forms.Button
$crispDoomLocationBtn.Text = "crispy-doom.exe"
$crispDoomLocationBtn.Width = 100
$crispDoomLocationBtn.Height = 50
$crispDoomLocationBtn.Location = New-Object System.Drawing.Point(140,110)
$crispDoomLocationBtn.Visible = $True
$crispDoomLocationBtn.add_Click($handler_chooseCrispLocation)

$crispDoomConfigBtn = New-Object system.Windows.Forms.Button
$crispDoomConfigBtn.Text = "Config file"
$crispDoomConfigBtn.Width = 100
$crispDoomConfigBtn.Height = 50
$crispDoomConfigBtn.Location = New-Object System.Drawing.Point(140,190)
$crispDoomConfigBtn.Visible = $True
$crispDoomConfigBtn.add_Click($handler_chooseCrispConfig)

$launchCrispDoomBtn = New-Object system.Windows.Forms.Button
$launchCrispDoomBtn.Text = "Launch CRISP Doom"
$launchCrispDoomBtn.Width = 100
$launchCrispDoomBtn.Height = 50
$launchCrispDoomBtn.Location = New-Object System.Drawing.Point(375,120)
$launchCrispDoomBtn.Visible = $True
$launchCrispDoomBtn.add_Click($handler_launchCrispDoom)

$updateConfigBtn = New-Object system.Windows.Forms.Button
$updateConfigBtn.Text = "Save launcher's config"
$updateConfigBtn.Width = 100
$updateConfigBtn.Height = 50
$updateConfigBtn.Location = New-Object System.Drawing.Point(375,170)
$updateConfigBtn.Visible = $True
$updateConfigBtn.add_Click($handler_updateConfigBtn)

$playDemoBtn = New-Object system.Windows.Forms.Button
$playDemoBtn.Text = "Play demo"
$playDemoBtn.Width = 100
$playDemoBtn.Height = 50
$playDemoBtn.Location = New-Object System.Drawing.Point(375,220)
$playDemoBtn.Visible = $True
$playDemoBtn.add_Click($handler_playDemoBtn)

$doomLauncher.Controls.Add($WADNameLbl)
$doomLauncher.Controls.Add($chooseEpisodeLbl)
$doomLauncher.Controls.Add($chooseDifficultyLbl)
$doomLauncher.Controls.Add($chooseFastLbl)
$doomLauncher.Controls.Add($chooseRespawnLbl)
$doomLauncher.Controls.Add($chooseMonstersLbl)
$doomLauncher.Controls.Add($chooseRecordingLbl)
$doomLauncher.Controls.Add($crispDoomConfigLbl)
$doomLauncher.Controls.Add($chooseEpisode)
$doomLauncher.Controls.Add($chooseDifficulty)
$doomLauncher.Controls.Add($chooseFast)
$doomLauncher.Controls.Add($chooseRespawn)
$doomLauncher.Controls.Add($chooseMonsters)
$doomLauncher.Controls.Add($chooseRecording)
$doomLauncher.Controls.Add($crispDoomLocation)
$doomLauncher.Controls.Add($crispDoomLocationBtn)
$doomLauncher.Controls.Add($crispDoomConfigBtn)
$doomLauncher.Controls.Add($chooseWADBtn)
$doomLauncher.Controls.Add($launchCrispDoomBtn)
$doomLauncher.Controls.Add($updateConfigBtn)
$doomLauncher.Controls.Add($playDemoBtn)
$doomLauncher.ShowDialog()