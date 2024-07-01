;============================================================================
; Template Definitions
;============================================================================
; A field represent one field from the source record.
(deftemplate Field
	(slot RecordId)             ; Unique ID for the source record
	(slot Name)                 ; Field name (i.e. Aboriginality)
	(slot Value)                ; Value
	(slot Select (default TRUE)); Indicates whether or not the field value will be used for consolidated data
)

; Information about the hierarchy for the applicable fields
(deftemplate Hierarchy
	(slot Name)     ; Field name
	(slot Code)     ; Value of the field
	(multislot CodeRange)
	(slot Priority) ; Priority - lower the number the higher priority
)
