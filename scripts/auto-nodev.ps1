# Name: auto-nodev
# Version: 1.0.0
# Author: AnsChaser
# Email: anschaser.163.com

function escape_path {
    param ([string]$path)
    $path_escaped = ""
    foreach ($pathpart in ($path -split "(%.*?%)")) {
        if ($pathpart[0] -eq "%" -and $pathpart[$pathpart.length-1] -eq "%") {
            $pathpart = [Environment]::GetEnvironmentVariable($pathpart.replace("%",""))
        }
        $path_escaped += $pathpart
    }
    return $path_escaped
}

function set_local_nodever {
    param ([string]$required_nodedir)
    $newpaths = @($required_nodedir)
    foreach ($path in $env:PATH.split(";")) {
        $path_escaped = escape_path($path)
        if (-not (test-path -path "$path_escaped\node.exe" -pathtype leaf) `
            -and -not (test-path -path "$path\node.exe" -pathtype leaf)
        ){ $newpaths += $path }
    }
    $env:PATH = $newpaths -join ";"
}

$workdir = if (
    [Environment]::CommandLine -match `
    '\b(set-location|cd|chdir\sl)\s+(-(literalpath|lp|path|PSPath)\s+)?(?<path>(?:\\").+?(?:\\")|"""[^"]+|''[^'']+|[^ ]+)'
) {
    $Matches.path -replace '^(\\"|"""|'')' -replace '\\"$'
} else {
    $PWD.ProviderPath
}
$local_nodever_fname = "$workdir\.node-version"
if (test-path -path $local_nodever_fname -pathType leaf) {
    $local_nodever = (get-content $local_nodever_fname).trim()
    $usr_nodes_root = $env:AUTO_NODEV_NODES_ROOT
    $nvm_nodes_root = (invoke-expression "nvm root").split("`n")[-1].split(":", 2)[-1].trim()
    $nodes_root = if ($usr_nodes_root) {$usr_nodes_root} else {$nvm_nodes_root}
    $required_nodedir = "$nodes_root\$local_nodever"
    if (test-path -path $required_nodedir) {
        set_local_nodever($required_nodedir)
        write-host "auto-nodev: local node version is $local_nodever now." -foregroundColor:green
    } else {
        write-host "auto-nodev: required node version $local_nodever not found." -foregroundColor:red
        write-host "auto-nodev: using global node version now." -foregroundColor:yellow
    }
}
