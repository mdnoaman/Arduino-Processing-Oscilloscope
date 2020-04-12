
void setup() {
  //Setup serial connection
//  Serial.begin(115200);
  Serial.begin(1000000);
  pinMode(A0,INPUT);
  pinMode(A1,INPUT);
  pinMode(A2,INPUT);
  pinMode(A3,INPUT);
//  pinMode(6, OUTPUT);
}
 
void loop() {
  //Read analog pin
  int val0 = analogRead(A0);
  int val1 = analogRead(A1);
  int val2 = analogRead(A2);
  int val3 = analogRead(A3);
  Serial.write( B10100000 ); // decimal value = 160 for handshaking
  sendtopc(val0);
  sendtopc(val1);
  sendtopc(val2);
  sendtopc(val3);
 
  //Write analog value to serial port:
//  analogWrite(6, 150);
  delay(1);
}

// 10 bit Analog read data is divided into two 5 bits data sets
// This ensures that the first 3 data bits are always 0.
// These free bits can be used to send other information such as
// Channel number, data synchronization, etc.
void sendtopc(int val){ 
  Serial.write( (val >> 5) & B00011111 ); 
  Serial.write( val & B00011111 ); 
  val = 0;
}

void waitwithoutdelay(){
}
