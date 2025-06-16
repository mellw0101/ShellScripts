function print {
  param (
    [Parameter(Mandatory=$true)][string]$Text
  )
  Write-Host $Text -NoNewline
}

function printnl {
  param (
    [Parameter(Mandatory=$true)][string]$Text
  )
  Write-Host $Text
}

function print_color {
  param (
    [Parameter(Mandatory=$true)][string]$Text,
    [Parameter(Mandatory=$true)][string]$Color
  )
  Write-Host $Text -NoNewline -ForegroundColor $Color
}

function printnl_color {
  param (
    [Parameter(Mandatory=$true)][string]$Text,
    [Parameter(Mandatory=$true)][string]$Color
  )
  Write-Host $Text -ForegroundColor $Color
}

function prompt {
  print "["
  print_color "$PWD" Green
  printnl "]"
  print_color "|-> " "Cyan"
  return " "
}
