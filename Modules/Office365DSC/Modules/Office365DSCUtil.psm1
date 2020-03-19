
#region Session Objects
$Global:SessionSecurityCompliance = $null
#endregion

$Locales = @(
    @{
        EnglishName = "Arabic (Algeria)"
        ID          = "5121"
    },
    @{
        EnglishName = "Arabic (Bahrain)"
        ID          = "15361"
    },
    @{
        EnglishName = "Arabic (Egypt)"
        ID          = "3073"
    },
    @{
        EnglishName = "Arabic (Iraq)"
        ID          = "2049"
    },
    @{
        EnglishName = "Arabic (Jordan)"
        ID          = "11265"
    },
    @{
        EnglishName = "Arabic (Kuwait)"
        ID          = "13313"
    },
    @{
        EnglishName = "Arabic (Lebanon)"
        ID          = "12289"
    },
    @{
        EnglishName = "Arabic (Libya)"
        ID          = "4097"
    },
    @{
        EnglishName = "Arabic (Morocco)"
        ID          = "6145"
    },
    @{
        EnglishName = "Arabic (Oman)"
        ID          = "8193"
    },
    @{
        EnglishName = "Arabic (Qatar)"
        ID          = "16385"
    },
    @{
        EnglishName = "Arabic (Saudi Arabia)"
        ID          = "1025"
    },
    @{
        EnglishName = "Arabic (Syria)"
        ID          = "10241"
    },
    @{
        EnglishName = "Arabic (Tunisia)"
        ID          = "7169"
    },
    @{
        EnglishName = "Arabic (U.A.E.)"
        ID          = "14337"
    },
    @{
        EnglishName = "Arabic (Yemen)"
        ID          = "9217"
    },
    @{
        EnglishName = "Basque"
        ID          = "1069"
    },
    @{
        EnglishName = "Bulgarian"
        ID          = "1026"
    },
    @{
        EnglishName = "Catalan"
        ID          = "1027"
    },
    @{
        EnglishName = "Chinese (Hong Kong S.A.R)"
        ID          = "3076"
    },
    @{
        EnglishName = "Chinese (Macau S.A.R)"
        ID          = "5124"
    },
    @{
        EnglishName = "Chinese (People's Republic of China)"
        ID          = "2052"
    },
    @{
        EnglishName = "Chinese (Singapore)"
        ID          = "4100"
    },
    @{
        EnglishName = "Chinese (Taiwan)"
        ID          = "1028"
    },
    @{
        EnglishName = "Croatian"
        ID          = "1050"
    },
    @{
        EnglishName = "Czech"
        ID          = "1029"
    },
    @{
        EnglishName = "Danish"
        ID          = "1030"
    },
    @{
        EnglishName = "Dutch (Belgium)"
        ID          = "2067"
    },
    @{
        EnglishName = "Dutch (Netherlands)"
        ID          = "1043"
    },
    @{
        EnglishName = "English (Australia)"
        ID          = "3081"
    },
    @{
        EnglishName = "English (Belize)"
        ID          = "10249"
    },
    @{
        EnglishName = "English (Canada)"
        ID          = "4105"
    },
    @{
        EnglishName = "English (Caribbean)"
        ID          = "9225"
    },
    @{
        EnglishName = "English (Ireland)"
        ID          = "6153"
    },
    @{
        EnglishName = "English (Jamaica)"
        ID          = "8201"
    },
    @{
        EnglishName = "English (New Zealand)"
        ID          = "5129"
    },
    @{
        EnglishName = "English (Republic of the Philippines)"
        ID          = "13321"
    },
    @{
        EnglishName = "English (South Africa)"
        ID          = "7177"
    },
    @{
        EnglishName = "English (Trinidad)"
        ID          = "11273"
    },
    @{
        EnglishName = "English (United Kingdom)"
        ID          = "2057"
    },
    @{
        EnglishName = "English (United States)"
        ID          = "1033"
    },
    @{
        EnglishName = "English (Zimbabwe)"
        ID          = "12297"
    },
    @{
        EnglishName = "Estonian"
        ID          = "1061"
    },
    @{
        EnglishName = "Filipino (Philippines)"
        ID          = "1124"
    },
    @{
        EnglishName = "Finnish"
        ID          = "1035"
    },
    @{
        EnglishName = "French (Belgium)"
        ID          = "2060"
    },
    @{
        EnglishName = "French (Canada)"
        ID          = "3084"
    },
    @{
        EnglishName = "French (France)"
        ID          = "1036"
    },
    @{
        EnglishName = "French (Luxembourg)"
        ID          = "5132"
    },
    @{
        EnglishName = "French (Principality of Monaco)"
        ID          = "6156"
    },
    @{
        EnglishName = "French (Switzerland)"
        ID          = "4108"
    },
    @{
        EnglishName = "German (Austria)"
        ID          = "3079"
    },
    @{
        EnglishName = "German (Germany)"
        ID          = "1031"
    },
    @{
        EnglishName = "German (Liechtenstein)"
        ID          = "5127"
    },
    @{
        EnglishName = "German (Luxembourg)"
        ID          = "4103"
    },
    @{
        EnglishName = "German (Switzerland)"
        ID          = "2055"
    },
    @{
        EnglishName = "Greek"
        ID          = "1032"
    },
    @{
        EnglishName = "Hebrew"
        ID          = "1037"
    },
    @{
        EnglishName = "Hindi"
        ID          = "1081"
    },
    @{
        EnglishName = "Hungarian"
        ID          = "1038"
    },
    @{
        EnglishName = "Icelandic"
        ID          = "1039"
    },
    @{
        EnglishName = "Indonesian"
        ID          = "1057"
    },
    @{
        EnglishName = "Italian (Italy)"
        ID          = "1040"
    },
    @{
        EnglishName = "Italian (Switzerland)"
        ID          = "2064"
    },
    @{
        EnglishName = "Japanese"
        ID          = "1041"
    },
    @{
        EnglishName = "Kazakh"
        ID          = "1087"
    },
    @{
        EnglishName = "Korean"
        ID          = "1042"
    },
    @{
        EnglishName = "Latvian"
        ID          = "1062"
    },
    @{
        EnglishName = "Lithuanian"
        ID          = "1063"
    },
    @{
        EnglishName = "Malay"
        ID          = "1086"
    },
    @{
        EnglishName = "Norwegian (Bokmal)"
        ID          = "1044"
    },
    @{
        EnglishName = "Persian"
        ID          = "1065"
    },
    @{
        EnglishName = "Polish"
        ID          = "1045"
    },
    @{
        EnglishName = "Portuguese (Brazil)"
        ID          = "1046"
    },
    @{
        EnglishName = "Portuguese (Portugal)"
        ID          = "2070"
    },
    @{
        EnglishName = "Romanian"
        ID          = "1048"
    },
    @{
        EnglishName = "Russian"
        ID          = "1049"
    },
    @{
        EnglishName = "Serbian (Cyrillic)"
        ID          = "3098"
    },
    @{
        EnglishName = "Serbian (Latin)"
        ID          = "2074"
    },
    @{
        EnglishName = "Slovak"
        ID          = "1051"
    },
    @{
        EnglishName = "Slovenian"
        ID          = "1060"
    },
    @{
        EnglishName = "Spanish (Argentina)"
        ID          = "11274"
    },
    @{
        EnglishName = "Spanish (Bolivia)"
        ID          = "16394"
    },
    @{
        EnglishName = "Spanish (Chile)"
        ID          = "13322"
    },
    @{
        EnglishName = "Spanish (Colombia)"
        ID          = "9226"
    },
    @{
        EnglishName = "Spanish (Costa Rica)"
        ID          = "5130"
    },
    @{
        EnglishName = "Spanish (Dominican Republic)"
        ID          = "7178"
    },
    @{
        EnglishName = "Spanish (Ecuador)"
        ID          = "12298"
    },
    @{
        EnglishName = "Spanish (El Salvador)"
        ID          = "17418"
    },
    @{
        EnglishName = "Spanish (Guatemala)"
        ID          = "4106"
    },
    @{
        EnglishName = "Spanish (Honduras)"
        ID          = "18442"
    },
    @{
        EnglishName = "Spanish (Mexico)"
        ID          = "2058"
    },
    @{
        EnglishName = "Spanish (Nicaragua)"
        ID          = "19466"
    },
    @{
        EnglishName = "Spanish (Panama)"
        ID          = "6154"
    },
    @{
        EnglishName = "Spanish (Paraguay)"
        ID          = "15370"
    },
    @{
        EnglishName = "Spanish (Peru)"
        ID          = "10250"
    },
    @{
        EnglishName = "Spanish (Puerto Rico)"
        ID          = "20490"
    },
    @{
        EnglishName = "Spanish (International Sort)"
        ID          = "3082"
    },
    @{
        EnglishName = "Spanish (Traditional Sort)"
        ID          = "1034"
    },
    @{
        EnglishName = "Spanish (Uruguay)"
        ID          = "14346"
    },
    @{
        EnglishName = "Spanish (Venezuela)"
        ID          = "8202"
    },
    @{
        EnglishName = "Swedish (Finland)"
        ID          = "2077"
    },
    @{
        EnglishName = "Swedish (Sweden)"
        ID          = "1053"
    },
    @{
        EnglishName = "Thai"
        ID          = "1054"
    },
    @{
        EnglishName = "Turkish"
        ID          = "1055"
    },
    @{
        EnglishName = "Ukrainian"
        ID          = "1058"
    },
    @{
        EnglishName = "Urdu"
        ID          = "1056"
    },
    @{
        EnglishName = "Vietnamese"
        ID          = "1066"
    }
)

