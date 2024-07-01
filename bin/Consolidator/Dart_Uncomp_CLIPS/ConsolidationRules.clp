;============================================================================
; Rules for Missing Consolidation
;============================================================================
; Function to convert date format from DDMMYYYY to YYYYMMDD
(deffunction ConvertDate(?value)
   (if (and (< 1231 (mod ?value 10000))              ; Validate Year
            (<= (div (mod ?value 1000000) 10000) 12) ; Validate Month
       )
    then (return (+ (div ?value 1000000)                     ; Date Component
                    (* (div (mod ?value 1000000) 10000) 100) ; Month Component
                    (* (mod ?value 10000) 10000)             ; Year Component
         )       )
    else (return ?value)
)  )

;============================================================================
; Rules for Hierarchy, either singular code or coderange, either integer or string
; Set the value with lower priority to False
;============================================================================

(defrule Hierarchy-N
     (RuleNumber ?ruleNumber)
     (Rule Hierarchy ?ruleNumber ?fieldName ?hierarchyFieldName)
?f <-(Field (RecordId ?id-1) (Name ?fieldName) (Value ?value-1) (Select TRUE))
     (Field (RecordId ?id-1) (Name ?hierarchyFieldName) (Value ?code-1&:(numberp ?code-1)))
	 (Hierarchy (Name ?hierarchyFieldName) (CodeRange ?lower1 &:(<= ?lower1 ?code-1) ?upper1 &:(>= ?upper1 ?code-1)) (Priority ?p))
		(or (exists (Field (RecordId ?id-2&~?id-1) (Name ?fieldName) (Value ?value-2) (Select TRUE))
					(Field (RecordId ?id-2) (Name ?hierarchyFieldName) (Value ?code-2&~?code-1&~NIL&:(numberp ?code-2))) 
					(Hierarchy (Name ?hierarchyFieldName) (CodeRange ?lower2 &:(<= ?lower2 ?code-2) ?upper2 &:(>= ?upper2 ?code-2))(Priority ?ps&:(< ?ps ?p))))
						
			(exists (Field (RecordId ?id-2&~?id-1) (Name ?fieldName) (Value ?value-2) (Select TRUE) )
					(Field (RecordId ?id-2)        (Name ?hierarchyFieldName) (Value ?code-2&~?code-1&~NIL)) 
					(Hierarchy (Name ?hierarchyFieldName) (Code ?code-2)(Priority ?ps&:(< ?ps ?p)))))
					
=>
     (modify ?f (Select FALSE))
)

;============================================================================
; The blank and NIL values of all fields used in the consolidation process is of the least priority.
; This rule will run for all field+rule combinations except for hierarchy rules.
;============================================================================

(defrule AdvancedConsolidation-Disable-If-Nil
     (RuleNumber ?ruleNumber)
     (Rule ?ruleName&~Hierarchy ?ruleNumber ?fieldName1 ?fieldName2)
?f <-(Field (RecordId ?id-1) (Name ?fieldName1) (Select TRUE))
     (or (Field (RecordId ?id-1) (Name ?fieldName2) (Value NIL|""))
		 (not (Field (RecordId ?id-1) (Name ?fieldName2))))
     (exists 
		(Field (RecordId ?id-2&~?id-1) (Name ?fieldName1) (Select TRUE))
		(Field (RecordId ?id-2) (Name ?fieldName2) (Value ?value-2&~NIL&~"")))
=>
     (modify ?f (Select FALSE))
)

;============================================================================

(defrule Hierarchy-S
     (RuleNumber ?ruleNumber)
     (Rule Hierarchy ?ruleNumber ?fieldName ?hierarchyFieldName)
?f <-(Field (RecordId ?id-1) (Name ?fieldName) (Value ?value-1) (Select TRUE))
     (Field (RecordId ?id-1) (Name ?hierarchyFieldName) (Value ?code-1&~NIL))
	 (Hierarchy (Name ?hierarchyFieldName) (Code ?code-1) (Priority ?p))

		(or (exists (Field (RecordId ?id-2&~?id-1) (Name ?fieldName) (Value ?value-2) (Select TRUE))
					(Field (RecordId ?id-2) (Name ?hierarchyFieldName) (Value ?code-2&~?code-1&~NIL&:(numberp ?code-2))) 
					(Hierarchy (Name ?hierarchyFieldName) (CodeRange ?lower2 &:(<= ?lower2 ?code-2) ?upper2 &:(>= ?upper2 ?code-2))(Priority ?ps&:(< ?ps ?p))))
						
			(exists (Field (RecordId ?id-2&~?id-1) (Name ?fieldName) (Value ?value-2) (Select TRUE) )
					(Field (RecordId ?id-2) 	   (Name ?hierarchyFieldName) (Value ?code-2&~?code-1&~NIL)) 
					(Hierarchy (Name ?hierarchyFieldName) (Code ?code-2)(Priority ?ps&:(< ?ps ?p)))))
					
=>
     (modify ?f (Select FALSE))
)

