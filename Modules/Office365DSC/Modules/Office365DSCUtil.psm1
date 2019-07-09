
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
        $loopCounter +=1
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
function Connect-ExchangeOnline
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $VerbosePreference = 'SilentlyContinue'
    $WarningPreference = "Continue"
    $ClosedOrBrokenSessions = Get-PSSession -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.State -ne 'Opened' }
    if ($ClosedOrBrokenSessions)
    {
        Write-Verbose -Message "Found Existing Unusable Session(s)."
        foreach ($SessionToBeClosed in $ClosedOrBrokenSessions)
        {
            Write-Verbose -Message "Closing Session: $(($SessionToBeClosed).InstanceId)"
            $SessionToBeClosed | Remove-PSSession
        }
    }

    $Global:OpenExchangeSession = Get-PSSession -Name 'ExchangeOnline' -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.State -eq 'Opened' }
    if ($null -eq $Global:OpenExchangeSession)
    {
        try
        {
            $PowerShellConnections = Get-NetTCPConnection | Where-Object -FilterScript { $_.OwningProcess -eq $PID -and $_.RemotePort -eq '443' -and $_.State -ne 'Established' }

            while ($PowerShellConnections)
            {
                Write-Verbose -Message "This process is using the following connections in a non-Established state: $($PowerShellConnections | Out-String)"
                Write-Verbose -Message "Waiting for closing connections to close..."
                Get-PSSession -Name 'ExchangeOnline' -ErrorAction SilentlyContinue | Remove-PSSession
                Start-Sleep -seconds 1
                $CheckConnectionsWithoutKillingWhileLoop = Get-NetTCPConnection | Where-Object -FilterScript { $_.OwningProcess -eq $PID -and $_.RemotePort -eq '443' -and $_.State -ne 'Established' }
                if (-not $CheckConnectionsWithoutKillingWhileLoop) {
                    Write-Verbose -Message "Connections have closed.  Waiting 5 more seconds..."
                    Start-Sleep -seconds 5
                    $PowerShellConnections = Get-NetTCPConnection | Where-Object -FilterScript { $_.OwningProcess -eq $PID -and $_.RemotePort -eq '443' -and $_.State -ne 'Established' }
                }
            }

            if ($Global:ExchangeOnlineSession.State -eq "Closed")
            {
                Remove-PSSession $Global:ExchangeOnlineSession
                $Global:ExchangeOnlineSession = $null
            }

            while ($null -eq $Global:ExchangeOnlineSession)
            {
                Write-Verbose -Message "Creating new EXO Session"
                $Global:ExchangeOnlineSession = New-PSSession -Name 'ExchangeOnline' -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $GlobalAdminAccount -Authentication Basic -AllowRedirection -ErrorAction SilentlyContinue

                if ($null -eq $Global:ExchangeOnlineSession)
                {
                    Write-Warning "Exceeded max number of connections. Waiting 60 seconds"
                    Start-Sleep 60
                }
            }

            if ($null -eq $Global:ExchangeOnlineModules)
            {
                Write-Verbose -Message "Importing all commands into the EXO Session"
                $Global:ExchangeOnlineModules = Import-PSSession $Global:ExchangeOnlineSession -AllowClobber
                Import-Module $Global:ExchangeOnlineModules -Global | Out-Null
            }
        }
        catch
        {
            $ExceptionMessage = $_.Exception
            $Error.Clear()
            $VerbosePreference = 'SilentlyContinue'
            if ($ExceptionMessage -imatch 'Please wait for [0-9]* seconds' )
            {
                Write-Verbose -Message "Waiting for available runspace..."
                [regex]$WaitTimePattern = 'Please wait for [0-9]* seconds'
                $WaitTimePatternMatch = (($WaitTimePattern.Match($ExceptionMessage)).Value | Select-String -Pattern '[0-9]*' -AllMatches )
                $WaitTimeInSeconds = ($WaitTimePatternMatch | ForEach-Object {$_.Matches} | Where-Object -FilterScript { $_.Value -NotLike $null }).Value
                Write-Verbose -Message "Waiting for requested $WaitTimeInSeconds seconds..."
                Start-Sleep -Seconds ($WaitTimeInSeconds + 1)
                try
                {
                    Write-Verbose -Message "Opening New ExchangeOnline Session."
                    $PowerShellConnections = Get-NetTCPConnection | Where-Object -FilterScript { $_.OwningProcess -eq $PID -and $_.RemotePort -eq '443' -and $_.State -ne 'Established' }
                    while ($PowerShellConnections)
                    {
                        Write-Verbose -Message "This process is using the following connections in a non-Established state: $($PowerShellConnections | Out-String)"
                        Write-Verbose -Message "Waiting for closing connections to close..."
                        Get-PSSession -Name 'ExchangeOnline' -ErrorAction SilentlyContinue | Remove-PSSession
                        Start-Sleep -seconds 1
                        $CheckConnectionsWithoutKillingWhileLoop = Get-NetTCPConnection | Where-Object -FilterScript { $_.OwningProcess -eq $PID -and $_.RemotePort -eq '443' -and $_.State -ne 'Established' }
                        if (-not $CheckConnectionsWithoutKillingWhileLoop) {
                            Write-Verbose -Message "Connections have closed.  Waiting 5 more seconds..."
                            Start-Sleep -seconds 5
                            $PowerShellConnections = Get-NetTCPConnection | Where-Object -FilterScript { $_.OwningProcess -eq $PID -and $_.RemotePort -eq '443' -and $_.State -ne 'Established' }
                        }
                    }
                    $VerbosePreference = 'SilentlyContinue'
                    $Global:ExchangeOnlineSession = $null
                    while (-not $Global:ExchangeOnlineSession)
                    {
                        $Global:ExchangeOnlineSession = New-PSSession -Name 'ExchangeOnline' -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $GlobalAdminAccount -Authentication Basic -AllowRedirection -ErrorAction SilentlyContinue
                    }

                    $Global:ExchangeOnlineModules = Import-PSSession $Global:ExchangeOnlineSession -AllowClobber -ErrorAction SilentlyContinue

                    $ExchangeOnlineModuleImport = Import-Module $ExchangeOnlineModules -Global -ErrorAction SilentlyContinue
                }
                catch
                {
                    $VerbosePreference = 'SilentlyContinue'
                    $WarningPreference = "SilentlyContinue"
                    $Global:ExchangeOnlineSession = $null
                    Close-SessionsAndReturnError -ExceptionMessage $_.Exception
                    $Message = "Can't open Exchange Online session from Connect-ExchangeOnline"
                    New-Office365DSCLogEntry -Error $_ -Message $Message
                }
            }
            else
            {
                Write-Verbose $_.Exception
                $VerbosePreference = 'SilentlyContinue'
                Get-PSSession -Name 'ExchangeOnline' -ErrorAction SilentlyContinue | Remove-PSSession
                Write-Verbose -Message "Exchange Online connection failed."
                Write-Verbose -Message "Waiting 60 seconds..."
                Start-Sleep -Seconds 60
                try
                {
                    Write-Verbose -Message "Opening New ExchangeOnline Session."
                    $VerbosePreference = 'SilentlyContinue'
                    Get-PSSession -Name 'ExchangeOnline' -ErrorAction SilentlyContinue | Remove-PSSession -ErrorAction SilentlyContinue
                    $Global:ExchangeOnlineSession = New-PSSession -Name 'ExchangeOnline' -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $GlobalAdminAccount -Authentication Basic -AllowRedirection
                    $Global:ExchangeOnlineModules = Import-PSSession $Global:ExchangeOnlineSession -AllowClobber -ErrorAction SilentlyContinue

                    $ExchangeOnlineModuleImport = Import-Module $ExchangeOnlineModules -Global -ErrorAction SilentlyContinue
                }
                catch
                {
                    $VerbosePreference = 'SilentlyContinue'
                    $WarningPreference = "SilentlyContinue"
                    $Global:ExchangeOnlineSession = $null
                    Close-SessionsAndReturnError -ExceptionMessage $_.Exception
                }
            }
        }
    }
    else
    {
        Write-Verbose -Message "Using Existing ExchangeOnline Session."
        $Global:OpenExchangeSession = Get-PSSession -Name 'ExchangeOnline' -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.State -eq 'Opened' }
        $VerbosePreference = 'SilentlyContinue'
        $WarningPreference = "SilentlyContinue"
    }
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
                else {
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

function Test-SPOServiceConnection
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SPOCentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $VerbosePreference = 'SilentlyContinue'
    $WarningPreference = "SilentlyContinue"
    Write-Verbose -Message "Verifying the LCM connection state to SharePoint Online"
    Test-MSCloudLogin -Platform SharePointOnline -o365Credential $GlobalAdminAccount
}

