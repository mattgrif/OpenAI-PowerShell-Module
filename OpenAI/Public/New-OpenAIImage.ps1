function New-OpenAiImage {
    [CmdletBinding()]
    param (
		[parameter(Mandatory=$true)]
        $Prompt,
        $Number,
        #[ValidateSetAttribute("256x256","512x512","1024x1024")]
		$Size,
        #[ValidateSetAttribute("url","b64_json")]
        $ResponseFormat
		# $TopP, These Parameters have yet to be implemented.
		# $N,
		# $Stream,
		# $LogProbs,
		# $Echo,
		# $Stop
    )

    begin {
        #Read API Key
        $secureToken = [Environment]::GetEnvironmentVariable('OpenAiToken', 'User')

        if(![string]::IsNullOrEmpty($secureToken)) {
            $cred = New-Object pscredential 'fakeuser', (ConvertTo-SecureString $secureToken)
            $plainToken = $cred.Password | ConvertFrom-SecureString -AsPlainText
        } else {
            Write-Output "You must save your OpenAI Connection String before continuing."
            Save-OpenAiConnection

            #Now read newly saved token
            $cred = New-Object pscredential 'fakeuser', (ConvertTo-SecureString [Environment]::GetEnvironmentVariable('OpenAiToken', 'User'))
            $plainToken = $cred.Password | ConvertFrom-SecureString -AsPlainText
        }

        #Build the Header API Call
        $headers = @{
            Authorization = "Bearer $plainToken"
        }

        #Build base body for required Parameters
        $body = @{
            prompt = $Prompt
        }

        #Add Optional Parameters to the body
        if(![string]::IsNullOrEmpty($Number)){
            #n Optional Parameter
            $body += @{
                n = $Number
            }
        }

        #Add Optional Parameters to the body
        if(![string]::IsNullOrEmpty($Size)){
            #Size Optional Parameter
            $body += @{
                size = $Size
            }
        }

    }

    process {
        $uri = 'https://api.openai.com/v1/images/generations'

        $output = Invoke-RestMethod -Method POST -Uri $uri -ContentType 'application/json' -Headers $headers -Body ($body | ConvertTo-Json -Depth 5)
    }

    end {
        return $output
    }
}