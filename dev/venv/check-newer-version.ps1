# This script assumes that Python 3.10 is installed in
# C:\Program Files\Python 3.10
#
# If Python 3.10 is installed some other way, then the script will
# need some adjustment.
#

Set-Strictmode -version Latest

# Capture the file name of this powershell script
#
$scriptName_ = $MyInvocation.InvocationName

$scriptDir_ = $PSScriptRoot

# Set error code
#
$errcode_ = 0

# Pick up the verification functions
#
. "$scriptDir_\check-functions.src.ps1"

# Check that we are running in a Python 3.10 virtual environment
#
. "$scriptDir_\check-active-venv.src.ps1"
If (0 -ne $errcode_) {
  Exit
}

# Set the path to your requirements file
$requirementsFile = "$scriptDir_\requirements-venv.txt"

# Read the lines from the requirements file
$requirements = Get-Content $requirementsFile

# Loop through each line and extract package names
foreach ($line in $requirements) {
    # Use regular expressions to extract the package name
    if ($line -match '^([a-zA-Z0-9]+)') {
        $packageName = $Matches[1]

        # Construct the command
        $rcmd_ = "pip"
        $rargs_ = "install --upgrade --no-deps --dry-run $packageName"
        $command = "$rcmd_ $rargs_"

        # Run the command
        Invoke-Expression $command
    }
}