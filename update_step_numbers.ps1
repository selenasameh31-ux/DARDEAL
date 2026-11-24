$folder = "lib\features\tabs(Home+Fav+AddProperty+Chat+Profile)\add_property\presentation\widgets"

$files = @(
    @{ name = "basic_info_step\basic_info_step.dart"; step = 1 },
    @{ name = "location_step\location_step.dart"; step = 2 },
    @{ name = "details_step\details_step.dart"; step = 3 },
    @{ name = "rules_step\rules_step.dart"; step = 4 },
    @{ name = "media_step\media_step.dart"; step = 5 },
    @{ name = "pricing_step\pricing_step.dart"; step = 6 },
    @{ name = "interior_step\interior_step.dart"; step = 7 },
    @{ name = "calendar_step\calendar_step.dart"; step = 8 },
    @{ name = "summary_step\summary_step.dart"; step = 9 }
)

foreach ($f in $files) {
    $path = Join-Path $folder $f.name
    if (Test-Path $path) {
        $content = Get-Content $path -Raw
        
        $oldStep = $f.step
        $newStep = $f.step + 1

        # Replace totalSteps: 9 -> totalSteps: 10
        $content = $content -replace "totalSteps:\s*9", "totalSteps: 10"
        
        # Replace currentStep: X -> currentStep: X+1
        $content = $content -replace "currentStep:\s*$oldStep", "currentStep: $newStep"
        
        # Replace step: X -> step: X+1 (for StepNavigationButtons)
        # Note: I already updated basic_info_step's step: 1 to step: 2 manually, so for file 1, I shouldn't replace step: 2 -> step: 3 accidentally.
        if ($oldStep -ne 1) {
            $content = $content -replace "step:\s*$oldStep,", "step: $newStep,"
        }

        Set-Content $path -Value $content -NoNewline
        Write-Host "Updated $($f.name) to step $newStep"
    } else {
        Write-Host "File not found: $path"
    }
}
