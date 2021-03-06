import processing.serial.*;

Serial pic;
String read;
String[] list;
final PVector pos = new PVector(0, 0, 999999999);
final int velicinaX = 5;
final int velicinaY = 5;
final int FONT_SIZE = 32;
int v1, v2, v3;
final PVector[] sensor = new PVector[] {
  new PVector(0, 500),
  new PVector(0, 0),
  new PVector(500, 0)
};
boolean debug = true;

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
  // Restore frame rate and text options
  frameRate(60);
  textSize(24);
  textAlign(LEFT, CENTER);
}

// Checks the serial port for new information
void checkSerial() {
  if (pic.available() == 0) {
    return;
  }
  read = pic.readStringUntil('|');
  if (read != null) {
    String[] split = read.split("\n");
    if (split.length != 4) {
      println("[Error] split.length is not 4!");
      return;
    }
    v1 = customParseInt(split[0]);
    v2 = customParseInt(split[1]);
    v3 = customParseInt(split[2]);
    calculatePosition();
  }
}

// Calculates position based on three measured voltages
void calculatePosition() {
  println(v1 + " " + v2 + " " + v3);
  float tempX = 0, tempY = 0, tempZ = 0, tempU = 0;
  float d0x, d0y, d1x, d1y, d2x, d2y;
  int cv1 = v1 / 1023 * 500;
  int cv2 = v3 / 1023 * 500;
  int cv3 = v2 / 1023 * 500;
  for (int x = 0; x < 500; ++x) {
    for (int y = 0; y < 500; ++y) {
      // Treba naći razmeru sensor value i razdaljine
      d0x = sensor[0].x - x;
      d0y = sensor[0].y - y;
      d1x = sensor[1].x - x;
      d1y = sensor[1].y - y;
      d2x = sensor[2].x - x;
      d2y = sensor[2].y - y;
      tempX = sqrt(d0x * d0x + d0y * d0y);
      tempY = sqrt(d1x * d1x + d1y * d1y);
      tempZ = sqrt(d2x * d2x + d2y * d2y);
      tempU = abs(tempX - cv1) + abs(tempY - cv2) + abs(tempZ - cv3);
      if (tempU < pos.z) {
        pos.x = x;
        pos.y = y;
        pos.z = tempU;
      }
    }
  }
  // println(pos.x + " " + pos.y + " " + pos.z);
}

// Draws everything useful
void drawPosition() {
  background(0, 0, 0);
  noStroke();
  fill(255, 255, 255);
  ellipse(pos.x + 250, pos.y, velicinaX, velicinaY);
  if (debug) {
    text(
      "V1: " + v1 + "\nV2: " + v2 + "\nV3: " +
      v3 + "\nX: " + pos.x + "\nY: " + pos.y,
      10,
      10,
      250,
      500
    );
  }
  stroke(255, 0, 0);
  noFill();
  rect(250, 0, 750, 500);
}