;============================================================================
; Set the value NOT in the hierarchy table to False
;============================================================================
(defrule Hierarchy-RemoveInvalidCodes-N
        (RuleNumber ?ruleNumber)
		(Rule Hierarchy ?ruleNumber ?fieldName ?hierarchyFieldName)
?f <-	(Field (RecordId ?id-1) (Name ?fieldName) (Value ?value-1) (Select TRUE))
        (Field (RecordId ?id-1) (Name ?hierarchyFieldName) (Value ?code-1&:(numberp ?code-1))) 
		(or (exists (Field (RecordId ?id-2&~?id-1) (Name ?fieldName) (Value ?value-2) (Select TRUE))
					(Field (RecordId ?id-2) (Name ?hierarchyFieldName) (Value ?code-2&~?code-1&~NIL&:(numberp ?code-2))) 
					(Hierarchy (Name ?hierarchyFieldName) (CodeRange ?lower2 &:(<= ?lower2 ?code-2) ?upper2 &:(>= ?upper2 ?code-2))))
						
			(exists (Field (RecordId ?id-2&~?id-1) (Name ?fieldName) (Value ?value-2) (Select TRUE) )
					(Field (RecordId ?id-2) 	   (Name ?hierarchyFieldName) (Value ?code-2&~?code-1&~NIL)) 
					(Hierarchy (Name ?hierarchyFieldName) (Code ?code-2))))
        (not (Hierarchy (Name ?hierarchyFieldName) (Code ?code-1)))
        (not (Hierarchy (Name ?hierarchyFieldName) (CodeRange ?lower1 &:(<= ?lower1 ?code-1) ?upper1 &:(>= ?upper1 ?code-1))))
=>
      (modify ?f (Select FALSE))
)

;============================================================================

(defrule Hierarchy-RemoveInvalidCodes-S
        (RuleNumber ?ruleNumber)
		(Rule Hierarchy ?ruleNumber ?fieldName ?hierarchyFieldName)
?f <-	(Field (RecordId ?id-1) (Name ?fieldName) (Value ?value-1) (Select TRUE))
        (Field (RecordId ?id-1) (Name ?hierarchyFieldName) (Value ?code-1&~:(numberp ?code-1)))
		(or (exists (Field (RecordId ?id-2&~?id-1) (Name ?fieldName) (Value ?value-2) (Select TRUE))
					(Field (RecordId ?id-2) (Name ?hierarchyFieldName) (Value ?code-2&~?code-1&~NIL&:(numberp ?code-2))) 
					(Hierarchy (Name ?hierarchyFieldName) (CodeRange ?lower2 &:(<= ?lower2 ?code-2) ?upper2 &:(>= ?upper2 ?code-2))))
						
			(exists (Field (RecordId ?id-2&~?id-1) (Name ?fieldName) (Value ?value-2) (Select TRUE) )
					(Field (RecordId ?id-2) 	   (Name ?hierarchyFieldName) (Value ?code-2&~?code-1&~NIL)) 
					(Hierarchy (Name ?hierarchyFieldName) (Code ?code-2))))
        (not (Hierarchy (Name ?hierarchyFieldName) (Code ?code-1)))
=>
      (modify ?f (Select FALSE))
)

;============================================================================
; Rules for Last Submitted
;============================================================================
; The assumption is that the RecordId for the later submission date is always bigger than the RecordId for the earlier submission date. Therefore it ;is adequate just to compare the recordId instead of Submission Date (as the Date does not have the time component, thus in case of two records ;having the same submission date, the RecordId is more accurate to verify the submission time).

(defrule LastSubmitted
	(Rule LastSubmitted ?ruleNumber ?fieldName)
	(RuleNumber ?ruleNumber)
	(Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName)		(Value ?result))
?f <-	(Field (RecordId ?id-2&~?id-1)	(Select TRUE) (Name ?fieldName))
    (test (< ?id-2  ?id-1))
	
=>
	(modify ?f (Select FALSE))
)

;============================================================================
; Rules for First Submitted
;============================================================================

