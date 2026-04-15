(deffunction prompt-symbol (?message)
   (printout t ?message)
   (read))

(deffunction prompt-number (?message)
   (printout t ?message)
   (read))

(deffunction normalize-days (?days)
   (if (< ?days 2) then (return 2))
   (if (> ?days 6) then (return 6))
   ?days)

(deffunction normalize-severity (?severity)
   (if (< ?severity 0) then (return 0))
   (if (> ?severity 3) then (return 3))
   ?severity)

(deffunction normalize-recovery (?recovery)
   (if (< ?recovery 1) then (return 1))
   (if (> ?recovery 10) then (return 10))
   ?recovery)

(deffunction equipment-ok (?exercise-equipment ?user-equipment)
   (if (eq ?user-equipment full-gym) then
      (return TRUE))
   (if (eq ?user-equipment machine-only) then
      (if (or (eq ?exercise-equipment none) (eq ?exercise-equipment machine)) then
         (return TRUE)
       else
         (return FALSE)))
   (if (eq ?exercise-equipment none) then TRUE else FALSE))

(deffunction injury-ok (?injury ?severity ?shoulder-risk ?back-risk ?knee-risk)
   (if (or (eq ?injury none) (<= ?severity 0)) then
      (return TRUE))
   (if (and (eq ?injury shoulder) (eq ?shoulder-risk yes)) then
      (return FALSE))
   (if (and (eq ?injury lower-back) (eq ?back-risk yes)) then
      (return FALSE))
   (if (and (eq ?injury knee) (eq ?knee-risk yes)) then
      (return FALSE))
   TRUE)

(deffunction duration-from-days (?days ?intensity ?recovery)
   (bind ?mins 45)
   (if (= ?days 2) then (bind ?mins 60))
   (if (= ?days 3) then (bind ?mins 50))
   (if (= ?days 4) then (bind ?mins 45))
   (if (= ?days 5) then (bind ?mins 40))
   (if (>= ?days 6) then (bind ?mins 35))
   (if (eq ?intensity high) then (bind ?mins (+ ?mins 10)))
   (if (eq ?intensity low) then (bind ?mins (- ?mins 5)))
   (if (>= ?recovery 8) then (bind ?mins (+ ?mins 5)))
   (if (<= ?recovery 4) then (bind ?mins (- ?mins 5)))
   (if (< ?mins 25) then (bind ?mins 25))
   (if (> ?mins 75) then (bind ?mins 75))
   ?mins)

(deffunction session-class-from-mins (?mins)
   (if (<= ?mins 40) then short else (if (<= ?mins 60) then standard else long)))

(deffunction exercises-per-day (?intensity ?session-class ?recovery)
   (bind ?n 4)
   (if (eq ?intensity low) then (bind ?n 3))
   (if (eq ?intensity medium) then (bind ?n 4))
   (if (eq ?intensity high) then (bind ?n 5))
   (if (eq ?session-class long) then (bind ?n (+ ?n 1)))
   (if (and (eq ?session-class short) (eq ?intensity high)) then (bind ?n (- ?n 1)))
   (if (and (<= ?recovery 4) (> ?n 3)) then (bind ?n (- ?n 1)))
   ?n)

(deffunction set-string (?intensity ?recovery)
   (if (eq ?intensity low) then
      (if (<= ?recovery 4) then "2" else "2-3")
    else
      (if (eq ?intensity medium) then
         (if (<= ?recovery 4) then "3" else "3-4")
       else
         (if (<= ?recovery 4) then "3-4" else "4-5"))))

(deffunction rep-string (?intensity)
   (if (eq ?intensity low) then "12-15" else (if (eq ?intensity medium) then "8-12" else "6-10")))

(deffunction rest-string (?intensity)
   (if (eq ?intensity low) then "45-60 sec" else (if (eq ?intensity medium) then "60-75 sec" else "75-120 sec")))

(deffunction split-name (?days ?injury)
   (if (neq ?injury none) then
      (if (eq ?injury shoulder) then
         (return "Shoulder-aware split"))
      (if (eq ?injury lower-back) then
         (return "Back-aware split"))
      (return "Knee-aware split"))
   (if (= ?days 2) then (return "Upper / Lower"))
   (if (= ?days 3) then (return "Push / Pull / Legs"))
   (if (= ?days 4) then (return "4-day split"))
   (if (= ?days 5) then (return "5-day split"))
   "Push / Pull / Legs x2")

