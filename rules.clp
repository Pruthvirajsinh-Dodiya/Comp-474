

;; get user data
(defrule get-user-data
   ?f <- (ui-state (phase startup))
   =>
   (printout t "Enter experience level (beginner/intermediate/advanced): ")
   (bind ?exp (read))
   (printout t "Enter equipment (none/machine-only/full-gym): ")
   (bind ?equ (read))
   (printout t "Enter injury (none/shoulder/lower-back/knee): ")
   (bind ?inj (read))
   (assert (user-profile (experience ?exp) (available-equipment ?equ) (injury-status ?inj)))
   (retract ?f)
   (assert (ui-state (phase processing))))

;; excludes non-bodyweight exercises if equipment is None
(defrule filter-no-equipment
   (user-profile (available-equipment none))
   (exercise (name ?n) (equipment ~none))
   =>
   (assert (recommendation (exercise-name ?n) (status excluded))))

;; machine only filter: excludes barbell and dumbbell exercises if machine only
(defrule filter-machine-only
   (user-profile (available-equipment machine-only))
   (exercise (name ?n) (equipment barbell | dumbbell))
   =>
   (assert (recommendation (exercise-name ?n) (status excluded))))


;; defines ranges for beginners and excludes advanced exercises
(defrule setup-beginner
   (user-profile (experience beginner))
   =>
   (assert (routine-parameters (frequency "2-3") (routine-type full-body) (sets "1-3") (reps "8-12")))
   ;; exclude Advanced Exercises for Beginners
   (do-for-all-facts ((?e exercise)) (eq ?e:difficulty advanced)
      (assert (recommendation (exercise-name ?e:name) (status excluded)))))

;; intermediate setup
(defrule setup-intermediate
   (user-profile (experience intermediate))
   =>
   (assert (routine-parameters (frequency "3-4") (sets "Multiple") (reps "6-12"))))

;; sets and reps for advanced
(defrule setup-advanced
   (user-profile (experience advanced))
   =>
   (assert (routine-parameters (frequency "4-5") (sets "3-5") (reps "1-6"))))

;; rest period for heavy loading
(defrule rest-heavy-advanced
   (user-profile (experience advanced))
   (routine-parameters (reps "1-6"))
   ?rp <- (routine-parameters (rest-period nil))
   =>
   (modify ?rp (rest-period "3-5 minutes")))


;; exclude shoulder injury
(defrule exclude-shoulder-injury
   (user-profile (injury-status shoulder))
   (exercise (name ?n&upright-row|bench-dip|lat-pulldown-behind-neck|machine-shoulder-press|barbell-push-press))
   =>
   (assert (recommendation (exercise-name ?n) (status excluded))))

;; exclude back injury
(defrule exclude-back-injury
   (user-profile (injury-status lower-back))
   (exercise (name ?n&standing-toe-touch|barbell-back-squat|barbell-power-clean))
   =>
   (assert (recommendation (exercise-name ?n) (status excluded))))

;; exclude knee injury
(defrule exclude-knee-injury
   (user-profile (injury-status knee))
   (exercise (name ?n&barbell-back-squat|leg-press))
   =>
   (assert (recommendation (exercise-name ?n) (status excluded))))


;; recommend full body exercises if routine type is full-body
(defrule recommend-full-body
   (routine-parameters (routine-type full-body))
   (exercise (name ?n) (target ?t))
   (not (recommendation (exercise-name ?n) (status excluded)))
   =>
   (printout t "Recommended " ?t " Exercise: " ?n crlf))

;; print routine details
(defrule print-routine-details
   (ui-state (phase processing))
   (routine-parameters (frequency ?f) (sets ?s) (reps ?r))
   =>
   (printout t "--- YOUR WORKOUT PLAN ---" crlf)
   (printout t "Frequency: " ?f " days per week" crlf)
   (printout t "Volume: " ?s " sets of " ?r " reps" crlf)
   (printout t "-------------------------" crlf))

;; prioritize machines for beginners or back injuries (R11, R19)
(defrule prioritize-machines
   (or (user-profile (experience beginner))
       (user-profile (injury-status lower-back)))
   (exercise (name ?n) (equipment machine))
   (not (recommendation (exercise-name ?n) (status excluded)))
   =>
   (printout t "Priority Machine Exercise: " ?n crlf))