$TimeZones = @(
    @{
        ID                 = "000"
        EnglishName        = "Dateline Standard Time"
        EnglishDescription = "(GMT-12:00) International Date Line West"
    },
    @{
        ID                 = "001"
        EnglishName        = "Samoa Standard Time"
        EnglishDescription = "(GMT-11:00) Midway Island, Samoa"
    },
    @{
        ID                 = "002"
        EnglishName        = "Hawaiian Standard Time"
        EnglishDescription = "(GMT-10:00) Hawaii"
    },
    @{
        ID                 = "003"
        EnglishName        = "Alaskan Standard Time"
        EnglishDescription = "(GMT-09:00) Alaska"
    },
    @{
        ID                 = "004"
        EnglishName        = "Pacific Standard Time"
        EnglishDescription = "(GMT-08:00) Pacific Time (US and Canada); Tijuana"
    },
    @{
        ID                 = "010"
        EnglishName        = "Mountain Standard Time"
        EnglishDescription = "(GMT-07:00) Mountain Time (US and Canada)"
    },
    @{
        ID                 = "013"
        EnglishName        = "Mexico Standard Time 2"
        EnglishDescription = "(GMT-07:00) Chihuahua, La Paz, Mazatlan"
    },
    @{
        ID                 = "015"
        EnglishName        = "U.S. Mountain Standard Time"
        EnglishDescription = "(GMT-07:00) Arizona"
    },
    @{
        ID                 = "020"
        EnglishName        = "Central Standard Time"
        EnglishDescription = "(GMT-06:00) Central Time (US and Canada"
    },
    @{
        ID                 = "025"
        EnglishName        = "Canada Central Standard Time"
        EnglishDescription = "(GMT-06:00) Saskatchewan"
    },
    @{
        ID                 = "030"
        EnglishName        = "Mexico Standard Time"
        EnglishDescription = "(GMT-06:00) Guadalajara, Mexico City, Monterrey"
    },
    @{
        ID                 = "033"
        EnglishName        = "Central America Standard Time"
        EnglishDescription = "(GMT-06:00) Central America"
    },
    @{
        ID                 = "035"
        EnglishName        = "Eastern Standard Time"
        EnglishDescription = "(GMT-05:00) Eastern Time (US and Canada)"
    },
    @{
        ID                 = "040"
        EnglishName        = "U.S. Eastern Standard Time"
        EnglishDescription = "(GMT-05:00) Indiana (East)"
    },
    @{
        ID                 = "045"
        EnglishName        = "S.A. Pacific Standard Time"
        EnglishDescription = "(GMT-05:00) Bogota, Lima, Quito"
    },
    @{
        ID                 = "050"
        EnglishName        = "Atlantic Standard Time"
        EnglishDescription = "(GMT-04:00) Atlantic Time (Canada)"
    },
    @{
        ID                 = "055"
        EnglishName        = "S.A. Western Standard Time"
        EnglishDescription = "(GMT-04:00) Caracas, La Paz"
    },
    @{
        ID                 = "056"
        EnglishName        = "Pacific S.A. Standard Time"
        EnglishDescription = "(GMT-04:00) Santiago"
    },
    @{
        ID                 = "060"
        EnglishName        = "Newfoundland and Labrador Standard Time"
        EnglishDescription = "(GMT-03:30) Newfoundland and Labrador"
    },
    @{
        ID                 = "065"
        EnglishName        = "E. South America Standard Time"
        EnglishDescription = "(GMT-03:00) Brasilia"
    },
    @{
        ID                 = "070"
        EnglishName        = "S.A. Eastern Standard Time"
        EnglishDescription = "(GMT-03:00) Buenos Aires, Georgetown"
    },
    @{
        ID                 = "073"
        EnglishName        = "Greenland Standard Time"
        EnglishDescription = "(GMT-03:00) Greenland"
    },
    @{
        ID                 = "075"
        EnglishName        = "Mid-Atlantic Standard Time"
        EnglishDescription = "(GMT-02:00) Mid-Atlantic"
    },
    @{
        ID                 = "080"
        EnglishName        = "Azores Standard Time"
        EnglishDescription = "(GMT-01:00) Azores"
    },
    @{
        ID                 = "083"
        EnglishName        = "Cape Verde Standard Time"
        EnglishDescription = "(GMT-01:00) Cape Verde Islands"
    },
    @{
        ID                 = "085"
        EnglishName        = "GMT Standard Time"
        EnglishDescription = "(GMT) Greenwich Mean Time: Dublin, Edinburgh, Lisbon, London"
    },
    @{
        ID                 = "090"
        EnglishName        = "Greenwich Standard Time"
        EnglishDescription = "(GMT) Casablanca, Monrovia"
    },
    @{
        ID                 = "095"
        EnglishName        = "Central Europe Standard Time"
        EnglishDescription = "(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague"
    },
    @{
        ID                 = "100"
        EnglishName        = "Central European Standard Time"
        EnglishDescription = "(GMT+01:00) Sarajevo, Skopje, Warsaw, Zagreb"
    },
    @{
        ID                 = "105"
        EnglishName        = "Romance Standard Time"
        EnglishDescription = "(GMT+01:00) Brussels, Copenhagen, Madrid, Paris"
    },
    @{
        ID                 = "110"
        EnglishName        = "W. Europe Standard Time"
        EnglishDescription = "(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    },
    @{
        ID                 = "113"
        EnglishName        = "W. Central Africa Standard Time"
        EnglishDescription = "(GMT+01:00) West Central Africa"
    },
    @{
        ID                 = "115"
        EnglishName        = "E. Europe Standard Time"
        EnglishDescription = "(GMT+02:00) Bucharest"
    },
    @{
        ID                 = "120"
        EnglishName        = "Egypt Standard Time"
        EnglishDescription = "(GMT+02:00) Cairo"
    },
    @{
        ID                 = "125"
        EnglishName        = "FLE Standard Time"
        EnglishDescription = "(GMT+02:00) Helsinki, Kiev, Riga, Sofia, Tallinn, Vilnius"
    },
    @{
        ID                 = "130"
        EnglishName        = "GTB Standard Time"
        EnglishDescription = "(GMT+02:00) Athens, Istanbul, Minsk"
    },
    @{
        ID                 = "135"
        EnglishName        = "Israel Standard Time"
        EnglishDescription = "(GMT+02:00) Jerusalem"
    },
    @{
        ID                 = "140"
        EnglishName        = "South Africa Standard Time"
        EnglishDescription = "(GMT+02:00) Harare, Pretoria"
    },
    @{
        ID                 = "145"
        EnglishName        = "Russian Standard Time"
        EnglishDescription = "(GMT+03:00) Moscow, St. Petersburg, Volgograd"
    },
    @{
        ID                 = "150"
        EnglishName        = "Arab Standard Time"
        EnglishDescription = "(GMT+03:00) Kuwait, Riyadh"
    },
    @{
        ID                 = "155"
        EnglishName        = "E. Africa Standard Time"
        EnglishDescription = "(GMT+03:00) Nairobi"
    },
    @{
        ID                 = "158"
        EnglishName        = "Arabic Standard Time"
        EnglishDescription = "(GMT+03:00) Baghdad"
    },
    @{
        ID                 = "160"
        EnglishName        = "Iran Standard Time"
        EnglishDescription = "(GMT+03:30) Tehran"
    },
    @{
        ID                 = "165"
        EnglishName        = "Arabian Standard Time"
        EnglishDescription = "(GMT+04:00) Abu Dhabi, Muscat"
    },
    @{
        ID                 = "170"
        EnglishName        = "Caucasus Standard Time"
        EnglishDescription = "(GMT+04:00) Baku, Tbilisi, Yerevan"
    },
    @{
        ID                 = "175"
        EnglishName        = "Transitional Islamic State of Afghanistan Standard Time"
        EnglishDescription = "(GMT+04:30) Kabul"
    },
    @{
        ID                 = "180"
        EnglishName        = "Ekaterinburg Standard Time"
        EnglishDescription = "(GMT+05:00) Ekaterinburg"
    },
    @{
        ID                 = "185"
        EnglishName        = "West Asia Standard Time"
        EnglishDescription = "(GMT+05:00) Islamabad, Karachi, Tashkent"
    },
    @{
        ID                 = "190"
        EnglishName        = "India Standard Time"
        EnglishDescription = "(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi"
    },
    @{
        ID                 = "193"
        EnglishName        = "Nepal Standard Time"
        EnglishDescription = "(GMT+05:45) Kathmandu"
    },
    @{
        ID                 = "195"
        EnglishName        = "Central Asia Standard Time"
        EnglishDescription = "(GMT+06:00) Astana, Dhaka"
    },
    @{
        ID                 = "200"
        EnglishName        = "Sri Lanka Standard Time"
        EnglishDescription = "(GMT+06:00) Sri Jayawardenepura"
    },
    @{
        ID                 = "201"
        EnglishName        = "N. Central Asia Standard Time"
        EnglishDescription = "(GMT+06:00) Almaty, Novosibirsk"
    },
    @{
        ID                 = "203"
        EnglishName        = "Myanmar Standard Time"
        EnglishDescription = "(GMT+06:30) Yangon Rangoon"
    },
    @{
        ID                 = "205"
        EnglishName        = "S.E. Asia Standard Time"
        EnglishDescription = "(GMT+07:00) Bangkok, Hanoi, Jakarta"
    },
    @{
        ID                 = "207"
        EnglishName        = "North Asia Standard Time"
        EnglishDescription = "(GMT+07:00) Krasnoyarsk"
    },
    @{
        ID                 = "210"
        EnglishName        = "China Standard Time"
        EnglishDescription = "(GMT+08:00) Beijing, Chongqing, Hong Kong SAR, Urumqi"
    },
    @{
        ID                 = "215"
        EnglishName        = "Singapore Standard Time"
        EnglishDescription = "(GMT+08:00) Kuala Lumpur, Singapore"
    },
    @{
        ID                 = "220"
        EnglishName        = "Taipei Standard Time"
        EnglishDescription = "(GMT+08:00) Taipei"
    },
    @{
        ID                 = "225"
        EnglishName        = "W. Australia Standard Time"
        EnglishDescription = "(GMT+08:00) Perth"
    },
    @{
        ID                 = "227"
        EnglishName        = "North Asia East Standard Time"
        EnglishDescription = "(GMT+08:00) Irkutsk, Ulaanbaatar"
    },
    @{
        ID                 = "230"
        EnglishName        = "Korea Standard Time"
        EnglishDescription = "(GMT+09:00) Seoul"
    },
    @{
        ID                 = "235"
        EnglishName        = "Tokyo Standard Time"
        EnglishDescription = "(GMT+09:00) Osaka, Sapporo, Tokyo"
    },
    @{
        ID                 = "240"
        EnglishName        = "Yakutsk Standard Time"
        EnglishDescription = "(GMT+09:00) Yakutsk"
    },
    @{
        ID                 = "245"
        EnglishName        = "A.U.S. Central Standard Time"
        EnglishDescription = "(GMT+09:30) Darwin"
    },
    @{
        ID                 = "250"
        EnglishName        = "Cen. Australia Standard Time"
        EnglishDescription = "(GMT+09:30) Adelaide"
    },
    @{
        ID                 = "255"
        EnglishName        = "A.U.S. Eastern Standard Time"
        EnglishDescription = "(GMT+10:00) Canberra, Melbourne, Sydney"
    },
    @{
        ID                 = "260"
        EnglishName        = "E. Australia Standard Time"
        EnglishDescription = "(GMT+10:00) Brisbane"
    },
    @{
        ID                 = "265"
        EnglishName        = "Tasmania Standard Time"
        EnglishDescription = "(GMT+10:00) Hobart"
    },
    @{
        ID                 = "270"
        EnglishName        = "Vladivostok Standard Time"
        EnglishDescription = "(GMT+10:00) Vladivostok"
    },
    @{
        ID                 = "275"
        EnglishName        = "West Pacific Standard Time"
        EnglishDescription = "(GMT+10:00) Guam, Port Moresby"
    },
    @{
        ID                 = "280"
        EnglishName        = "Central Pacific Standard Time"
        EnglishDescription = "(GMT+11:00) Magadan, Solomon Islands, New Caledonia"
    },
    @{
        ID                 = "285"
        EnglishName        = "Fiji Islands Standard Time"
        EnglishDescription = "(GMT+12:00) Fiji Islands, Kamchatka, Marshall Islands"
    },
    @{
        ID                 = "290"
        EnglishName        = "New Zealand Standard Time"
        EnglishDescription = "(GMT+12:00) Auckland, Wellington"
    },
    @{
        ID                 = "300"
        EnglishName        = "Tonga Standard Time"
        EnglishDescription = "(GMT+13:00) Nuku’alofa"
    }
)
function Format-EXOParams
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [System.Collections.Hashtable]
        $InputEXOParams,

        [Parameter()]
        [ValidateSet('New', 'Set')]
        [System.String]
        $Operation
    )
    $EXOParams = $InputEXOParams
    $EXOParams.Remove("GlobalAdminAccount") | Out-Null
    $EXOParams.Remove("Ensure") | Out-Null
    $EXOParams.Remove("Verbose") | Out-Null
    if ('New' -eq $Operation)
    {
        $EXOParams += @{
            Name = $EXOParams.Identity
        }
        $EXOParams.Remove("Identity") | Out-Null
        $EXOParams.Remove("MakeDefault") | Out-Null
        return $EXOParams
    }
    if ('Set' -eq $Operation)
    {
        $EXOParams.Remove("Enabled") | Out-Null
        return $EXOParams
    }
}

