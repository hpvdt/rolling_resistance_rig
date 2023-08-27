# Arduino Code

The data collection system is based around an Arduino Nano (previously an Arduino Uno) and is programmed using the Arduino IDE.

The most recent version of the system (`rolling_resistance`) uses digital sensors (magnetic/Hall effect) and interrupts to accurately measure rotational period and stream it to the host PC over serial. Previously analog sensors and polling was used which wasn't as temporaly accurate or reliable.

None of these sketches have any dependancies outside of the stock Arduino-provided libraries.

## Saving the Data

The Arduino will not save any of the data, it is simply responsible for streaming it to the host computer to be viewed over serial. To save the data one must either use some program to log incoming serial data, or copy the entire contents of the serial viewer window into a text file to make a comma separated file (`.csv`) or Excel workbook.

## Folder Breakdown

- `rolling_resistance` - Active system sketch. **USE THIS!**
- `old` - Collection of previous sketches used. Kept for archival purposes and if we change sensors.