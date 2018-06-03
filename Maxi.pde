import processing.serial.*;

Serial pic;
String read;
String[] list;
final PVector pos = new PVector();
final int FONT_SIZE = 32;

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
  size(500, 500);
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
  pic.readStringUntil(10);
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
  // IMPLEMENT THIS
}

// Draws everything useful
void drawPosition() {
  background(0, 0, 0);
}