(defrule FirstSubmitted
	(Rule FirstSubmitted ?ruleNumber ?fieldName)
	(RuleNumber ?ruleNumber)
	(Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName)	(Value ?result))
?f <-	(Field (RecordId ?id-2&~?id-1)	(Select TRUE) (Name ?fieldName))
    (test (> ?id-2  ?id-1))

=>
	(modify ?f (Select FALSE))
)

;============================================================================
; Rules for Non-Blank           
;============================================================================
;This rule replaces the blank values with non-blank values if available.

(defrule NonBlank-1 
;;	(Rule NonBlank ?ruleNumber ?fieldName)
	(RuleNumber -1)
	?f <-(Field (RecordId ?id) (Name ?fieldName) (Value ""|NIL) (Select TRUE))
=>
	(modify ?f (Select FALSE))
;;	(retract ?f )
)

;============================================================================
; Rules for Earliest Date
;============================================================================
(defrule EarliestDate
	(Rule EarliestDate ?ruleNumber ?fieldName ?dateFieldName)
	(RuleNumber ?ruleNumber)
	(Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName)	(Value ?result))
?f <-	(Field (RecordId ?id-2&~?id-1)	(Select TRUE) (Name ?fieldName))
	(Field (RecordId ?id-1)		(Select TRUE) (Name ?dateFieldName)	(Value ?earlierDate))
	(Field (RecordId ?id-2)		(Select TRUE) (Name ?dateFieldName)	(Value ?laterDate&:(>  (ConvertDate ?laterDate) (ConvertDate ?earlierDate))))
=>
	(modify ?f (Select FALSE))
)

;============================================================================
; Rules for Latest Date
;============================================================================
(defrule LatestDate
    (RuleNumber ?ruleNumber)
	(Rule LatestDate ?ruleNumber ?fieldName ?dateFieldName)
	(Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName)	(Value ?result))
?f <-	(Field (RecordId ?id-2&~?id-1)	(Select TRUE) (Name ?fieldName))
	(Field (RecordId ?id-1)		(Select TRUE) (Name ?dateFieldName)	(Value ?earlierDate))
	(Field (RecordId ?id-2)		(Select TRUE) (Name ?dateFieldName)	(Value ?laterDate&:(< (ConvertDate ?laterDate) (ConvertDate ?earlierDate))))
=>
	(modify ?f (Select FALSE))
)

;============================================================================
; Rules for Max     
;============================================================================
(defrule Max
	(Rule Max ?ruleNumber ?fieldName ?maxFiledName)
	(RuleNumber ?ruleNumber)
	(Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName) (Value ?v1)	)
?f <-	(Field (RecordId ?id-2&~?id-1)	(Select TRUE) (Name ?fieldName) (Value ?v2))
	(Field (RecordId ?id-1)	 (Name ?maxFiledName)	(Value ?GreaterValue &: (numberp ?GreaterValue)))
    (Field (RecordId ?id-2&~?id-1) (Name ?maxFiledName)(Value ?SmallerValue &: (numberp ?SmallerValue)  &:(< ?SmallerValue ?GreaterValue)))
	
=>
	(modify ?f (Select FALSE)) 
)

;============================================================================
; Rules for Most Frequent  
;============================================================================
;This rule finds the most frequent value(s) for the field across all records. 
(defrule MostFrequent-0
	; (RuleNumber ?ruleNumber)
	(Rule MostFrequent ?ruleNumber ?fieldName ?frequentFieldName)
	(Field (RecordId ?id-1)	(Select TRUE) (Name ?frequentFieldName)	(Value ?v1))
	(not (MostFrequentCounter ?frequentFieldName ?v1 ?c1))
=>    
	(assert (MostFrequentCounter ?frequentFieldName ?v1 0) )
)

(defrule MostFrequent-1
	;(RuleNumber ?ruleNumber)
	(Rule MostFrequent ?ruleNumber ?fieldName ?frequentFieldName)
	(Field (RecordId ?id-1)		(Select TRUE) (Name ?frequentFieldName)	(Value ?v1)) 
=>    
	(assert (MostFrequentTempField ?frequentFieldName ?v1))
)

(defrule MostFrequent-2
	?t <- (MostFrequentTempField ?frequentFieldName ?v1)
	?f <- (MostFrequentCounter ?frequentFieldName ?v1 ?c1)
=>
	(assert (MostFrequentCounter ?frequentFieldName ?v1 (+ ?c1 1) ))
	(retract ?f)
	(retract ?t)
)	

