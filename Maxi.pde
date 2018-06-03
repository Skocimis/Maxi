import processing.serial.*;

Serial pic;
String read;
String[] list;
final PVector pos = new PVector(
  0,
  0,
  999999999
);
final int velicinaX=5;
final int velicinaY=5;
final int FONT_SIZE = 32;
int v1,v2,v3;
PVector[] sensor = new PVector[] {
  new PVector(/*sensor1.x, sensor1.y */),
  new PVector(/*sensor2.x, sensor2.y */),
  new PVector(/*sensor3.x, sensor3.y */)
};
// Parses an integer that starts with zeroes
int customParseInt(String str) {
  str = trim(str);
  while (str.startsWith("0")) {
    str = str.substring(1);
  }
  return int(str);
}

// Sets up the simulation
void setup() {
  size(1200, 500);
  stroke(256, 256, 256);
  textSize(FONT_SIZE);
  textAlign(CENTER, CENTER);
  fill(0, 0, 0);
  // We don't want to attempt serial connection every 1/60th of a second
  frameRate(1);
  // Draw waiting text
  background(255, 255, 255);
  text("Waiting for serial connection...", 0, 0, width, height);
}

// Executed every frame
void draw() {
  if (pic == null) {
    connectSerial();
  } else {
    checkSerial();
    drawPosition();
  }
}

// Connects to first available serial port
void connectSerial() {
  list = Serial.list();
  // There are no COM ports available to connect
  if (list.length == 0) {
    return;
  }
  // Connect to serial port
  pic = new Serial(this, list[0], 9600);
  // Don't allow corrupt data after connection
  pic.clear();
  pic.readStringUntil('|');
  // Restore frame rate
  frameRate(60);
}

// Checks the serial port for new information
void checkSerial() {
  if (pic.available() == 0) {
    return;
  }
  read = pic.readStringUntil('|');
  if (read != null) {
    String[] split = read.split("\n");
    calculatePosition(
      customParseInt(split[0]),
      customParseInt(split[1]),
      customParseInt(split[2])
    );
  }
}

// Calculates position based on three measured voltages
void calculatePosition(int v1, int v2, int v3) {
   int tempX=0,tempY=0,tempZ=0;
   int tempU=0;
  for(int x=0;x<500;x++){
    for(int y=0;y<500;y++){
    //treba naci razmeru sensor value i razdaljine
      tempX=(int)sqrt((sensor[0].x-x)*(sensor[0].x-x)+(sensor[0].y-y)*(sensor[0].y-y));
      tempY=(int)sqrt((sensor[1].x-x)*(sensor[1].x-x)+(sensor[1].y-y)*(sensor[1].y-y));
      tempZ=(int)sqrt((sensor[2].x-x)*(sensor[2].x-x)+(sensor[2].y-y)*(sensor[2].y-y));
      tempU=abs(tempX-v1)+abs(tempY-v2)+abs(tempZ-v3);
      if(tempU<pos.z){pos.x=x;pos.y=y;pos.z=tempU;}      
    }
  }
  
}

// Draws everything useful
  
  
void drawPosition() {
  background(0, 0, 0);
  calculatePosition(v1,v2,v3);
  ellipse(pos.x,pos.y,velicinaX,velicinaY);

}
