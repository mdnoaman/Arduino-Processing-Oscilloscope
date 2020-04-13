import processing.serial.*;

Serial port;
int val0, val1, val2, val3;   
int topbar = 50;
int leftbar = 50;
int frameHeight;
int frameWidth;

int[] values0, values1, values2, values3;

void setup() 
{
  size(1350, 530);
  //port = new Serial(this, Serial.list()[1], 115200);
  port = new Serial(this, Serial.list()[1], 2000000);
  frameHeight = height - topbar;
  frameWidth = width - leftbar;
  values0 = new int[frameWidth];
  values1 = new int[frameWidth];
  values2 = new int[frameWidth];
  values3 = new int[frameWidth];
  smooth();
}

int scaledY(int val) {
  return (int)(topbar+ frameHeight - val / 1023.0f * (frameHeight - 1));
}


int[] getSerialData() {
  int value0 = -1;
  int value1 = -1;
  int value2 = -1;
  int value3 = -1;
  int state = 0;
  int[] temp = new int[4]; 
  while (port.available() > 0) {
      // handshake 
      if (state == 0 && port.read() == 160){
         state = 1;
        }
      if (state == 1){
        value0 = (port.read() << 5) | (port.read());
        value1 = (port.read() << 5) | (port.read());
        value2 = (port.read() << 5) | (port.read());
        value3 = (port.read() << 5) | (port.read());
        state = 0;
        }
  }

  temp[0] = value0;
  temp[1] = value1;
  temp[2] = value2;
  temp[3] = value3;
  return temp;
}

void pushValue(int[] tmp) {
  for (int i=0; i<frameWidth-1; i++){
    values0[i] = values0[i+1];
    values0[frameWidth-1] = tmp[0];

    values1[i] = values1[i+1];
    values1[frameWidth-1] = tmp[1];
    
    values2[i] = values2[i+1];
    values2[frameWidth-1] = tmp[2];

    values3[i] = values3[i+1];
    values3[frameWidth-1] = tmp[3];
  }
}


void drawLines(int[] dataVal, int r, int g, int b, int thk) {
  stroke(r,g,b);
  strokeWeight(thk);
  int displayWidth = (int) (frameWidth / scale);
  int k = dataVal.length - displayWidth;
  int x0 = 0;
  int y0 = scaledY(dataVal[k]);
  for (int i=1; i<displayWidth; i++) {
    k++;
    int x1 = (int) (i * (frameWidth-1) / (displayWidth-1));
    int y1 = scaledY(dataVal[k]);
    line(x0+50, y0, x1+50, y1);
    x0 = x1;
    y0 = y1;
  }
}


void drawGrid() {
  stroke(255, 255, 255,60);
  strokeWeight(1);
  for(int i=0; i<=5; i++){  
  line(leftbar, topbar+frameHeight*i/5, leftbar+frameWidth, topbar+frameHeight*i/5); // horizontal
  }
  
  for (int i = 0; i<=10; i++){  
  line(leftbar+frameWidth*i/10, topbar, leftbar+frameWidth*i/10, height); // vertical
  }
}

void addText(int valtxt0, int valtxt1, int valtxt2, int valtxt3) {
  textSize(32);
  // channel labels
  fill(255, 255, 0);
  text("ch0 = "+str(valtxt0), leftbar+10, 30);
  fill(255, 0, 255);
  text("ch1 = "+str(valtxt1), leftbar+200, 30);
  fill(0, 255, 255);
  text("ch2 = "+str(valtxt2), leftbar+400, 30);
  fill(0, 255, 0);
  text("ch3 = "+str(valtxt3), leftbar+600, 30);
  // vertical axis
  fill(255, 255, 255);
  for(int i=0; i<6; i++){
    text(str(i), 10, height-frameHeight*i/5);
  }
}


float scale = 1.0;
void keyReleased() {
  switch (key) {
    case '+':
      scale *= 2.0f;
      if ( (int) (frameWidth / scale) <= 1 )
        scale /= 2.0f;
      break;
    case '-':
      scale /= 2.0f;
      if (scale < 1.0f)
        scale *= 2.0f;
      break;
  }
  println(scale);
}

void draw()
{
  background(0);
  drawGrid();
  int[] tmp = new int[3]; 
  tmp = getSerialData();
  val0 = tmp[0];
  val1 = tmp[1];
  val2 = tmp[2];
  val3 = tmp[3];
  if (val0 != -1 & val1 != -1 & val2 != -1  & val3 != -1) {
    pushValue(tmp);
  }
  addText(val0, val1, val2, val3);    

  drawLines(values0, 255,255,0,2);
  drawLines(values1, 255,0,255,2);
  drawLines(values2, 0,255,255,2);
  drawLines(values3, 0,255,0,2);
}
