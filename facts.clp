

(deftemplate exercise
   (slot name (type SYMBOL))
   (slot target (type SYMBOL))
   (slot equipment (type SYMBOL))
   (slot difficulty (type SYMBOL))
   (slot joint-type (type SYMBOL) (default multi))) ; multi vs single

(deftemplate user-profile
   (slot experience (type SYMBOL))           ; beginner, intermediate, advanced
   (slot available-equipment (type SYMBOL))  ; none, machine-only, full-gym
   (slot injury-status (type SYMBOL) (default none))
   (slot age-category (type SYMBOL) (default adult))
   (slot goal (type SYMBOL) (default general)))

(deftemplate routine-parameters
   (slot frequency (type STRING))
   (slot routine-type (type SYMBOL))
   (slot sets (type STRING))
   (slot reps (type STRING))
   (slot rest-period (type STRING)))

(deftemplate recommendation
   (slot exercise-name (type SYMBOL))
   (slot status (type SYMBOL) (default included))) ; included or excluded

(deffacts exercise-library
;; beginner machine exercises
   (exercise (name leg-press) (target quads) (equipment machine) (difficulty beginner))
   (exercise (name machine-chest-press) (target chest) (equipment machine) (difficulty beginner))
   (exercise (name lat-pulldown) (target back) (equipment machine) (difficulty beginner))
   (exercise (name seated-leg-curl) (target hamstrings) (equipment machine) (difficulty beginner))
   (exercise (name machine-shoulder-press) (target shoulders) (equipment machine) (difficulty beginner))
   (exercise (name abdominal-crunch-machine) (target core) (equipment machine) (difficulty beginner))
   (exercise (name seated-cable-row) (target back) (equipment machine) (difficulty beginner))

;; beginner bodyweight exercises
   (exercise (name push-up) (target chest) (equipment none) (difficulty beginner))
   (exercise (name goblet-squat) (target quads) (equipment dumbbell) (difficulty beginner))

;; intermediate exercises
   (exercise (name barbell-bench-press) (target chest) (equipment barbell) (difficulty intermediate))
   (exercise (name upright-row) (target shoulders) (equipment barbell) (difficulty intermediate) (joint-type single))
   (exercise (name pull-up) (target back) (equipment none) (difficulty intermediate))
   (exercise (name bench-dip) (target triceps) (equipment none) (difficulty intermediate) (joint-type single))
   (exercise (name standing-toe-touch) (target hamstrings) (equipment none) (difficulty intermediate))
   (exercise (name pike-push-up) (target shoulders) (equipment none) (difficulty intermediate))
   
;; advanced exercises
   (exercise (name barbell-back-squat) (target quads) (equipment barbell) (difficulty advanced))
   (exercise (name barbell-power-clean) (target full-body) (equipment barbell) (difficulty advanced))
   (exercise (name lat-pulldown-behind-neck) (target back) (equipment machine) (difficulty advanced))
   (exercise (name barbell-push-press) (target shoulders) (equipment barbell) (difficulty advanced))
   (exercise (name barbell-romanian-deadlift) (target hamstrings) (equipment barbell) (difficulty advanced)))

(deffacts system-initialization ;; defines initial state of the system
   (ui-state (phase startup)))  ;; puts system in startup phase