# Workout Planner Expert System (D2)

This is a fresh CLIPS project built from scratch for a dynamic workout planning demo.

## Files
- `facts.clp` — exercise knowledge base
- `rules.clp` — planner logic and printing functions
- `run.bat` — CLIPS batch script to launch the planner

## How to run in CLIPSIDE
1. Extract the folder to a simple location, for example `C:/clips-project/`
2. Open CLIPSIDE
3. Run:
   ```clips
   (clear)
   (chdir "C:/clips-project/")
   (batch "run.bat")
   ```

The system will then ask for:
- intensity
- days per week
- equipment level
- injury area
- injury severity
- recovery score

## Notes
- This version starts directly with `(start-planner)` from the batch file.
- It does not depend on rule-engine phase transitions.
- It prints a structured plan every time after all inputs are entered.