function Test-PnPOnlineConnection
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $VerbosePreference = 'SilentlyContinue'
    $WarningPreference = "SilentlyContinue"
    Write-Verbose -Message "Verifying the LCM connection state to SharePoint Online with PnP"
    Connect-PnpOnline -Url $SiteUrl -Credential $GlobalAdminAccount
}

function Test-O365ServiceConnection
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $VerbosePreference = 'SilentlyContinue'
    $WarningPreference = "SilentlyContinue"
    Write-Verbose -Message "Verifying the LCM connection state to Microsoft Azure Active Directory Services"
    Test-MSCloudLogin -Platform AzureAD -o365Credential $GlobalAdminAccount
    Test-MSCloudLogin -Platform MSOnline -o365Credential $GlobalAdminAccount
}

function Test-TeamsServiceConnection
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $VerbosePreference = 'SilentlyContinue'
    $WarningPreference = "SilentlyContinue"
    Import-Module MicrosoftTeams -Force | Out-Null
    Write-Verbose -Message "Verifying the LCM connection state to Teams"
    Test-MSCloudLogin -Platform MicrosoftTeams -o365Credential $GlobalAdminAccount | Out-Null
}

function Test-SecurityAndComplianceConnection
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $VerbosePreference = 'SilentlyContinue'
    $WarningPreference = "SilentlyContinue"

    $Global:SessionSecurityCompliance = Get-PSSession | Where-Object{$_.ComputerName -like "*.ps.compliance.protection.outlook.com"}
    if ($null -eq $Global:SessionSecurityCompliance)
    {
        Write-Verbose -Message "Session to Security & Compliance already exists, re-using existing session"
        $Global:SessionSecurityCompliance = New-PSSession -ConfigurationName "Microsoft.Exchange" `
            -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ `
            -Credential $GlobalAdminAccount `
            -Authentication Basic `
            -AllowRedirection

        $Global:SCModule = Import-PSSession $Global:SessionSecurityCompliance  `
            -ErrorAction SilentlyContinue `
            -AllowClobber

        Import-Module $Global:SCModule -Global | Out-Null
    }
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

        [Parameter(, Position = 3)]
        [Array]
        $ValuesToCheck
    )
    $VerbosePreference = 'SilentlyContinue'
    $WarningPreference = "SilentlyContinue"
    $returnValue = $true

    if (($DesiredValues.GetType().Name -ne "HashTable") `
            -and ($DesiredValues.GetType().Name -ne "CimInstance") `
            -and ($DesiredValues.GetType().Name -ne "PSBoundParametersDictionary"))
    {
        throw ("Property 'DesiredValues' in Test-SPDscParameterState must be either a " + `
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
                    $CheckDesiredValue = Test-SPDSCObjectHasProperty -Object $DesiredValues -PropertyName $_
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
                            $returnValue = $false
                        }
                        else
                        {
                            $arrayCompare = Compare-Object -ReferenceObject $CurrentValues.$fieldName `
                                -DifferenceObject $DesiredValues.$fieldName
                            if ($null -ne $arrayCompare)
                            {
                                Write-Verbose -Message ("Found an array for property $fieldName " + `
                                        "in the current values, but this array " + `
                                        "does not match the desired state. " + `
                                        "Details of the changes are below.")
                                $arrayCompare | ForEach-Object -Process {
                                    Write-Verbose -Message "$($_.InputObject) - $($_.SideIndicator)"
                                }
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
                                    $returnValue = $false
                                }
                            }
                            default
                            {
                                Write-Verbose -Message ("Unable to compare property $fieldName " + `
                                        "as the type ($($desiredType.Name)) is " + `
                                        "not handled by the " + `
                                        "Test-SPDscParameterState cmdlet")
                                $returnValue = $false
                            }
                        }
                    }
                }
            }
        }
    }
    return $returnValue
}

