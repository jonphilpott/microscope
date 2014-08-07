import processing.video.*;

Capture cam;
String CAMERA_NAME = "Altair USB2.0 Camera";
PImage grey_image;
PImage zoom_image1;
PImage zoom_image2;

int ZOOM_FACTOR_1 = 2;
int ZOOM_FACTOR_2 = 4;

int ZF_1_X = (640 - (640 / ZOOM_FACTOR_1)) / 2;
int ZF_1_Y = (480 - (480 / ZOOM_FACTOR_1)) / 2;


int ZF_2_X = (640 - (640 / ZOOM_FACTOR_2)) / 2;
int ZF_2_Y = (480 - (480 / ZOOM_FACTOR_2)) / 2;


int shift_width = 0;
int k = 0;
int z = 0;


void setup() {
  size(1280, 960);
  
  cam = new Capture(this, 640, 480, CAMERA_NAME, 30);
  grey_image = createImage(640, 480, RGB);
  zoom_image1 = createImage(640/ZOOM_FACTOR_1, 480/ZOOM_FACTOR_1, RGB);
  zoom_image2 = createImage(640/ZOOM_FACTOR_2, 480/ZOOM_FACTOR_2, RGB);

  cam.start();
  
  loadPixels();
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    cam.loadPixels();
   
   image(cam, 0, 0);
   
   
    int idx = 0;
    int zidx = 0;
    for (int x = 0; x < cam.width; x++) {
      for (int y = 0; y < cam.height; y++) {
            int pixel = cam.pixels[idx];
            int p = (pixel >> shift_width) & 0xff;
            
            grey_image.pixels[idx] = color(p);
               
            idx++;
      }
    }
    grey_image.updatePixels();
    zoom_image1 = grey_image.get(ZF_1_X, ZF_1_Y, 640/ZOOM_FACTOR_1, 480/ZOOM_FACTOR_1);
    zoom_image2 = grey_image.get(ZF_2_X, ZF_2_Y, 640/ZOOM_FACTOR_2, 480/ZOOM_FACTOR_2);

    image(grey_image, 640, 0);
    
    pushMatrix();
    translate(0, 480);
    scale(ZOOM_FACTOR_1);
    image(zoom_image1, 0, 0);
    popMatrix();
    
    pushMatrix();
    translate(640, 480);
    scale(ZOOM_FACTOR_2);
    image(zoom_image2, 0, 0);
    popMatrix();
  } 
}

String getFilename() {
  String d = "capture_" + day() + "" + month() + "" + year() + "" + hour() + "" + minute() + "" + second() + ".jpg";
  return d;
}

void keyPressed() {
  
    if (key == 'c') {
      k = (k + 1) % 3;
      shift_width = k * 8;
    }
    
    if (key == 'z') {
      ZOOM_FACTOR_2 = 1 + (ZOOM_FACTOR_2 + 1) % 12;
      ZF_2_X = (640 - (640 / ZOOM_FACTOR_2)) / 2;
      ZF_2_Y = (480 - (480 / ZOOM_FACTOR_2)) / 2;
    }
    
    if (key == 's') {
      save(getFilename());
    }
  
}