function Get-LocaleIDFromName
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name
    )

    $LocaleObject = $Locales | Where-Object -FilterScript { $_.EnglishName -eq $Name }

    if ($null -eq $LocaleObject)
    {
        throw "The specified Locale name {$($Name)} is not valid"
    }
    return $LocaleObject.ID
}

function Get-LocaleNameFromID
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ID
    )

    $LocaleObject = $Locales | Where-Object -FilterScript { $_.ID -eq $ID }

    if ($null -eq $LocaleObject)
    {
        throw "The specified Locale with ID {$($ID)} is not valid"
    }
    return $LocaleObject.EnglishName
}

function Get-TimeZoneNameFromID
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ID
    )

    $TimezoneObject = $Timezones | Where-Object -FilterScript { $_.ID -eq $ID }

    if ($null -eq $TimezoneObject)
    {
        throw "The specified Timzone with ID {$($ID)} is not valid"
    }
    return $TimezoneObject.EnglishName
}
function Get-TimeZoneIDFromName
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name
    )

    $TimezoneObject = $Timezones | Where-Object -FilterScript { $_.EnglishName -eq $Name }

    if ($null -eq $TimezoneObject)
    {
        throw "The specified Timzone {$($Name)} is not valid"
    }
    return $TimezoneObject.ID
}

function Get-TeamByGroupID
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupId
    )

    $team = Get-Team -GroupId $GroupId
    if ($null -eq $team)
    {
        return $false
    }
    return $true
}
function Get-TeamByName
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName
    )

    $loopCounter = 0
    do
    {
        $team = Get-Team -DisplayName $TeamName
        if ($null -eq $team)
        {
            Start-Sleep 5
        }
        $loopCounter += 1
        if ($loopCounter -gt 5)
        {
            break
        }
    } while ($null -eq $team)

    if ($null -eq $team)
    {
        throw "Team with Name $TeamName doesn't exist in tenant"
    }
    return $team
}