(defrule MostFrequent-3
          (RuleNumber ?ruleNumber)
          (RuleMostFrequent 1)
		  (Rule MostFrequent ?ruleNumber ?fieldName ?frequentFieldName)
   ?f <-  (Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName)	(Value ?v1))
          (MostFrequentCounter ?frequentFieldName ?v1 ?c1)
		  (exists (Field (RecordId ?id-2&~?id-1)		(Select TRUE) (Name ?fieldName)	(Value ?v2&~?v1))
		          (MostFrequentCounter ?frequentFieldName ?v2 ?c2&:(> ?c2 ?c1))
		  )
=> 
        (modify ?f (Select FALSE) )	 
)	

(deffacts Control-Frequency
	(RuleMostFrequent 0)
) 
 
(defrule IncrementFrequencyRule (declare (salience -9000))
?f <-	(RuleMostFrequent ?i&:(< ?i 1))
=>
	(retract ?f)
	(assert (RuleMostFrequent (+ ?i 1)))
)

;============================================================================
; Rules for Date Complete Over Incomplete      
;============================================================================
;This rule choses the date which has month/day component over one without month/day component (VCR assumes that unknow month/day will be given as ;0101 (i.e.,yyyy0101))   

(defrule DateCompleteOverIncomplete
    (RuleNumber ?ruleNumber)
	(Rule DateCompleteOverIncomplete ?ruleNumber ?fieldName ?dateFieldName)
	?f  <-   (Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName)	(Value ?v)) 
	(or (exists (Field (RecordId ?id-1)		(Select TRUE) (Name ?dateFieldName)	(Value ?incompleteDate &: (numberp ?incompleteDate) &:  (= (mod (ConvertDate ?incompleteDate) 10000) 0101 )
	))
	
	     (Field (RecordId ?id-2&~?id-1)		(Select TRUE) (Name ?fieldName)) 
	     (Field (RecordId ?id-2)		(Select TRUE) (Name ?dateFieldName)	(Value ?completeDate &: (numberp ?completeDate)   &:(>  (mod (ConvertDate ?completeDate) 10000) 0101)
		 ))
	)
	(exists (Field (RecordId ?id-1)		(Select TRUE) (Name ?dateFieldName)	(Value ?incompleteDate2 &: (numberp ?incompleteDate2) &:(= (mod (ConvertDate ?incompleteDate2) 100) 01 )
	
	))
	     (Field (RecordId ?id-2&~?id-1)		(Select TRUE) (Name ?fieldName)) 
	     (Field (RecordId ?id-2)		(Select TRUE) (Name ?dateFieldName)	(Value ?completeDate2 &: (numberp ?completeDate2)   &:(>  (mod (ConvertDate ?completeDate2) 100) 01)
		 ))
	)
	)
	
=>
	(modify ?f (Select FALSE)) 

)   


;============================================================================
; Rules for Specific
;============================================================================

; This rule assumes that the non-blank rules have already disabled or removed all fields with blank values.
(defrule Specific
	(RuleNumber ?ruleNumber)
	(Rule Specific ?ruleNumber ?fieldName)
	?f <-   (Field (RecordId ?id-1)       (Select TRUE)(Name ?fieldName)(Value ?v1&:(not (numberp ?v1))&:(<= (str-length ?v1) 1))) 
	(exists (Field (RecordId ?id-2&~?id-1)(Select TRUE)(Name ?fieldName)(Value ?v2&:(not (numberp ?v2))&:(>  (str-length ?v2) 1))))
=>
	(modify ?f (Select FALSE)) 
)

;============================================================================
; Street Address over PO Box
;============================================================================

(defrule StreetAddressOverPOBox
	(RuleNumber ?ruleNumber)
	(Rule StreetAddressOverPOBox ?ruleNumber ?fieldName)
	?f <- (Field (RecordId ?id-1)(Select TRUE) (Name ?fieldName)	(Value ?v1&:(eq (CallBackFunction_Int IS_PO_BOX (str-cat ?v1)) 1))) 
	(exists (Field (RecordId ?id-2&~?id-1)(Select TRUE)(Name ?fieldName)(Value ?v2&:(eq (CallBackFunction_Int IS_PO_BOX (str-cat ?v2)) 0))))
=>
	(modify ?f (Select FALSE)) 
)


;============================================================================
; Rules for Neoadjuvant
;============================================================================
(defrule Neoadjuvant  
        (RuleNumber ?ruleNumber)
        (Rule Neoadjuvant ?ruleNumber ?fieldName)
 ?f <-  (Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName))
        (Field (RecordId ?id-1)  (Name NeoadjuvantTherapy) (Value "Y") )
		(exists (Field (RecordId ?id-2&~?id-1)		(Select TRUE) (Name ?fieldName))
		        (Field (RecordId ?id-2)  (Name NeoadjuvantTherapy)  (Value ""|NIL) ))
	=>
        (modify ?f (Select FALSE))	
)    

