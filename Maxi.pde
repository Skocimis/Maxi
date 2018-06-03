import processing.serial.*;

Serial pic;
String read;
String[] list;

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
  size(640, 480);
  stroke(256, 256, 256);
  // We don't want to attempt serial connection every 1/60th of a second
  frameRate(1);
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
  pic.readStringUntil(10);      
}

// Checks the serial port for new information
void checkSerial() {
  if (pic.available() == 0) {
    return;
  }
  read = pic.readStringUntil('|');
  if (read != null) {
    // Split by \n
  }
}

// Draws everything useful
void drawPosition() {
  background(0, 0, 0);
}
