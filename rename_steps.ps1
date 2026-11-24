$widgetsPath = "lib\features\tabs(Home+Fav+AddProperty+Chat+Profile)\add_property\presentation\widgets"

$renames = @(
    @{ oldFolder = "step_one"; newFolder = "basic_info_step"; oldFile = "step_one_basic_info.dart"; newFile = "basic_info_step.dart" },
    @{ oldFolder = "step_two"; newFolder = "location_step"; oldFile = "step_two_location.dart"; newFile = "location_step.dart" },
    @{ oldFolder = "step_three"; newFolder = "details_step"; oldFile = "step_three_details.dart"; newFile = "details_step.dart" },
    @{ oldFolder = "step_four"; newFolder = "rules_step"; oldFile = "step_four_amenities.dart"; newFile = "rules_step.dart" },
    @{ oldFolder = "step_five"; newFolder = "media_step"; oldFile = "step_five_images.dart"; newFile = "media_step.dart" },
    @{ oldFolder = "step_six"; newFolder = "pricing_step"; oldFile = "step_six_listing_style.dart"; newFile = "pricing_step.dart" },
    @{ oldFolder = "step_seven"; newFolder = "interior_step"; oldFile = "step_seven_property_interior.dart"; newFile = "interior_step.dart" },
    @{ oldFolder = "step_eight"; newFolder = "calendar_step"; oldFile = "step_eight_availability_calendar.dart"; newFile = "calendar_step.dart" },
    @{ oldFolder = "step_nine"; newFolder = "summary_step"; oldFile = "step_nine_summary.dart"; newFile = "summary_step.dart" }
)

foreach ($r in $renames) {
    $oldFolderPath = Join-Path $widgetsPath $r.oldFolder
    $newFolderPath = Join-Path $widgetsPath $r.newFolder

    Write-Host "Renaming folder from $( $r.oldFolder ) to $( $r.newFolder )"
    if (Test-Path $oldFolderPath) {
        Rename-Item -Path $oldFolderPath -NewName $r.newFolder
    }

    $oldFilePath = Join-Path $newFolderPath $r.oldFile
    $newFilePath = Join-Path $newFolderPath $r.newFile

    Write-Host "Renaming file from $( $r.oldFile ) to $( $r.newFile )"
    if (Test-Path $oldFilePath) {
        Rename-Item -Path $oldFilePath -NewName $r.newFile
    }
}
Write-Host "Done"