(deffunction settings-note (?days)
   (if (<= ?days 3) then
      "If you prefer shorter sessions, remove one set from each exercise."
    else
      "If you prefer shorter sessions, keep the main lifts and trim the last accessory movement."))

(deffunction target-priority (?injury ?target)
   (if (eq ?injury none) then 0 else
      (if (eq ?injury shoulder) then
         (if (or (eq ?target chest) (eq ?target shoulders) (eq ?target triceps)) then -0.20 else 0)
       else
         (if (eq ?injury lower-back) then
            (if (or (eq ?target quads) (eq ?target hamstrings) (eq ?target back)) then -0.10 else 0)
          else
            (if (or (eq ?target quads) (eq ?target calves)) then -0.20 else 0)))))

(deffunction difficulty-score (?intensity ?difficulty)
   (if (eq ?intensity low) then
      (if (eq ?difficulty beginner) then 0.22 else (if (eq ?difficulty intermediate) then 0.06 else -0.18))
    else
      (if (eq ?intensity medium) then
         (if (eq ?difficulty beginner) then 0.10 else (if (eq ?difficulty intermediate) then 0.22 else 0.04))
       else
         (if (eq ?difficulty beginner) then -0.02 else (if (eq ?difficulty intermediate) then 0.14 else 0.24)))))

(deffunction style-score (?session-class ?style)
   (if (eq ?session-class short) then
      (if (eq ?style compound) then 0.08 else (if (eq ?style stability) then 0.05 else -0.03))
    else
      (if (eq ?session-class standard) then
         (if (eq ?style stability) then 0.02 else 0.04)
       else
         (if (eq ?style isolation) then 0.05 else (if (eq ?style stability) then 0.03 else 0.06)))))

(deffunction recovery-score (?recovery ?style ?difficulty)
   (if (<= ?recovery 4) then
      (if (eq ?difficulty advanced) then -0.08 else (if (eq ?style compound) then -0.03 else 0.02))
    else
      (if (>= ?recovery 8) then
         (if (eq ?difficulty advanced) then 0.08 else (if (eq ?style compound) then 0.04 else 0.02))
       else
         0.03)))

(deffunction equipment-score (?user-equipment ?exercise-equipment)
   (if (eq ?user-equipment none) then
      (if (eq ?exercise-equipment none) then 0.08 else -0.50)
    else
      (if (eq ?user-equipment machine-only) then
         (if (or (eq ?exercise-equipment none) (eq ?exercise-equipment machine)) then 0.05 else -0.50)
       else
         (if (or (eq ?exercise-equipment barbell) (eq ?exercise-equipment dumbbell)) then 0.05 else 0.03))))

(deffunction fit-label (?score)
   (if (>= ?score 0.95) then "strong match"
    else
      (if (>= ?score 0.80) then "good match"
       else
         (if (>= ?score 0.65) then "usable match" else "backup option"))))

(deffunction best-exercise (?target ?intensity ?equipment ?injury ?severity ?session-class ?recovery $?used)
   (bind ?best-name none)
   (bind ?best-score -1.0)
   (bind ?best-note "")

   (do-for-all-facts
      ((?e exercise))
      (eq ?e:target ?target)
      (if (and (equipment-ok ?e:equipment ?equipment)
               (injury-ok ?injury ?severity ?e:shoulder-risk ?e:back-risk ?e:knee-risk)
               (eq (member$ ?e:name ?used) FALSE)) then
         (bind ?score 0.55)
         (bind ?score (+ ?score (difficulty-score ?intensity ?e:difficulty)))
         (bind ?score (+ ?score (style-score ?session-class ?e:style)))
         (bind ?score (+ ?score (recovery-score ?recovery ?e:style ?e:difficulty)))
         (bind ?score (+ ?score (equipment-score ?equipment ?e:equipment)))
         (bind ?score (+ ?score (target-priority ?injury ?target)))
         (if (> ?score ?best-score) then
            (bind ?best-name ?e:name)
            (bind ?best-score ?score)
            (bind ?best-note ?e:alternative))))

   (if (eq ?best-name none) then
      FALSE
    else
      (create$ ?best-name (fit-label ?best-score) ?best-note)))

