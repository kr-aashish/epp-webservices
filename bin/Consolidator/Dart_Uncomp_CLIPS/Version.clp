; Inspirata 2022 					
; Site: Abrevio Dartmouth	     					   			
; Dartmouth Consolidation Rules					       			
; Note: Use for Dartmouth Abrevio 								
;       Update the major/minor release number if and only if the interface of the call-back function has changed.
;       Otherwise, the Dartmouth consolidation C# module will fail the compatibility check.

;=========== Return CLIPS version ===========
(defrule ReturnClipsInfo
    (return-clips-info)
=>
    (CallBackFunction CLIPS_INFO "1.1.79.1")
)