function Reset-AllTeamsCached
{
    [CmdletBinding()]
    param
    (
    )

    $Global:O365TeamsCached = $null
}
function Get-AllTeamsCached
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [Switch]
        $ForceRefresh
    )

    if($Global:O365TeamsCached -and !$ForceRefresh)
    {
        return $Global:O365TeamsCached
    }

    $allTeams = New-Object Collections.Generic.List[Microsoft.TeamsCmdlets.PowerShell.Custom.Model.Team]
    $allTeamSettings = New-Object Collections.Generic.List[Microsoft.TeamsCmdlets.PowerShell.Custom.Model.TeamSettings]

    $endpoint = "https://graph.microsoft.com"

    # The Get-Team cmdlet was not really written with throttling in mind
    # internally, they get the list of teams and then in parallel go to the /teams/{id} endpoint
    # this is actually the only way to get the team details, but when running in parallel without any limits
    # throttling is bound to come up and it is NOT handled at all
    # Get-Team
    $accessToken = Get-AppIdentityAccessToken $endpoint
    $httpClient = [Microsoft.TeamsCmdlets.PowerShell.Custom.Utils.HttpUtilities]::GetClient("Bearer $accessToken", "Get-TeamTraceCustom")
    try
    {
        $requestUri = [Uri]::new("$endpoint/v1.0/groups?$filter=groupTypes/any(c:c+eq+'Unified')&`$select=id,resourceProvisioningOptions,displayName,description,visibility,mailnickname,classification")
        Invoke-WithTransientErrorExponentialRetry -ScriptBlock {
            $accessToken = Get-AppIdentityAccessToken $endpoint
            $httpClient.DefaultRequestHeaders.Authorization = [System.Net.Http.Headers.AuthenticationHeaderValue]::Parse("Bearer $accessToken");
            $allTeams.AddRange([Microsoft.TeamsCmdlets.PowerShell.Custom.Utils.HttpUtilities].GetMethod("GetAll").MakeGenericMethod([Microsoft.TeamsCmdlets.PowerShell.Custom.Model.Team]).Invoke($null, @($httpClient, $requestUri)))
            Write-Verbose "Retrieved all teams"
        }


        $allTeams = $allTeams | Where-Object {
            $_.ResourceProvisioningOptions.Contains("Team")
        }

        $allTeams | ForEach-Object {
            try
            {
                $singleTeamClient = [Microsoft.TeamsCmdlets.PowerShell.Custom.Utils.HttpUtilities]::GetClient("Bearer $accessToken", "Get-TeamTraceCustom")
                $teamToRetrieve = $_
                Invoke-WithTransientErrorExponentialRetry -ScriptBlock {
                    $accessToken = Get-AppIdentityAccessToken $endpoint
                    $singleTeamClient.DefaultRequestHeaders.Authorization = [System.Net.Http.Headers.AuthenticationHeaderValue]::Parse("Bearer $accessToken")
                    $groupId= $teamToRetrieve.GroupId
                    $singleTeamRequestUri = [Uri]::new("$endpoint/v1.0/teams/$groupId")
                    Write-Verbose "retrieving from $singleTeamRequestUri"
                    [Type[]]$types = @([System.Net.Http.HttpClient], [Uri])
                    $team = [Microsoft.TeamsCmdlets.PowerShell.Custom.Utils.HttpUtilities].GetMethod("Get", $types).MakeGenericMethod([Microsoft.TeamsCmdlets.PowerShell.Custom.Model.Team]).Invoke($null, @($singleTeamClient, $singleTeamRequestUri))
                    $team.DisplayName = $_.DisplayName
                    $team.Description = $_.Description
                    $team.Visibility = $_.Visibility
                    $team.MailNickName = $_.MailNickName
                    $team.Classification = $_.Classification

                    $allTeamSettings.Add([Microsoft.TeamsCmdlets.PowerShell.Custom.Model.TeamSettings]::new($team))
                }
            }
            finally
            {
                $singleTeamClient.Dispose()
            }
        }
    }
    finally
    {
        $httpClient.Dispose()
    }

    $Global:O365TeamsCached = $allTeamSettings
    return $Global:O365TeamsCached
}


function Invoke-WithTransientErrorExponentialRetry
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ScriptBlock]
        $ScriptBlock
    )

    if($null -eq $Global:O365DSCBackoffRandomizer)
    {
        $Global:O365DSCBackoffRandomizer = [System.Random]::new()
    }

    $retryCount = 10
    $backoffPeriodMiliseconds = 500
    do
    {
        try
        {
            Write-Verbose "Executing script block, retryCount: $retryCount"
            Invoke-Command $ScriptBlock
            break
        }
        catch
        {
            if($null -eq $_.Exception -or $null -eq $_.Exception.InnerException -or ($_.Exception.InnerException.ErrorCode -ne 429 -and $_.Exception.InnerException.ErrorCode -ne 503) -or $retryCount -eq 0)
            {
                throw
            }

            Write-Verbose "The request has been throttled, will retry, retryCount: $retryCount"
        }
        Start-Sleep -Milliseconds $backoffPeriodMiliseconds
        $retryCount = $retryCount - 1
        $backoffPeriodMiliseconds = $backoffPeriodMiliseconds * 2 + $Global:O365DSCBackoffRandomizer.Next($backoffPeriodMiliseconds / 10)
    }
    while ($retryCount -gt 0)
}

function Convert-O365DscHashtableToString
{
    param
    (
        [Parameter()]
        [System.Collections.Hashtable]
        $Hashtable
    )
    $values = @()
    foreach ($pair in $Hashtable.GetEnumerator())
    {
        try
        {
            if ($pair.Value -is [System.Array])
            {
                $str = "$($pair.Key)=($($pair.Value -join ","))"
            }
            elseif ($pair.Value -is [System.Collections.Hashtable])
            {
                $str = "$($pair.Key)={$(Convert-O365DscHashtableToString -Hashtable $pair.Value)}"
            }
            else
            {
                if ($null -eq $pair.Value)
                {
                    $str = "$($pair.Key)=`$null"
                }
                else
                {
                    $str = "$($pair.Key)=$($pair.Value)"
                }
            }
            $values += $str
        }
        catch
        {
            Write-Warning "There was an error converting the Hashtable to a string: $_"
        }
    }

    [array]::Sort($values)
    return ($values -join "; ")
}

function New-EXOAntiPhishPolicy
{
    param (
        [Parameter()]
        [System.Collections.Hashtable]
        $AntiPhishPolicyParams
    )
    try
    {
        $VerbosePreference = 'Continue'
        $BuiltParams = (Format-EXOParams -InputEXOParams $AntiPhishPolicyParams -Operation 'New' )
        Write-Verbose -Message "Creating New AntiPhishPolicy $($BuiltParams.Name) with values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
        New-AntiPhishPolicy @BuiltParams
        $VerbosePreference = 'SilentlyContinue'
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }
}

function New-EXOAntiPhishRule
{
    param (
        [Parameter()]
        [System.Collections.Hashtable]
        $AntiPhishRuleParams
    )
    try
    {
        $VerbosePreference = 'Continue'
        $BuiltParams = (Format-EXOParams -InputEXOParams $AntiPhishRuleParams -Operation 'New')
        Write-Verbose -Message "Creating New AntiPhishRule $($BuiltParams.Name) with values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
        New-AntiPhishRule @BuiltParams -Confirm:$false
        $VerbosePreference = 'SilentlyContinue'
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }
}

function New-EXOHostedContentFilterRule
{
    param (
        [Parameter()]
        [System.Collections.Hashtable]
        $HostedContentFilterRuleParams
    )
    try
    {
        $VerbosePreference = 'Continue'
        $BuiltParams = (Format-EXOParams -InputEXOParams $HostedContentFilterRuleParams -Operation 'New' )
        Write-Verbose -Message "Creating New HostedContentFilterRule $($BuiltParams.Name) with values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
        New-HostedContentFilterRule @BuiltParams -Confirm:$false
        $VerbosePreference = 'SilentlyContinue'
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }
}

function New-EXOSafeAttachmentRule
{
    param (
        [Parameter()]
        [System.Collections.Hashtable]
        $SafeAttachmentRuleParams
    )
    try
    {
        $VerbosePreference = 'Continue'
        $BuiltParams = (Format-EXOParams -InputEXOParams $SafeAttachmentRuleParams -Operation 'New' )
        Write-Verbose -Message "Creating New SafeAttachmentRule $($BuiltParams.Name) with values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
        New-SafeAttachmentRule @BuiltParams -Confirm:$false
        $VerbosePreference = 'SilentlyContinue'
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }
}

function New-EXOSafeLinksRule
{
    param (
        [Parameter()]
        [System.Collections.Hashtable]
        $SafeLinksRuleParams
    )
    try
    {
        $VerbosePreference = 'Continue'
        $BuiltParams = (Format-EXOParams -InputEXOParams $SafeLinksRuleParams -Operation 'New' )
        Write-Verbose -Message "Creating New SafeLinksRule $($BuiltParams.Name) with values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
        New-SafeLinksRule @BuiltParams -Confirm:$false
        $VerbosePreference = 'SilentlyContinue'
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }
}