(deffunction print-exercise-line (?index ?name ?sets ?reps ?rest ?fit ?note)
   (printout t ?index ". " ?name "  |  " ?sets " sets x " ?reps " reps  |  rest " ?rest "  |  " ?fit crlf)
   (if (> (str-length ?note) 0) then
      (printout t "   note: " ?note crlf)))

(deffunction print-day (?label ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit $?targets)
   (bind ?used (create$))
   (bind ?count 0)
   (printout t crlf ?label crlf)

   (progn$ (?target ?targets)
      (if (< ?count ?limit) then
         (bind ?pick (best-exercise ?target ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?used))
         (if (neq ?pick FALSE) then
            (bind ?count (+ ?count 1))
            (print-exercise-line ?count (nth$ 1 ?pick) ?sets ?reps ?rest (nth$ 2 ?pick) (nth$ 3 ?pick))
            (bind ?used (create$ ?used (nth$ 1 ?pick))))))

   (if (= ?count 0) then
      (printout t "1. rest-and-recover  |  keep the session light and consider professional guidance before returning to training." crlf)))

(deffunction print-split (?days ?injury ?intensity ?equipment ?severity ?recovery ?session-class ?sets ?reps ?rest ?limit)
   (if (and (eq ?injury none) (= ?days 2)) then
      (print-day "Day 1 - Upper Body" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest back shoulders triceps)
      (print-day "Day 2 - Lower Body + Core" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit quads hamstrings glutes core))
   (if (and (eq ?injury none) (= ?days 3)) then
      (print-day "Day 1 - Push" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest shoulders triceps core)
      (print-day "Day 2 - Pull" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit back biceps core)
      (print-day "Day 3 - Legs + Core" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit quads hamstrings glutes calves core))
   (if (and (eq ?injury none) (= ?days 4)) then
      (print-day "Day 1 - Chest + Triceps" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest triceps shoulders core)
      (print-day "Day 2 - Back + Biceps" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit back biceps core)
      (print-day "Day 3 - Legs" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit quads hamstrings glutes calves)
      (print-day "Day 4 - Shoulders + Core" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit shoulders chest core triceps))
   (if (and (eq ?injury none) (= ?days 5)) then
      (print-day "Day 1 - Chest" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest triceps core)
      (print-day "Day 2 - Back" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit back biceps core)
      (print-day "Day 3 - Legs" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit quads hamstrings glutes calves)
      (print-day "Day 4 - Shoulders" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit shoulders chest core)
      (print-day "Day 5 - Arms + Core" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit biceps triceps core chest))
   (if (and (eq ?injury none) (>= ?days 6)) then
      (print-day "Day 1 - Push A" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest shoulders triceps core)
      (print-day "Day 2 - Pull A" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit back biceps core)
      (print-day "Day 3 - Legs A" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit quads hamstrings glutes calves)
      (print-day "Day 4 - Push B" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest triceps shoulders core)
      (print-day "Day 5 - Pull B" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit back biceps core)
      (print-day "Day 6 - Legs B" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit quads hamstrings glutes calves))
   (if (and (eq ?injury shoulder) (= ?days 2)) then
      (print-day "Day 1 - Lower Body" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit quads hamstrings glutes calves)
      (print-day "Day 2 - Core + Lower Body" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit core glutes hamstrings quads))
   (if (and (eq ?injury shoulder) (>= ?days 3)) then
      (print-day "Day 1 - Lower Body A" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit quads hamstrings glutes calves)
      (print-day "Day 2 - Core + Posterior Chain" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit core glutes hamstrings calves)
      (print-day "Day 3 - Lower Body B" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit quads glutes hamstrings core)
      (if (>= ?days 4) then (print-day "Day 4 - Core Stability" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit core glutes calves hamstrings))
      (if (>= ?days 5) then (print-day "Day 5 - Lower Body C" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit quads hamstrings glutes calves))
      (if (>= ?days 6) then (print-day "Day 6 - Core + Lower Body" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit core glutes hamstrings calves)))
   (if (and (eq ?injury lower-back) (= ?days 2)) then
      (print-day "Day 1 - Upper Push" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest shoulders triceps core)
      (print-day "Day 2 - Upper Pull + Core" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit back biceps core glutes))
   (if (and (eq ?injury lower-back) (>= ?days 3)) then
      (print-day "Day 1 - Upper Push" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest shoulders triceps core)
      (print-day "Day 2 - Upper Pull" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit back biceps core chest)
      (print-day "Day 3 - Back-Friendly Lower Body" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit glutes hamstrings quads core)
      (if (>= ?days 4) then (print-day "Day 4 - Core Stability" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit core glutes hamstrings calves))
      (if (>= ?days 5) then (print-day "Day 5 - Upper Mix" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest back biceps triceps))
      (if (>= ?days 6) then (print-day "Day 6 - Back-Friendly Lower Body" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit glutes hamstrings quads core)))
   (if (and (eq ?injury knee) (= ?days 2)) then
      (print-day "Day 1 - Upper Body" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest back shoulders biceps)
      (print-day "Day 2 - Posterior Chain + Core" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit glutes hamstrings core calves))
   (if (and (eq ?injury knee) (>= ?days 3)) then
      (print-day "Day 1 - Upper Push" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest shoulders triceps core)
      (print-day "Day 2 - Upper Pull" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit back biceps core)
      (print-day "Day 3 - Posterior Chain + Core" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit glutes hamstrings core calves)
      (if (>= ?days 4) then (print-day "Day 4 - Upper Mix" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest back shoulders biceps))
      (if (>= ?days 5) then (print-day "Day 5 - Core + Posterior Chain" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit core glutes hamstrings calves))
      (if (>= ?days 6) then (print-day "Day 6 - Upper Mix" ?intensity ?equipment ?injury ?severity ?session-class ?recovery ?sets ?reps ?rest ?limit chest back triceps biceps))))

