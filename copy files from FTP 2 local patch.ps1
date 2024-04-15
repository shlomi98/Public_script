#Shlomi98
#This script executing copy all files from FTP folder 2 local patch.ps1
# FTP server details
$ftpUrl = "ftp://yourftpserver.com/path/to/directory/"
$localPath = "C:\path\to\local\folder"
$username = "YourFTPUsername"
$password = "YourFTPPassword"

# Create a request to get the file listing
$request = [System.Net.FtpWebRequest]::Create($ftpUrl)
$request.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails
$request.Credentials = New-Object System.Net.NetworkCredential($username, $password)

$response = $request.GetResponse()

# Get the response stream
$responseStream = $response.GetResponseStream()
$reader = New-Object System.IO.StreamReader($responseStream)

# Read each line (file/directory) from the listing
$files = @()
while (-not $reader.EndOfStream) {
    $line = $reader.ReadLine()
    if (-not [string]::IsNullOrWhiteSpace($line)) {
        $files += $line.Split(" ")[-1] # Basic parsing to get the file name
    }
}

$reader.Dispose()
$response.Dispose()

# Download each file
$webClient = New-Object System.Net.WebClient
$webClient.Credentials = New-Object System.Net.NetworkCredential($username, $password)

foreach ($file in $files) {
    $localFilePath = Join-Path $localPath $file
    $fileUrl = $ftpUrl + $file

    # Download the file
    $webClient.DownloadFile($fileUrl, $localFilePath)
}

$webClient.Dispose()