function Set-EXOAntiPhishRule
{
    param (
        [Parameter()]
        [System.Collections.Hashtable]
        $AntiPhishRuleParams
    )
    try
    {
        $VerbosePreference = 'Continue'
        $BuiltParams = (Format-EXOParams -InputEXOParams $AntiPhishRuleParams -Operation 'Set' )
        if ($BuiltParams.keys -gt 1)
        {
            Write-Verbose -Message "Setting AntiPhishRule $($BuiltParams.Identity) with values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
            Set-AntiPhishRule @BuiltParams -Confirm:$false
            $VerbosePreference = 'SilentlyContinue'
        }
        else
        {
            Write-Verbose -Message "No more values to Set on AntiPhishRule $($BuiltParams.Identity) using supplied values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
            $VerbosePreference = 'SilentlyContinue'
        }
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }
}

function Set-EXOAntiPhishPolicy
{
    param (
        [Parameter()]
        [System.Collections.Hashtable]
        $AntiPhishPolicyParams
    )
    try
    {
        $VerbosePreference = 'Continue'
        $BuiltParams = (Format-EXOParams -InputEXOParams $AntiPhishPolicyParams -Operation 'Set' )
        if ($BuiltParams.keys -gt 1)
        {
            Write-Verbose -Message "Setting AntiPhishPolicy $($BuiltParams.Identity) with values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
            Set-AntiPhishPolicy @BuiltParams -Confirm:$false
            $VerbosePreference = 'SilentlyContinue'
        }
        else
        {
            Write-Verbose -Message "No more values to Set on AntiPhishPolicy $($BuiltParams.Identity) using supplied values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
            $VerbosePreference = 'SilentlyContinue'
        }
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }
}
function Set-EXOHostedContentFilterRule
{
    param (
        [Parameter()]
        [System.Collections.Hashtable]
        $HostedContentFilterRuleParams
    )
    try
    {
        $VerbosePreference = 'Continue'
        $BuiltParams = (Format-EXOParams -InputEXOParams $HostedContentFilterRuleParams -Operation 'Set' )
        if ($BuiltParams.keys -gt 1)
        {
            Write-Verbose -Message "Setting HostedContentFilterRule $($BuiltParams.Identity) with values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
            Set-HostedContentFilterRule @BuiltParams -Confirm:$false
            $VerbosePreference = 'SilentlyContinue'
        }
        else
        {
            Write-Verbose -Message "No more values to Set on HostedContentFilterRule $($BuiltParams.Identity) using supplied values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
            $VerbosePreference = 'SilentlyContinue'
        }
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }
}

function Confirm-ImportedCmdletIsAvailable
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $CmdletName
    )
    try
    {
        $CmdletIsAvailable = (Get-Command -Name $CmdletName -ErrorAction SilentlyContinue)
        if ($CmdletIsAvailable)
        {
            return $true
        }
        else
        {
            return $false
        }
    }
    catch
    {
        return $false
    }
}

function Set-EXOSafeAttachmentRule
{
    param (
        [Parameter()]
        [System.Collections.Hashtable]
        $SafeAttachmentRuleParams
    )
    try
    {
        $VerbosePreference = 'Continue'
        $BuiltParams = (Format-EXOParams -InputEXOParams $SafeAttachmentRuleParams -Operation 'Set' )
        if ($BuiltParams.keys -gt 1)
        {
            Write-Verbose -Message "Setting SafeAttachmentRule $($BuiltParams.Identity) with values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
            Set-SafeAttachmentRule @BuiltParams -Confirm:$false
            $VerbosePreference = 'SilentlyContinue'
        }
        else
        {
            Write-Verbose -Message "No more values to Set on SafeAttachmentRule $($BuiltParams.Identity) using supplied values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
            $VerbosePreference = 'SilentlyContinue'
        }
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }
}

function Set-EXOSafeLinksRule
{
    param (
        [Parameter()]
        [System.Collections.Hashtable]
        $SafeLinksRuleParams
    )
    try
    {
        $VerbosePreference = 'Continue'
        $BuiltParams = (Format-EXOParams -InputEXOParams $SafeLinksRuleParams -Operation 'Set' )
        if ($BuiltParams.keys -gt 1)
        {
            Write-Verbose -Message "Setting SafeLinksRule $($BuiltParams.Identity) with values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
            Set-SafeLinksRule @BuiltParams -Confirm:$false
            $VerbosePreference = 'SilentlyContinue'
        }
        else
        {
            Write-Verbose -Message "No more values to Set on SafeLinksRule $($BuiltParams.Identity) using supplied values: $(Convert-O365DscHashtableToString -Hashtable $BuiltParams)"
            $VerbosePreference = 'SilentlyContinue'
        }
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }
}

function Compare-PSCustomObjectArrays
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $DesiredValues,

        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $CurrentValues
    )

    $DriftedProperties = @()
    foreach ($DesiredEntry in $DesiredValues)
    {
        $Properties = $DesiredEntry.PSObject.Properties
        $KeyProperty = $Properties.Name[0]

        $EquivalentEntryInCurrent = $CurrentValues | Where-Object -FilterScript { $_.$KeyProperty -eq $DesiredEntry.$KeyProperty }
        if ($null -eq $EquivalentEntryInCurrent)
        {
            $result = @{
                Property     = $DesiredEntry
                PropertyName = $KeyProperty
                Desired      = $DesiredEntry.$KeyProperty
                Current      = $null
            }
            $DriftedProperties += $DesiredEntry
        }
        else
        {
            foreach ($property in $Properties)
            {
                $propertyName = $property.Name

                if ($DesiredEntry.$PropertyName -ne $EquivalentEntryInCurrent.$PropertyName)
                {
                    $result = @{
                        Property     = $DesiredEntry
                        PropertyName = $PropertyName
                        Desired      = $DesiredEntry.$PropertyName
                        Current      = $EquivalentEntryInCurrent.$PropertyName
                    }
                    $DriftedProperties += $result
                }
            }
        }
    }

    return $DriftedProperties
}

