function Invoke-OpenAiTextCompletion {
    [CmdletBinding()]
    param (
		[parameter(Mandatory=$true)]
        $Prompt,
        $Model,
		# $Suffix, These Parameters have yet to be implemented.
        $MaxTokens
        # [ValidateRange(0, 1)]
        # $Temperature = 0.75,
		# $TopP,
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

        #Check for Model Param, read global setting if not set
        if([string]::IsNullOrEmpty($Model)) {
            $Model = [Environment]::GetEnvironmentVariable('OpenAiModel', 'User')
        }

        #Build the Header API Call
        $headers = @{
            Authorization = "Bearer $plainToken"
        }

        #Build base body for required Parameters
        $body = @{
            model = $Model
            prompt = $Prompt
            #temperature = $Temperature
        }

        #Add Optional Parameters to the body
        if(![string]::IsNullOrEmpty($MaxTokens)){
            #Max_Tokens Optional Parameter
            $body += @{
                max_tokens = $MaxTokens
            }
        }

    }

    process {
        $uri = 'https://api.openai.com/v1/completions'

        $output = Invoke-RestMethod -Method POST -Uri $uri -ContentType 'application/json' -Headers $headers -Body ($body | ConvertTo-Json -Depth 5)
    }

    end {
        return $output
    }
}