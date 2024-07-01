;============================================================================
; Control for rule execution order
;============================================================================
(deffacts Control
	(RuleNumber -1)
)


(defrule IncrementRuleOrder (declare (salience -9999))
?f <-	(RuleNumber ?i&:(< ?i 10))
=>
	(retract ?f)
	(assert (RuleNumber (+ ?i 1)))
)

;============================================================================
; Rule to return results to C# at the end.
;============================================================================

(defrule ReturnResult (declare (salience -9999))
	(RuleNumber 10)
	(Field (RecordId ?recordId) (Name ?name) (Value ?value) (Select TRUE))
	(exists (Rule ? ? ?name $?))
=>
	(CallBackFunction "ReturnConsolidatedField" (str-cat ?recordId) (str-cat ?name) (str-cat ?value))
)

(defrule ReturnResultForFieldGroups-0 (declare (salience -9999))
	(RuleNumber 10)
	(FG ?name $? ?groupedFieldName $?)
	(Field (RecordId ?recordId) (Name ?name&~SubmittedDateTime) (Select TRUE))
	(Field (RecordId ?recordId) (Name ?groupedFieldName) (Value ?value))
=>
	(CallBackFunction "ReturnConsolidatedField" (str-cat ?recordId) (str-cat ?groupedFieldName) (str-cat ?value))
)

(defrule ReturnResultForFieldGroups-SecondaryFields (declare (salience -9999))
	(RuleNumber 10)
	(FG ?name $? ?groupedFieldName $?)
	(Field (RecordId ?recordId) (Name ?name&~SubmittedDateTime) (Select TRUE))
	(not (Field (RecordId ?recordId) (Name ?groupedFieldName)))
=>
	(CallBackFunction "ReturnConsolidatedField" (str-cat ?recordId) (str-cat ?groupedFieldName) "NIL")
)

(defrule ReturnResultForFieldGroups-SecondaryFieldsWhenNoNonBlankMainFieldExists (declare (salience -9999))
	(RuleNumber 10)
	(FG ?name $? ?groupedFieldName $?)
	(not (Field (RecordId ?recordId) (Name ?name&~SubmittedDateTime) (Value ?value&~""&~NIL)))
	(exists (Field (RecordId ?recordId) (Name ?groupedFieldName) (Value ?value&~""&~NIL)))
=>
	(CallBackFunction "ReturnConsolidatedField" "NIL" (str-cat ?groupedFieldName) "NIL")
)