function Test-Office365DSCParameterState
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 1)]
        [HashTable]
        $CurrentValues,

        [Parameter(Mandatory = $true, Position = 2)]
        [Object]
        $DesiredValues,

        [Parameter(Position = 3)]
        [Array]
        $ValuesToCheck,

        [Parameter(Position = 4)]
        [System.String]
        $Source = 'Generic'
    )
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", "$Source")
    $data.Add("Method", "Test-TargetResource")
    #endregion
    $returnValue = $true

    $DriftedParameters = @{ }

    if (($DesiredValues.GetType().Name -ne "HashTable") `
            -and ($DesiredValues.GetType().Name -ne "CimInstance") `
            -and ($DesiredValues.GetType().Name -ne "PSBoundParametersDictionary"))
    {
        throw ("Property 'DesiredValues' in Test-Office365DscParameterState must be either a " + `
                "Hashtable or CimInstance. Type detected was $($DesiredValues.GetType().Name)")
    }

    if (($DesiredValues.GetType().Name -eq "CimInstance") -and ($null -eq $ValuesToCheck))
    {
        throw ("If 'DesiredValues' is a CimInstance then property 'ValuesToCheck' must contain " + `
                "a value")
    }

    if (($null -eq $ValuesToCheck) -or ($ValuesToCheck.Count -lt 1))
    {
        $KeyList = $DesiredValues.Keys
    }
    else
    {
        $KeyList = $ValuesToCheck
    }

    $KeyList | ForEach-Object -Process {
        if (($_ -ne "Verbose") -and ($_ -ne "InstallAccount"))
        {
            if (($CurrentValues.ContainsKey($_) -eq $false) `
                    -or ($CurrentValues.$_ -ne $DesiredValues.$_) `
                    -or (($DesiredValues.ContainsKey($_) -eq $true) -and ($null -ne $DesiredValues.$_ -and $DesiredValues.$_.GetType().IsArray)))
            {
                if ($DesiredValues.GetType().Name -eq "HashTable" -or `
                        $DesiredValues.GetType().Name -eq "PSBoundParametersDictionary")
                {
                    $CheckDesiredValue = $DesiredValues.ContainsKey($_)
                }
                else
                {
                    $CheckDesiredValue = Test-Office365DSCObjectHasProperty -Object $DesiredValues -PropertyName $_
                }

                if ($CheckDesiredValue)
                {
                    $desiredType = $DesiredValues.$_.GetType()
                    $fieldName = $_
                    if ($desiredType.IsArray -eq $true)
                    {
                        if (($CurrentValues.ContainsKey($fieldName) -eq $false) `
                                -or ($null -eq $CurrentValues.$fieldName))
                        {
                            Write-Verbose -Message ("Expected to find an array value for " + `
                                    "property $fieldName in the current " + `
                                    "values, but it was either not present or " + `
                                    "was null. This has caused the test method " + `
                                    "to return false.")
                            $DriftedParameters.Add($fieldName, '')
                            $returnValue = $false
                        }
                        elseif ($desiredType.Name -eq 'ciminstance[]')
                        {
                            Write-Verbose "The current property {$_} is a CimInstance[]"
                            $AllDesiredValuesAsArray = @()
                            foreach ($item in $DesiredValues.$_)
                            {
                                $currentEntry = @{ }
                                foreach ($prop in $item.CIMInstanceProperties)
                                {
                                    $value = $prop.Value
                                    if ([System.String]::IsNullOrEmpty($value))
                                    {
                                        $value = $null
                                    }
                                    $currentEntry.Add($prop.Name, $value)
                                }
                                $AllDesiredValuesAsArray += [PSCustomObject]$currentEntry
                            }

                            $arrayCompare = Compare-PSCustomObjectArrays -CurrentValues $CurrentValues.$fieldName `
                                -DesiredValues $AllDesiredValuesAsArray
                            if ($null -ne $arrayCompare)
                            {
                                foreach ($item in $arrayCompare)
                                {
                                    $EventValue = "<CurrentValue>[$($item.PropertyName)]$($item.CurrentValue)</CurrentValue>"
                                    $EventValue += "<DesiredValue>[$($item.PropertyName)]$($item.DesiredValue)</DesiredValue>"
                                    $DriftedParameters.Add($fieldName, $EventValue)
                                }
                                $returnValue = $false
                            }
                        }
                        else
                        {
                            $arrayCompare = Compare-Object -ReferenceObject $CurrentValues.$fieldName `
                                -DifferenceObject $DesiredValues.$fieldName
                            if ($null -ne $arrayCompare -and
                                -not [System.String]::IsNullOrEmpty($arrayCompare.InputObject))
                            {
                                Write-Verbose -Message ("Found an array for property $fieldName " + `
                                        "in the current values, but this array " + `
                                        "does not match the desired state. " + `
                                        "Details of the changes are below.")
                                $arrayCompare | ForEach-Object -Process {
                                    Write-Verbose -Message "$($_.InputObject) - $($_.SideIndicator)"
                                }

                                $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"
                                $DriftedParameters.Add($fieldName, $EventValue)
                                $returnValue = $false
                            }
                        }
                    }
                    else
                    {
                        switch ($desiredType.Name)
                        {
                            "String"
                            {
                                if ([string]::IsNullOrEmpty($CurrentValues.$fieldName) `
                                        -and [string]::IsNullOrEmpty($DesiredValues.$fieldName))
                                {
                                }
                                else
                                {
                                    Write-Verbose -Message ("String value for property " + `
                                            "$fieldName does not match. " + `
                                            "Current state is " + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            "and desired state is " + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                    $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"
                                    $DriftedParameters.Add($fieldName, $EventValue)
                                    $returnValue = $false
                                }
                            }
                            "Int32"
                            {
                                if (($DesiredValues.$fieldName -eq 0) `
                                        -and ($null -eq $CurrentValues.$fieldName))
                                {
                                }
                                else
                                {
                                    Write-Verbose -Message ("Int32 value for property " + `
                                            "$fieldName does not match. " + `
                                            "Current state is " + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            "and desired state is " + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                    $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"
                                    $DriftedParameters.Add($fieldName, $EventValue)
                                    $returnValue = $false
                                }
                            }
                            "Int16"
                            {
                                if (($DesiredValues.$fieldName -eq 0) `
                                        -and ($null -eq $CurrentValues.$fieldName))
                                {
                                }
                                else
                                {
                                    Write-Verbose -Message ("Int16 value for property " + `
                                            "$fieldName does not match. " + `
                                            "Current state is " + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            "and desired state is " + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                    $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"
                                    $DriftedParameters.Add($fieldName, $EventValue)
                                    $returnValue = $false
                                }
                            }
                            "Boolean"
                            {
                                if ($CurrentValues.$fieldName -ne $DesiredValues.$fieldName)
                                {
                                    Write-Verbose -Message ("Boolean value for property " + `
                                            "$fieldName does not match. " + `
                                            "Current state is " + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            "and desired state is " + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                    $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"
                                    $DriftedParameters.Add($fieldName, $EventValue)
                                    $returnValue = $false
                                }
                            }
                            "Single"
                            {
                                if (($DesiredValues.$fieldName -eq 0) `
                                        -and ($null -eq $CurrentValues.$fieldName))
                                {
                                }
                                else
                                {
                                    Write-Verbose -Message ("Single value for property " + `
                                            "$fieldName does not match. " + `
                                            "Current state is " + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            "and desired state is " + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                    $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"
                                    $DriftedParameters.Add($fieldName, $EventValue)
                                    $returnValue = $false
                                }
                            }
                            "Hashtable"
                            {
                                Write-Verbose -Message "The current property {$fieldName} is a Hashtable"
                                $AllDesiredValuesAsArray = @()
                                foreach ($item in $DesiredValues.$fieldName)
                                {
                                    $currentEntry = @{ }
                                    foreach ($key in $item.Keys)
                                    {
                                        $value = $item.$key
                                        if ([System.String]::IsNullOrEmpty($value))
                                        {
                                            $value = $null
                                        }
                                        $currentEntry.Add($key, $value)
                                    }
                                    $AllDesiredValuesAsArray += [PSCustomObject]$currentEntry
                                }

                                if ($null -ne $DesiredValues.$fieldName -and $null -eq $CurrentValues.$fieldName)
                                {
                                    $returnValue = $false
                                }
                                else
                                {
                                    $AllCurrentValuesAsArray = @()
                                    foreach ($item in $CurrentValues.$fieldName)
                                    {
                                        $currentEntry = @{ }
                                        foreach ($key in $item.Keys)
                                        {
                                            $value = $item.$key
                                            if ([System.String]::IsNullOrEmpty($value))
                                            {
                                                $value = $null
                                            }
                                            $currentEntry.Add($key, $value)
                                        }
                                        $AllCurrentValuesAsArray += [PSCustomObject]$currentEntry
                                    }
                                    $arrayCompare = Compare-PSCustomObjectArrays -CurrentValues $AllCurrentValuesAsArray `
                                    -DesiredValues $AllCurrentValuesAsArray
                                    if ($null -ne $arrayCompare)
                                    {
                                        foreach ($item in $arrayCompare)
                                        {
                                            $EventValue = "<CurrentValue>[$($item.PropertyName)]$($item.CurrentValue)</CurrentValue>"
                                            $EventValue += "<DesiredValue>[$($item.PropertyName)]$($item.DesiredValue)</DesiredValue>"
                                            $DriftedParameters.Add($fieldName, $EventValue)
                                        }
                                        $returnValue = $false
                                    }
                                }
                            }
                            default
                            {
                                Write-Verbose -Message ("Unable to compare property $fieldName " + `
                                        "as the type ($($desiredType.Name)) is " + `
                                        "not handled by the " + `
                                        "Test-Office365DscParameterState cmdlet")
                                $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"
                                $DriftedParameters.Add($fieldName, $EventValue)
                                $returnValue = $false
                            }
                        }
                    }
                }
            }
        }
    }

    if ($returnValue -eq $false)
    {
        $EventMessage = "<O365DSCEvent>`r`n"
        $EventMessage += "    <ConfigurationDrift Source=`"$Source`">`r`n"

        $EventMessage += "        <ParametersNotInDesiredState>`r`n"
        $driftedValue = ''
        foreach ($key in $DriftedParameters.Keys)
        {
            Write-Verbose -Message "Detected Drifted Parameter [$Source]$key"
            #region Telemetry
            $driftedData = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
            $driftedData.Add("Event", "DriftedParameter")
            $driftedData.Add("Parameter", "[$Source]$key")
            Add-O365DSCTelemetryEvent -Type "DriftInfo" -Data $driftedData
            #endregion
            $EventMessage += "            <Param Name=`"$key`">" + $DriftedParameters.$key + "</Param>`r`n"
        }
        #region Telemetry
        $data.Add("Event", "ConfigurationDrift")
        #endregion
        $EventMessage += "        </ParametersNotInDesiredState>`r`n"
        $EventMessage += "    </ConfigurationDrift>`r`n"
        $EventMessage += "    <DesiredValues>`r`n"
        foreach ($Key in $DesiredValues.Keys)
        {
            $Value = $DesiredValues.$Key
            if ([System.String]::IsNullOrEmpty($Value))
            {
                $Value = "`$null"
            }
            $EventMessage += "        <Param Name =`"$key`">$Value</Param>`r`n"
        }
        $EventMessage += "    }"
        $EventMessage += "    </DesiredValues>`r`n"
        $EventMessage += "</O365DSCEvent>"

        Add-O365DSCEvent -Message $EventMessage -EntryType 'Error' -EventID 1 -Source $Source
    }
    #region Telemetry
    Add-O365DSCTelemetryEvent -Data $data
    #endregion
    return $returnValue
}

<# This is the main Office365DSC.Reverse function that extracts the DSC configuration from an existing
   Office 365 Tenant. #>
function Export-O365Configuration
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Switch]
        $Quiet,

        [Parameter()]
        [System.String]
        $Path,

        [Parameter()]
        [System.String]
        $FileName,

        [Parameter()]
        [System.String]
        $ConfigurationName,

        [Parameter()]
        [System.String[]]
        $ComponentsToExtract,

        [Parameter()]
        [ValidateSet('SPO', 'EXO', 'SC', 'OD', 'O365', 'PP', 'TEAMS')]
        [System.String[]]
        $Workloads,

        [Parameter()]
        [ValidateRange(1, 100)]
        $MaxProcesses,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = 'SilentlyContinue'
    $WarningPreference = 'SilentlyContinue'

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Event", "Extraction")
    $data.Add("Quiet", $Quiet)
    $data.Add("Path", [System.String]::IsNullOrEmpty($Path))
    $data.Add("FileName", $null -ne [System.String]::IsNullOrEmpty($FileName))
    $data.Add("ComponentsToExtract", $null -ne $ComponentsToExtract)
    $data.Add("Workloads", $null -ne $Workloads)
    $data.Add("MaxProcesses", $null -ne $MaxProcesses)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    if ($null -eq $MaxProcesses)
    {
        $MaxProcesses = 16
    }

    if (-not $Quiet)
    {
        Show-O365GUI -Path $Path
    }
    else
    {
        if ($null -ne $Workloads)
        {
            Start-O365ConfigurationExtract -GlobalAdminAccount $GlobalAdminAccount `
                -Workloads $Workloads `
                -Path $Path -FileName $FileName `
                -MaxProcesses $MaxProcesses `
                -ConfigurationName $ConfigurationName `
                -Quiet
        }
        elseif ($null -ne $ComponentsToExtract)
        {
            Start-O365ConfigurationExtract -GlobalAdminAccount $GlobalAdminAccount `
                -ComponentsToExtract $ComponentsToExtract `
                -Path $Path -FileName $FileName `
                -MaxProcesses $MaxProcesses `
                -ConfigurationName $ConfigurationName `
                -Quiet
        }
        else
        {
            Start-O365ConfigurationExtract -GlobalAdminAccount $GlobalAdminAccount `
                -AllComponents `
                -Path $Path -FileName $FileName `
                -MaxProcesses $MaxProcesses `
                -ConfigurationName $ConfigurationName `
                -Quiet
        }
    }
}

function Split-ArrayByBatchSize
{
    [OutputType([System.Object[]])]
    Param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $Array,

        [Parameter(Mandatory = $true)]
        [System.Uint32]
        $BatchSize
    )
    for ($i = 0; $i -lt $Array.Count; $i += $BatchSize)
    {
        $NewArray += , @($Array[$i..($i + ($BatchSize - 1))]);
    }
    return $NewArray
}

function Split-ArrayByParts
{
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $Array,

        [Parameter(Mandatory = $true)]
        [System.Uint32]
        $Parts
    )

    if ($Parts)
    {
        $PartSize = [Math]::Ceiling($Array.Count / $Parts)
    }
    $outArray = New-Object 'System.Collections.Generic.List[PSObject]'

    for ($i = 1; $i -le $Parts; $i++)
    {
        $start = (($i - 1) * $PartSize)

        if ($start -lt $Array.Count)
        {
            $end = (($i) * $PartSize) - 1
            if ($end -ge $Array.count)
            {
                $end = $Array.count - 1
            }
            $outArray.Add(@($Array[$start..$end]))
        }
    }
    return , $outArray
}

function Start-DSCInitializedJob
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        $Name,
        [Parameter(Mandatory = $true)]
        [ScriptBlock]
        $ScriptBlock,
        [Parameter()]
        [Object[]]
        $ArgumentList
    )

    $msloginAssistentPath = $PSScriptRoot + "\..\..\MSCloudLoginAssistant\MSCloudLoginAssistant.psd1"
    $setupAuthScript = " Import-Module '$msloginAssistentPath' -Force | Out-Null;"
    if($Global:appIdentityParams)
    {
        $entropyStr = [string]::Join(', ', $Global:appIdentityParams.TokenCacheEntropy)
        $setupAuthScript += "[byte[]] `$tokenCacheEntropy = $entropyStr;"
        $setupAuthScript += "Init-ApplicationIdentity -Tenant $($Global:appIdentityParams.Tenant) -AppId $($Global:appIdentityParams.AppId) -AppSecret '$($Global:appIdentityParams.AppSecret)' -CertificateThumbprint '$($Global:appIdentityParams.CertificateThumbprint)' -OnBehalfOfUserPrincipalName '$($Global:appIdentityParams.OnBehalfOfUserPrincipalName)' -TokenCacheLocation '$($Global:appIdentityParams.TokenCacheLocation)' -TokenCacheEntropy `$tokenCacheEntropy -TokenCacheDataProtectionScope $($Global:appIdentityParams.TokenCacheDataProtectionScope);"
    }

    $insertPosition = 0
    if($ScriptBlock.Ast.BeginBlock)
    {
        $insertPosition = $ScriptBlock.Ast.BeginBlock.Statements[0].Extent.StartOffset;
    }
    elseif($ScriptBlock.Ast.ProcessBlock)
    {
        $insertPosition = $ScriptBlock.Ast.ProcessBlock.Statements[0].Extent.StartOffset;
    }
    elseif($ScriptBlock.Ast.EndBlock)
    {
        $insertPosition = $ScriptBlock.Ast.EndBlock.Statements[0].Extent.StartOffset;
    }
    $insertPosition = $insertPosition - $ScriptBlock.StartPosition.Start
    $strScriptContent = $ScriptBlock.ToString();
    $strScriptContent = $strScriptContent.Insert($insertPosition - 1, $setupAuthScript +"`n")
    $newScriptBlock = [ScriptBlock]::Create($strScriptContent)
    Start-Job -Name $Name -ScriptBlock $newScriptBlock  -ArgumentList $ArgumentList
}

function Invoke-O365DSCCommand
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ScriptBlock]
        $ScriptBlock,

        [Parameter()]
        [System.String]
        $InvokationPath,

        [Parameter()]
        [Object[]]
        $Arguments,

        [Parameter()]
        [System.UInt32]
        $Backoff = 2
    )

    $InformationPreference = 'SilentlyContinue'
    $WarningPreference = 'SilentlyContinue'
    $ErrorActionPreference = 'Stop'
    try
    {
        if (-not [System.String]::IsNullOrEmpty($InvokationPath))
        {
            $baseScript = "Import-Module '$InvokationPath\*.psm1' -Force;"
        }

        $invokeArgs = @{
            ScriptBlock = [ScriptBlock]::Create($baseScript + $ScriptBlock.ToString())
        }
        if ($null -ne $Arguments)
        {
            $invokeArgs.Add("ArgumentList", $Arguments)
        }
        return Invoke-Command @invokeArgs
    }
    catch
    {
        if ($_.Exception -like '*O365DSC - *')
        {
            Write-Warning $_.Exception
        }
        else
        {
            if ($Backoff -le 128)
            {
                $NewBackoff = $Backoff * 2
                Write-Warning "    * Throttling detected. Waiting for {$NewBackoff seconds}"
                Start-Sleep -Seconds $NewBackoff
                return Invoke-O365DSCCommand -ScriptBlock $ScriptBlock -Backoff $NewBackoff -Arguments $Arguments -InvokationPath $InvokationPath
            }
            else
            {
                Write-Warning $_
            }
        }
    }
}

