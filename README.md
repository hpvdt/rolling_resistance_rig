# Rolling Resistance Rig (RRR)

One of the most crucial aspects of our land vehicles is the study of rolling resistance and our pursuit of reducing it. To this end the team has constucted a rolling resistance rig (_RRR_) to characterize different wheels. This repository serves as **the definitive** collection of information related to the RRR and its tests: especially the sensor system design and data processing. 

The general principle of the RRR is that there is a large drum which acts as the riding surface for the wheel and is spun up to speed by an electric motor to simulate speeds of over 80 km/h. The wheel under test is installed above the wheel and is loaded to a similar level to the expected vehicle load prior to the drum getting spun up. Once the desired speed is achieved by the system, the power to the drum is cut and the drum/wheel combo is left to slow down by dissipating power primarily through their own rolling resistances.

During this slowdown the rotational period of each part is monitored and recorded over serial to then be analyzed and derive a rolling resistance for the wheel being tested. This processing is performed after the experiment is concluded in MATLAB.

The exact procedure for this process is outlined in a separate markdown file, [`test_procedure.md`](./test_procedure.md).

## Repository Organization

There are a few folders used to sort the different components of the system.

| Folder | Purpose |
| --- | ---|
| `analysis` | Primarily the MATLAB files used to process the data collected |
| `analysis/data` | Previously collected experiment data |
| `arduino` | Microcontroller code used to collect data. **USE THE `rolling_resistance` SKETCH!** |
| `doc` | Assorted documentation about the system design |
| `hardware` | Hardware files for custom circuit boards designed for this system |

## Software Used

A few programs are needed to fully operate the system. No additional configuration is needed to any of the software to run the system (e.g. installing custom libraries).

- **Arduino IDE** (**V 2.1.0** as of writting) for programming the microntrollers used (Arduino Nanos/Unos).
- **KiCad 7** for the most recent board's hardware files. The previous version was prepared in EAGLE.
- **MATLAB** for post-processing of the data collected.
- **Excel/LibreOffice Calc** to store some results.

## Future Improvements

- [ ] Record procedure to determine inertia characteristics of a wheel as part of this repository
- [ ] Improve the data processing scripts. *More information in its [readme](analysis/readme.md).*