;============================================================================
; Rules for Non-blank Neoadjuvant
;============================================================================
(defrule NonBlankNeoadjuvant  
        (RuleNumber ?ruleNumber)
        (Rule NonBlankNeoadjuvant ?ruleNumber ?fieldName)
 ?f <-  (Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName))
        (Field (RecordId ?id-1)       (Name NeoadjuvantTherapy) (Value ""|NIL) )
		(exists (Field (RecordId ?id-2&~?id-1)		(Select TRUE) (Name ?fieldName))
		        (Field (RecordId ?id-2)    (Name NeoadjuvantTherapy)  (Value "Y") ))
	=>
        (modify ?f (Select FALSE))
		
)    


;============================================================================
; Rules for Not Noti
;============================================================================
; This rule is to ignore source records with the specified Notifier numbers (e.g., hospital notification) in case there are other sources available.
(defrule NotNoti
        (RuleNumber ?ruleNumber)
        (Rule NotNoti ?ruleNumber ?fieldName ?notiCode)
 ?f <-  (Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName)	(Value ?v1))
	    (Field (RecordId ?id-1)		(Select TRUE) (Name Noti)	(Value ?notiCode))
		(exists (Field (RecordId ?id-2&~id-1) (Select TRUE) (Name ?fieldName))
				(Field (RecordId ?id-2) (Name Noti) (Value ?notiCode2&~?notiCode)))
	=>
        (modify ?f (Select FALSE))	
)

;============================================================================
; Rules for Hist Over 8000
;============================================================================

(defrule HistOver8000
        (RuleNumber ?ruleNumber)
        (Rule HistOver8000 ?ruleNumber ?fieldName)
 ?f <-  (Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName)	(Value ?v1 &:(numberp ?v1)  &:(< ?v1 80010))) 
        (exists (Field (RecordId ?id-2&~id-1) (Select TRUE) (Name ?fieldName) (Value ?v2&~v1 &:(numberp ?v2)   &:(> ?v2 80009)))) 
	=>
        (modify ?f (Select FALSE))	
	   
)

;============================================================================
; Rules for Subsite Known over Unknown
;============================================================================

(defrule SubsiteKnownOverUnknown-UnknownSites (declare (salience -1))
        (RuleNumber ?ruleNumber)
        (Rule SubsiteKnownOverUnknown ?ruleNumber ?fieldName)
  ?f <- (Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName)	(Value ?v1&:(not (numberp ?v1))&:(eq (sub-string 4 4 ?v1) "9")))
        (exists (Field (RecordId ?id-2&~?id-1) (Select TRUE) (Name ?fieldName)	(Value ?v2&:(not (numberp ?v2))&:(neq  (sub-string 4 4 ?v2) "9")))) 
	=>
        (modify ?f (Select FALSE))	
)

(defrule SubsiteKnownOverUnknown-OverlappingSites (declare (salience -2))
        (RuleNumber ?ruleNumber)
        (Rule SubsiteKnownOverUnknown ?ruleNumber ?fieldName)
  ?f <- (Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName)	(Value ?v1&:(not (numberp ?v1))&:(eq (sub-string 4 4 ?v1) "8")))
        (exists (Field (RecordId ?id-2&~?id-1) (Select TRUE) (Name ?fieldName)	(Value ?v2&:(not (numberp ?v2))&:(neq  (sub-string 4 4 ?v2) "8")))) 
	=>
        (modify ?f (Select FALSE))	
)   

;============================================================================
; Rules for Notifier not BreastScreen
;============================================================================

;(defrule NotifierNotBreastScreen
;        (RuleNumber ?ruleNumber)
;        (Rule NotifierNotBreastScreen ?ruleNumber ?fieldName)
; ?f <-  (Field (RecordId ?id-1)		(Select TRUE) (Name ?fieldName))
;        (Field (RecordId ?id-1)     (Select TRUE)  (Name Noti)  (Value BreastScreen))
;		(exists (Field (RecordId ?id-2&~?id-1)		(Select TRUE) (Name ?fieldName)))
;		(not (Field (RecordId ?id-2)     (Select TRUE)  (Name Noti)  (Value BreastScreen) ))	   
;	=>
;        (modify ?f (Select FALSE))	
;)   
