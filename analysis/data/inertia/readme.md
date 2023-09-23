# Inertia Measurement Data

This is the collection of data taken for our moment of inertia measurements for many wheels. Data is coast down data for wheels with one event per rotation. This way the time between successive events is one rotational period. See data folder readme to understand how to read the 5 columns of data.

In the "analysis" folder, wheelInfo.csv contains all the constants needed for moment of inertia calculation. Note that "coin" represents the small magnet on the wheel used to record revolutions. The columns m_coin and d_coin in wheelInfo.csv represent the magnet's mass and distance from rotation axis.

### Notes About the Data

Due to a previous configuration of the rotation sensors used for the rolling resistance rig, there were two recorded 'ticks' per wheel rotation, so alternating event entries were discarded. This has been done manually by altering the saved data to remove the ignored rows and removing the code to do the skipping so that the logic is *[hopefully]* easier to follow down the line.


## Future Improvements
- [ ] Figure out why the coast down rolling data helps us use InertiaCalc (Don't we only need mass and stuff, not rolling)?
- [ ] Figure out what R_coin is in wheelInfo.csv in "analysis" folder (We already have d_coin for diameter)
- [ ] Figure out what Theta_1 and theta_2 mean in wheelInfo.csv
