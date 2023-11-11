# Summary of Directories

- `aero` for general rolling resistance runs, each wheel configuration needs four trials listed below. The naming scheme for files here is "<Wheel/Model> - <Contact/Separate> - <Left/Right> - <Pressure/PSI> psi", e.g. *"Grandprix - Contact - Left - 100 psi"*.
  - Contact coast down - drum spun right
  - Separated coast down - drum spun right
  - Contact coast down - drum spun left
  - Separated coast down - drum spun left
- `inertia` used for inertia measurement calculations 
- `force` is data collected from trials to see the effect of loading on the results, keeping other factors constant.

In this main data directory there is a file outlining the configurations used for some of the earliest collected data in `csv` format.

# Reading Test Data
In CSV files in any subfolder of data, there are five columns of test data collected by the Arduino:
![image](https://github.com/hpvdt/rolling_resistance_rig/assets/32986949/c0782b5a-fa3f-45c4-bab5-a46d55e019cb)
These columns show: time (microseconds), rate (drum), # of revolutions (drum), rate (small wheel), # of revolutions (small wheel)

# Summary of Notable RR Results

*As taken from previous maintainer.*

- **Greenspeed** - 80 psi - Missing contact right, will you duplicate with contact left; **Note:** the data values from this test might be systematically off
