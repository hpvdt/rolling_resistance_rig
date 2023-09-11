# Inertia Measurement Data

This is the collection of data taken for our moment of inertia measurements. The test results seem to be normal rolling resistance runs, but with a proof mass "coin" attached with a known moment or inertia so a relative moment could be found(?)

Data is coast down data for wheels with one event per rotation. This way the time between successive events is one rotational period.

### Notes About the Data

Due to a previous configuration of the rotation sensors used for the rolling resistance rig, there were two recorded 'ticks' per wheel rotation, so alternating event entries were discarded. This has been done manually by altering the saved data to remove the ignored rows and removing the code to do the skipping so that the logic is *[hopefully]* easier to follow down the line.