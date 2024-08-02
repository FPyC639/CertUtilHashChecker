# Load the necessary assembly for Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Hash Checker'
$form.Size = New-Object System.Drawing.Size(600, 200)  # Adjusted form height to fit controls
$form.StartPosition = 'CenterScreen'

# Create a label for target checksum
$label = New-Object System.Windows.Forms.Label
$label.Text = "Enter the target Checksum:"
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($label)

# Create a text box for input for target checksum
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(220, 20)
$textBox.Size = New-Object System.Drawing.Size(260, 20)
$form.Controls.Add($textBox)

# Create a label for hashing algorithm
$label2 = New-Object System.Windows.Forms.Label
$label2.Text = "Select Hashing Algorithm:"
$label2.Location = New-Object System.Drawing.Point(10, 60)
$label2.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($label2)

# Create a ComboBox for hashing algorithm selection
$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point(220, 60)
$comboBox.Size = New-Object System.Drawing.Size(200, 20)
$comboBox.Items.AddRange(@("SHA256", "MD5", "SHA1", "MD4"))
$form.Controls.Add($comboBox)

# Create a button and add it to the form
$button = New-Object System.Windows.Forms.Button
$button.Text = "Open File Dialog and Compare File Hash"
$button.Location = New-Object System.Drawing.Point(180, 100)
$button.Size = New-Object System.Drawing.Size(260, 60)
$form.Controls.Add($button)

# Add a click event to the button
$button.Add_Click({
    # Create an instance of OpenFileDialog
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog

    # Set the properties for the dialog (optional)
    $OpenFileDialog.InitialDirectory = "C:\Working\"
    $OpenFileDialog.Filter = "All files (*.*)|*.*"
    $OpenFileDialog.FilterIndex = 1
    $OpenFileDialog.Multiselect = $false

    # Show the dialog and check if the user selected a file
    if ($OpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        # Get the selected file path
        $selectedFilePath = $OpenFileDialog.FileName
        [System.Windows.Forms.MessageBox]::Show("Selected file: $selectedFilePath", "File Selected")
        $cert_to_verify = (certutil.exe -hashfile $selectedFilePath $comboBox.SelectedItem)[1].Trim()
        Write-Host "1 $cert_to_verify"
    } else {
        [System.Windows.Forms.MessageBox]::Show("No file selected.", "File Selection")
    }
    
    # Get the text from the text box
    $text1 = $textBox.Text.Trim()

    # Compare the strings
    if ($text1 -eq $cert_to_verify) {
        [System.Windows.Forms.MessageBox]::Show("The strings are identical.", "Comparison Result")
    } else {
        [System.Windows.Forms.MessageBox]::Show("The strings are different.", "Comparison Result")
    }
    $textBox.Text = ''
})

[void]$form.ShowDialog()