(deffunction generate-program (?intensity ?days ?equipment ?injury ?severity ?recovery)
   (bind ?safe-days (normalize-days ?days))
   (bind ?safe-severity (normalize-severity ?severity))
   (bind ?safe-recovery (normalize-recovery ?recovery))
   (bind ?mins (duration-from-days ?safe-days ?intensity ?safe-recovery))
   (bind ?session-class (session-class-from-mins ?mins))
   (bind ?per-day (exercises-per-day ?intensity ?session-class ?safe-recovery))
   (bind ?sets (set-string ?intensity ?safe-recovery))
   (bind ?reps (rep-string ?intensity))
   (bind ?rest (rest-string ?intensity))
   (bind ?split (split-name ?safe-days ?injury))
   (bind ?note (settings-note ?safe-days))

   (printout t crlf "========================================" crlf)
   (printout t "Profile" crlf)
   (printout t "----------------------------------------" crlf)
   (printout t "Intensity: " ?intensity crlf)
   (printout t "Days/week: " ?safe-days crlf)
   (printout t "Equipment: " ?equipment crlf)
   (printout t "Injury area: " ?injury "   Severity: " ?safe-severity crlf)
   (printout t "Recovery score: " ?safe-recovery crlf)

   (printout t crlf "Program Overview" crlf)
   (printout t "----------------------------------------" crlf)
   (printout t "Split: " ?split crlf)
   (printout t "Suggested daily duration: " ?mins " minutes" crlf)
   (printout t "Exercises per day: " ?per-day crlf)
   (printout t "Default prescription: " ?sets " sets x " ?reps " reps   |   rest " ?rest crlf)
   (printout t ?note crlf)
   (if (neq ?injury none) then
      (printout t "Exercise choices were adjusted to reduce stress around the injury area you entered." crlf))
   (if (neq ?equipment full-gym) then
      (printout t "When gym equipment is limited, bodyweight or machine-friendly substitutes are selected automatically." crlf))

   (print-split ?safe-days ?injury ?intensity ?equipment ?safe-severity ?safe-recovery ?session-class ?sets ?reps ?rest ?per-day)

   (printout t crlf "========================================" crlf))

(deffunction start-planner ()
   (printout t crlf "Workout Planner" crlf)
   (printout t "----------------" crlf)
   (printout t "Choose intensity (low/medium/high): ")
   (bind ?intensity (read))
   (printout t "How many days per week do you want to train? (2-6): ")
   (bind ?days (read))
   (printout t "Equipment (none/machine-only/full-gym): ")
   (bind ?equipment (read))
   (printout t "Injury area (none/shoulder/lower-back/knee): ")
   (bind ?injury (read))
   (printout t "Injury severity (0 if none, otherwise 1-3): ")
   (bind ?severity (read))
   (printout t "Recovery score (1-10): ")
   (bind ?recovery (read))

   (generate-program ?intensity ?days ?equipment ?injury ?severity ?recovery)
)
