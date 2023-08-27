# Rolling Resistance Analysis

These MATLAB scripts are responsible for converting the test results into rolling resistance characteristics for the wheels we've tested. 

The process is a partially automated but there is still some editing of the scripts needed for nice outputs. The basic operation process is:
1. Upload test results in a spreadsheet to the data folder (if adding new data)
2. Edit `Test_info.csv` with a list of wheels and pressures to be analyzed together.
    - E.g. `Vittoria Corsa Open,100` for Vittoria Corsa Open tires at 100 psi
3. Edit `RRcalc.m` to have the right legend entries for the wheels
4. Run `RRcalc.m` to generate the characterization plots

## Future Improvements

- Automatically derive the necessary legend entries for figures from user parameters
- Derive permissible wheel names from data saved rather than a list in the script