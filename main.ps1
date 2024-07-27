# Load the necessary assembly for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Hash Checker'
$form.Size = New-Object System.Drawing.Size(600,600)  # Increased form width to fit controls
$form.StartPosition = 'CenterScreen'

# Create a label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Enter the target Checksum:"
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$form.Controls.Add($label)

# Create a text box for input for Hash Algorithm
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)


# Create a button and add it to the form
$button = New-Object System.Windows.Forms.Button
$button.Text = "Open File Dialog and Compare File Dialogs"
$button.Location = New-Object System.Drawing.Point(100, 70)
$button.Size = New-Object System.Drawing.Size(100, 100)
$form.Controls.Add($button)

# Add a click event to the button
$button.Add_Click({
    # Create an instance of OpenFileDialog
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog

    # Set the properties for the dialog (optional)
    $OpenFileDialog.InitialDirectory = [Environment]::GetFolderPath('MyDocuments')
    $OpenFileDialog.Filter = "All files (*.*)|*.*"
    $OpenFileDialog.FilterIndex = 1
    $OpenFileDialog.Multiselect = $false

    # Show the dialog and check if the user selected a file
    if ($OpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        # Get the selected file path
        $selectedFilePath = $OpenFileDialog.FileName
        [System.Windows.Forms.MessageBox]::Show("Selected file: $selectedFilePath", "File Selected")
        $cert_to_verify = (certutil.exe -hashfile $selectedFilePath SHA256)[1].Trim()
        Write-Host "1 $cert_to_verify"
    } else {
        [System.Windows.Forms.MessageBox]::Show("No file selected.", "File Selection")
    }
    # Get the text from both text boxes
    $text1 = $textBox.Text.Trim()

    Write-Host $cert_to_verify
    # Compare the strings
    if ($text1 -eq $cert_to_verify) {
        [System.Windows.Forms.MessageBox]::Show("The strings are identical.", "Comparison Result")
    } else {
        [System.Windows.Forms.MessageBox]::Show("The strings are different.", "Comparison Result")
    }
    $textBox.Text = ''
})




$form.ShowDialog()