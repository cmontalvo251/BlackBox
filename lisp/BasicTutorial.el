;;Basic Arithmetic
(+ 3 4)
(- 9 3)
(+ 4 5 2)
(* 2 3)
(/ 7 2) ;3
(/ 7 2.0) ;3.5
(% 7 4) ;;mod function


;printing
(message "hi")
(message "Her age is: %d " 16)
(message "Her name is: %s " "Laura")

;;test for integers or floats
(floatp 3.)  ;returns nil
(floatp 3.0) ;return true

;boolean stuff
(and t nil) ;;returns nil which means false
(or t nil) ;;returns t which means true

;comparing numbers
(< 3 4)
(>= 3 4)

;compare strings
(string= "this" "this")

;test data type
(equal "a" "a")
(equal 3 "a")

;test lists
(equal '(3 4 5) '(3 4 5))

;test symbols
(equal 'abc 'abc)

;not equal

(not (= 3 4))
(not (equal 3 4))