function Get-UsersLicenses
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    Write-Verbose -Message "Store all users licenses information in Global Variable for future usage."

    #Store information to be able to check later if the users is correctly licensed for features.
    if ($null -eq $Global:UsersLicenses)
    {
        $Global:UsersLicenses = Get-MsolUser -All | Select-Object UserPrincipalName, isLicensed, Licenses
    }
    Return $Global:UsersLicenses
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
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    if (-not $Quiet)
    {
        Show-O365GUI -Path $Path
    }
    else
    {
        Start-O365ConfigurationExtract -GlobalAdminAccount $GlobalAdminAccount `
                                       -AllComponents `
                                       -Path $Path
    }
}

function Compare-SPOTheme
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object]
        $existingThemePalette,
        [Parameter(Mandatory = $true)]
        [System.Object]
        $configThemePalette
    )

    $existingThemePalette = $existingThemePalette.GetEnumerator() | Sort-Object -Property Name
    $configThemePalette = $configThemePalette.GetEnumerator() | Sort-Object -Property Name

    $existingThemePaletteCount = 0
    $configThemePaletteCount = 0

    foreach($val in $existingThemePalette.Value)
    {
        if($configThemePalette.Value.Contains($val))
        {
            $configThemePaletteCount++
        }
    }

    foreach($val in $configThemePalette.Value)
    {
        if($existingThemePalette.value.Contains($val))
        {
            $existingThemePaletteCount++
        }
    }

    if(($existingThemePalette.Count -eq $configThemePaletteCount) -and ($configThemePalette.Count -eq $existingThemePaletteCount))
    {
        return "Themes are identical"
    }
    else
    {
        return "Themes are not identical"
    }
}

function Get-SPOAdministrationUrl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [switch]
        $UseMFA,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    if ($UseMFA)
    {
        $UseMFASwitch = @{UseMFA = $true}
    }
    else
    {
        $UseMFASwitch = @{}
    }
    Write-Verbose -Message "Connection to Azure AD is required to automatically determine SharePoint Online admin URL..."
    Test-MSCloudLogin -Platform "AzureAD" -o365Credential $GlobalAdminAccount | Out-Null
    Write-Verbose -Message "Getting SharePoint Online admin URL..."
    $defaultDomain = Get-AzureADDomain | Where-Object {$_.Name -like "*.onmicrosoft.com" -and $_.IsInitial -eq $true} # We don't use IsDefault here because the default could be a custom domain
    $global:tenantName = $defaultDomain[0].Name -replace ".onmicrosoft.com",""
    $global:AdminUrl = "https://$global:tenantName-admin.sharepoint.com"
    Write-Verbose -Message "SharePoint Online admin URL is $global:AdminUrl"
    return $global:AdminUrl
}
