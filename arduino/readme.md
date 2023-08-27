# Arduino Code

The data collection system is based around an Arduino Nano (previously an Arduino Uno) and is programmed using the Arduino IDE.

The most recent version of the system (`rolling_resistance`) uses digital sensors (magnetic/Hall effect) and interrupts to accurately measure rotational period and stream it to the host PC over serial. Previously analog sensors and polling was used which wasn't as temporaly accurate or reliable.

None of these sketches have any dependancies outside of the stock Arduino-provided libraries.

## Folder Breakdown

- `rolling_resistance` - Active system sketch. **USE THIS!**
- `old` - Collection of previous sketches used. Kept for archival purposes and if we change sensors.