# Rolling Resistance Analysis

These MATLAB scripts are responsible for converting the test results into rolling resistance characteristics for the wheels we've tested. 

The process is a partially automated but there is still some editing of the scripts needed for nice outputs. The basic operation process is:
1. Upload test results in a spreadsheet to the `data` folder (if adding new data)
    - `aero` for general rolling resistance runs. The naming scheme for files here is "<Wheel/Model> - <Contact/Separate> - <Left/Right> - <Pressure/PSI> psi", e.g. *"Grandprix - Contact - Left - 100 psi"*.
    - `inertia` used for inertia measurement calculations
    - `force` is data collected from trials to see the effect of loading on the results, keeping other factors constant.
2. Edit `script_config.csv` with a list of wheels and pressures to be analyzed together.
    - E.g. `Vittoria Corsa Open,100` for Vittoria Corsa Open tires at 100 psi
3. Edit `RRcalc.m` to have the right legend entries for the wheels
4. Run `RRcalc.m` to generate the characterization plots

## Future Improvements

- [x] Automatically derive the necessary legend entries for figures from user parameters
- [x] Derive permissible wheel names from data saved rather than a list in the script
- [x] Convert all data to CSV for easier reading by other systems, at least `aero`
- [x] Replace `xlsread()` instances with more modern functions
- [ ] Rework logic for multiple wheel, with potentially differing pressures