function Get-SPOUserProfilePropertyInstance
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value
    )

    $result = [PSCustomObject]@{
        Key   = $Key
        Value = $Value
    }

    return $result
}

function ConvertTo-SPOUserProfilePropertyInstanceString
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $Properties
    )

    $results = @()
    foreach ($property in $Properties)
    {
        $value = $property.Value
        if($value -and !($value -is [string]))
        {
            $value = $value.ToString()
        }
        elseif(!$value)
        {
            $value = ""
        }
        $value = $value.Replace("`"", "```"")

        $content = "             MSFT_SPOUserProfilePropertyInstance`r`n            {`r`n"
        $content += "                Key   = `"$($property.Key)`"`r`n"
        $content += "                Value = `"$($value)`"`r`n"
        $content += "            }`r`n"
        $results += $content
    }
    return $results
}

function Install-O365DSCDevBranch
{
    [CmdletBinding()]
    param()
    #region Download and Extract Dev branch's ZIP
    $url         = "https://github.com/microsoft/Office365DSC/archive/Dev.zip"
    $output      = "$($env:Temp)\dev.zip"
    $extractPath = $env:Temp + "\O365Dev"

    Invoke-WebRequest -Uri $url -OutFile $output

    Expand-Archive $output -DestinationPath $extractPath -Force
    #endregion

    #region Install All Dependencies
    $manifest = Import-PowerShellDataFile "$extractPath\Office365DSC-Dev\Modules\Office365DSC\Office365DSC.psd1"
    $dependencies = $manifest.RequiredModules
    foreach ($dependency in $dependencies)
    {
        Install-Module $dependency.ModuleName -RequiredVersion $dependency.RequiredVersion -Force
        Import-Module $dependency.ModuleName -Force
    }
    #endregion

    #region Install O365DSC
    $defaultPath = 'C:\Program Files\WindowsPowerShell\Modules\Office365DSC\'
    $currentVersionPath = $defaultPath + $($manifest.ModuleVersion)
    if (Test-Path $currentVersionPath)
    {
        Remove-Item $currentVersionPath -Recurse -Confirm:$false
    }
    Copy-Item "$extractPath\Office365DSC-Dev\Modules\Office365DSC" -Destination $currentVersionPath -Recurse -Force
    #endregion
}

function Get-AllSPOPackages
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $tenantAppCatalogUrl = Get-PnPTenantAppCatalogUrl

    Test-MSCloudLogin -ConnectionUrl $tenantAppCatalogUrl `
        -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $filesToDownload = @()

    if ($null -ne $tenantAppCatalogUrl)
    {
        $spfxFiles = Find-PnPFile -List "AppCatalog" -Match '*.sppkg'
        $appFiles = Find-PnPFile -List "AppCatalog" -Match '*.app'

        $allFiles = $spfxFiles + $appFiles

        foreach ($file in $allFiles)
        {
            $filesToDownload += @{Name = $file.Name; Site = $tenantAppCatalogUrl; Title = $file.Title}
        }
    }
    return $filesToDownload
}

function Remove-NullEntriesFromHashtable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.COllections.HashTable]
        $Hash
    )

    $keysToRemove = @()
    foreach ($key in $Hash.Keys)
    {
        if ([System.String]::IsNullOrEmpty($Hash.$key))
        {
            $keysToRemove += $key
        }
    }

    foreach ($key in $keysToRemove)
    {
        $Hash.Remove($key) | Out-Null
    }

    return $Hash
}

