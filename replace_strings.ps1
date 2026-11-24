$replacements = @(
    @{ old = "step_one/step_one_basic_info.dart"; new = "basic_info_step/basic_info_step.dart" },
    @{ old = "step_one/"; new = "basic_info_step/" },
    @{ old = "step_two/step_two_location.dart"; new = "location_step/location_step.dart" },
    @{ old = "step_two/"; new = "location_step/" },
    @{ old = "step_three/step_three_details.dart"; new = "details_step/details_step.dart" },
    @{ old = "step_three/"; new = "details_step/" },
    @{ old = "step_four/step_four_amenities.dart"; new = "rules_step/rules_step.dart" },
    @{ old = "step_four/"; new = "rules_step/" },
    @{ old = "step_five/step_five_images.dart"; new = "media_step/media_step.dart" },
    @{ old = "step_five/"; new = "media_step/" },
    @{ old = "step_six/step_six_listing_style.dart"; new = "pricing_step/pricing_step.dart" },
    @{ old = "step_six/"; new = "pricing_step/" },
    @{ old = "step_seven/step_seven_property_interior.dart"; new = "interior_step/interior_step.dart" },
    @{ old = "step_seven/"; new = "interior_step/" },
    @{ old = "step_eight/step_eight_availability_calendar.dart"; new = "calendar_step/calendar_step.dart" },
    @{ old = "step_eight/"; new = "calendar_step/" },
    @{ old = "step_nine/step_nine_summary.dart"; new = "summary_step/summary_step.dart" },
    @{ old = "step_nine/"; new = "summary_step/" },
    @{ old = "StepOneBasicInfo"; new = "BasicInfoStep" },
    @{ old = "StepTwoLocation"; new = "LocationStep" },
    @{ old = "StepThreeDetails"; new = "DetailsStep" },
    @{ old = "StepFourAmenities"; new = "RulesStep" },
    @{ old = "StepFiveImages"; new = "MediaStep" },
    @{ old = "StepSixListingStyle"; new = "PricingStep" },
    @{ old = "StepSevenPropertyInterior"; new = "InteriorStep" },
    @{ old = "StepEightAvailabilityCalendar"; new = "CalendarStep" },
    @{ old = "StepNineSummary"; new = "SummaryStep" }
)

$files = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse

foreach ($file in $files) {
    if ($file.Extension -eq ".dart") {
        $content = Get-Content -Path $file.FullName -Raw
        $originalContent = $content
        $changed = $false

        foreach ($r in $replacements) {
            $escaped = [regex]::Escape($r.old)
            if ($content -match $escaped) {
                $content = [regex]::Replace($content, $escaped, $r.new)
                $changed = $true
            }
        }

        if ($changed) {
            Write-Host "Updating $($file.FullName)"
            Set-Content -Path $file.FullName -Value $content -NoNewline
        }
    }
}
Write-Host "Done replacements"
