function Invoke-OpenAiTextCompletion {
    [CmdletBinding()]
    param (
		[parameter(Mandatory=$true)]
        $Token,
		[parameter(Mandatory=$true)]
        $Model,
		[parameter(Mandatory=$true)]
        $Prompt,
		$Suffix,
        $MaxTokens,
        [ValidateRange(0, 1)]
        $Temperature = 0.75,
		$TopP,
		$N,
		$Stream,
		$LogProbs,
		$Echo,
		$Stop
    )

    begin {
        $headers = @{
            Authorization = "Bearer $token"
        }

        $body = @{
            model = $Model
            prompt = $Prompt
            temperature = $Temperature
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