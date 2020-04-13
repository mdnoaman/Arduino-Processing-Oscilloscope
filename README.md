# Arduino-Processing-Oscilloscope
Budget oscilloscope using Arduino and processing

This arduino oscilloscope project was inspired and based on these codes https://gist.github.com/chrismeyersfsu/3270358#file-gistfile1-c
and https://gist.github.com/chrismeyersfsu/3270419#file-gistfile1-c.

The project is devided into two parts:

In the first part, the Arduino code (ard.ino file) is loaded into the Arduino (I used UNO, others can also be adapted). The program analog reads the value from 4 Inputs. This number can be scaled up. These 10 bit long values corresponding to each channel are devided into two 5 bit long bytes. This way, individual bytes have first three 0 bits, i.e: 000XXXXX, where X is the data bit. The reason, I do this is to keep those free (three) bits for other type of communication, such as synchronizing the data start point or encoding channel information, etc. In this case, I am sending an additional byte before the analogread values, i.e. Serial.write( B10100000 ). I am randomly using the first three bits for a start trigger.

On the processing side, the singal serial data is read continuously. When the port.read() finds this matching byte, (B10100000 or 160 in dec), 
the variable "state" changes to 1 which in turn runs the other routine where all the 4 channels values are read and decoded. After all the 4 channel data are received, the "state" changes to 0 to listen to the start trigger from the arduino serial data. This helps maintain the sychronization of the channel information. The rest part of the code plots these values along with showing a current value for each channel on top. A typical screenshot is taken for the window in the .png file.

The additional piece of lines in the arduino file changes the clock prescaler to the ADCs. The default value is 128 which in this example
is set to 16. This way the sampling rate of the ADCs increased by a factor of 8. With this setting enalbled the sampling rate on all 4 channels is above 16KHz. This could be seriusly useful. Withouth these added codes, the sampling rate was only 2 KHz.

#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))

#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))

void setup()

{

sbi(ADCSRA, ADPS2);

cbi(ADCSRA, ADPS1);

cbi(ADCSRA, ADPS0);

...
