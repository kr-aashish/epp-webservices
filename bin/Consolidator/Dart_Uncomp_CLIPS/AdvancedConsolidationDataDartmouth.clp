
;============================================================================
; Rules for Date Of Diagnosis
;============================================================================
(deffacts DateOfDiagnosisRules
	(Rule DateCompleteOverIncomplete 0 DateOfDiagnosis DateOfDiagnosis)
	(Rule EarliestDate 1 DateOfDiagnosis DateOfDiagnosis)
)

;============================================================================
; Rules for Date of Last Contact
;============================================================================
(deffacts DateOfLastContactRules
	(Rule DateCompleteOverIncomplete 0 DateOfLastContact DateOfLastContact)
	(Rule LatestDate 1 DateOfLastContact DateOfLastContact)
)

;============================================================================