function Execute-CSOMQueryRetry
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.SharePoint.Client.ClientContext] $context
    )

    [Microsoft.SharePoint.Client.ClientContextExtensions]::ExecuteQueryRetry($context)
}

<#
.Synopsis
    Facilitates the loading of specific properties of a Microsoft.SharePoint.Client.ClientObject object or Microsoft.SharePoint.Client.ClientObjectCollection object.
.DESCRIPTION
    Replicates what you would do with a lambda expression in C#.
    For example, "ctx.Load(list, l => list.Title, l => list.Id)" becomes
    "Load-CSOMProperties -object $list -propertyNames @('Title', 'Id')".
.EXAMPLE
    Load-CSOMProperties -parentObject $web -collectionObject $web.Fields -propertyNames @("InternalName", "Id") -parentPropertyName "Fields" -executeQuery
    $web.Fields | select InternalName, Id
.EXAMPLE
   Load-CSOMProperties -object $web -propertyNames @("Title", "Url", "AllProperties") -executeQuery
   $web | select Title, Url, AllProperties
#>
function Load-CSOMProperties {
    [CmdletBinding(DefaultParameterSetName='ClientObject')]
    param (
        # The Microsoft.SharePoint.Client.ClientObject to populate.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0, ParameterSetName = "ClientObject")]
        [Microsoft.SharePoint.Client.ClientObject]
        $object,

        # The Microsoft.SharePoint.Client.ClientObject that contains the collection object.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0, ParameterSetName = "ClientObjectCollection")]
        [Microsoft.SharePoint.Client.ClientObject]
        $parentObject,

        # The Microsoft.SharePoint.Client.ClientObjectCollection to populate.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 1, ParameterSetName = "ClientObjectCollection")]
        [Microsoft.SharePoint.Client.ClientObjectCollection]
        $collectionObject,

        # The object properties to populate
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "ClientObject")]
        [Parameter(Mandatory = $true, Position = 2, ParameterSetName = "ClientObjectCollection")]
        [string[]]
        $propertyNames,

        # The parent object's property name corresponding to the collection object to retrieve (this is required to build the correct lamda expression).
        [Parameter(Mandatory = $true, Position = 3, ParameterSetName = "ClientObjectCollection")]
        [string]
        $parentPropertyName,

        # If specified, execute the ClientContext.ExecuteQuery() method.
        [Parameter(Mandatory = $false, Position = 4)]
        [switch]
        $executeQuery
    )

    begin { }
    process {
        if ($PsCmdlet.ParameterSetName -eq "ClientObject") {
            $type = $object.GetType()
        } else {
            $type = $collectionObject.GetType()
            if ($collectionObject -is [Microsoft.SharePoint.Client.ClientObjectCollection]) {
                $type = $collectionObject.GetType().BaseType.GenericTypeArguments[0]
            }
        }

        $exprType = [System.Linq.Expressions.Expression]
        $parameterExprType = [System.Linq.Expressions.ParameterExpression].MakeArrayType()
        $lambdaMethod = $exprType.GetMethods() | ? { $_.Name -eq "Lambda" -and $_.IsGenericMethod -and $_.GetParameters().Length -eq 2 -and $_.GetParameters()[1].ParameterType -eq $parameterExprType }
        $lambdaMethodGeneric = Invoke-Expression "`$lambdaMethod.MakeGenericMethod([System.Func``2[$($type.FullName),System.Object]])"
        $expressions = @()

        foreach ($propertyName in $propertyNames) {
            $param1 = [System.Linq.Expressions.Expression]::Parameter($type, "p")
            try {
                $name1 = [System.Linq.Expressions.Expression]::Property($param1, $propertyName)
            } catch {
                Write-Error "Instance property '$propertyName' is not defined for type $type"
                return
            }
            $body1 = [System.Linq.Expressions.Expression]::Convert($name1, [System.Object])
            $expression1 = $lambdaMethodGeneric.Invoke($null, [System.Object[]] @($body1, [System.Linq.Expressions.ParameterExpression[]] @($param1)))

            if ($collectionObject -ne $null) {
                $expression1 = [System.Linq.Expressions.Expression]::Quote($expression1)
            }
            $expressions += @($expression1)
        }


        if ($PsCmdlet.ParameterSetName -eq "ClientObject") {
            $object.Context.Load($object, $expressions)
            if ($executeQuery) { $object.Context.ExecuteQuery() }
        } else {
            $newArrayInitParam1 = Invoke-Expression "[System.Linq.Expressions.Expression``1[System.Func````2[$($type.FullName),System.Object]]]"
            $newArrayInit = [System.Linq.Expressions.Expression]::NewArrayInit($newArrayInitParam1, $expressions)

            $collectionParam = [System.Linq.Expressions.Expression]::Parameter($parentObject.GetType(), "cp")
            $collectionProperty = [System.Linq.Expressions.Expression]::Property($collectionParam, $parentPropertyName)

            $expressionArray = @($collectionProperty, $newArrayInit)
            $includeMethod = [Microsoft.SharePoint.Client.ClientObjectQueryableExtension].GetMethod("Include")
            $includeMethodGeneric = Invoke-Expression "`$includeMethod.MakeGenericMethod([$($type.FullName)])"

            $lambdaMethodGeneric2 = Invoke-Expression "`$lambdaMethod.MakeGenericMethod([System.Func``2[$($parentObject.GetType().FullName),System.Object]])"
            $callMethod = [System.Linq.Expressions.Expression]::Call($null, $includeMethodGeneric, $expressionArray)

            $expression2 = $lambdaMethodGeneric2.Invoke($null, @($callMethod, [System.Linq.Expressions.ParameterExpression[]] @($collectionParam)))

            $parentObject.Context.Load($parentObject, $expression2)
            if ($executeQuery) { $parentObject.Context.ExecuteQuery() }
        }
    }
    end { }
}
