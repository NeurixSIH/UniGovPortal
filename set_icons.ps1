Add-Type -AssemblyName System.Drawing
$src = "C:\Users\Lenovo\.gemini\antigravity-ide\brain\724dacab-2d2d-4100-a4b8-ccfdc45494fd\indian_gov_emblem_1789064348537.jpg"
New-Item -ItemType Directory -Force -Path "assets\images" | Out-Null

$img = [System.Drawing.Image]::FromFile($src)
$img.Save("assets\images\gov_logo.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Saved assets\images\gov_logo.png"

$sizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

foreach ($key in $sizes.Keys) {
    $size = $sizes[$key]
    $destDir = "android\app\src\main\res\$key"
    if (Test-Path $destDir) {
        $bmp = New-Object System.Drawing.Bitmap $size, $size
        $graph = [System.Drawing.Graphics]::FromImage($bmp)
        $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graph.DrawImage($img, 0, 0, $size, $size)
        $targetFile = "$destDir\ic_launcher.png"
        if (Test-Path $targetFile) { Remove-Item $targetFile -Force }
        $bmp.Save($targetFile, [System.Drawing.Imaging.ImageFormat]::Png)
        $graph.Dispose()
        $bmp.Dispose()
        Write-Host "Updated $targetFile"
    }
}
$img.Dispose()
