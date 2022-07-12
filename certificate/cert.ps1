$number = Read-Host -Prompt 'Input 1 - install to Current User, 2 -delete from Current User, 3 - install to Local Machine, 4 -delete from Local Machine, 5 -delete from All'

#maybe you need change it
$delTag = 'Unified State Internet Access Gateway'
$p7b = "Unified_State_Internet_Access_Gateway.cer"
$source = "https://sts.kz/wp-content/uploads/2021/05/Unified_State_Internet_Access_Gateway.cer"
$destination = "Unified_State_Internet_Access_Gateway.cer"

function InstallCrt {
    Param($CrtPath)

    $curDir = Get-Location
    Invoke-WebRequest -Uri $source -OutFile "$curDir\$destination"
    Import-Certificate -FilePath $p7b -CertStoreLocation Cert:\$CrtPath\Root
}

function DeleteCrt {
    Param($CrtPath)

    Get-ChildItem Cert:\$CrtPath\Root | Where-Object { $_.Subject -match $delTag } | Remove-Item -Force
}

switch ( $number )
    {
        1 { InstallCrt -CrtPath CurrentUser }
        2 { DeleteCrt -CrtPath CurrentUser   }
        3 { InstallCrt -CrtPath LocalMachine }
        4 { DeleteCrt -CrtPath LocalMachine    }
        5 { 
            DeleteCrt -CrtPath CurrentUser
            DeleteCrt -CrtPath LocalMachine
        }
	}
