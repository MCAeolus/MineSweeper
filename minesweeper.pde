int map_width = 16;
int map_height = 16;

int mine_count = ((int)round((float)Math.sqrt(map_width * map_height * 3)));
int block_px_size = 0;

int border_y_i = 0;
int border_x_i = 0;
int border_y_f = 0;
int border_x_f = 0;

int margin_px = 400;

Coordinate ending_coords = new Coordinate(0, 0);

int width_count = 0;
int height_count = 0;

int slider_mines_percent = 0;
int slider_height_percent = 0;
int slider_width_percent = 0;

char [][] map = new char[map_height][map_width];
boolean [][] map_revealed = new boolean[map_height][map_width];
boolean [][] map_flagged = new boolean[map_height][map_width];

boolean game_over = false;
boolean game_complete = false;
boolean first_click = false;


char mineIndicator = 'M';


void setup() {
  fullScreen(1);
  background(255);
  
  for (int i = 0; i < map_height; i++)
    for (int k = 0; k < map_width; k++) {
      map[i][k] = '0';
      map_revealed[i][k] = false;
      map_flagged[i][k] = false;
    }
  
  block_px_size = ((height-margin_px)/map_height);//screens are generally longer than taller, therefore height is the smaller factor than width.
  width_count = map_width*block_px_size;
  height_count = map_height*block_px_size;
  border_x_i = (width-width_count) / 2;
  border_y_i = (height-height_count) / 2;
  border_x_f = border_x_i + width_count;
  border_y_f = border_y_i + height_count;
}

void generateMap(int initial_x, int initial_y){
  Coordinate initial_coordinate = new Coordinate(initial_x, initial_y);
  for (int i = 0; i < mine_count; i++) {

    Coordinate place_coordinate;
    do {
      place_coordinate = weightedRandomPlacement(initial_coordinate, 2);
    } while (map[place_coordinate.y()][place_coordinate.x()] == mineIndicator);

    map[place_coordinate.y()][place_coordinate.x()] = mineIndicator;
    mineCountPlus(place_coordinate.y(), place_coordinate.x());
  }
  
  for (int i = 0; i < map_height; i++)
    print(new String(map[i]) + "\n");
}

Coordinate weightedRandomPlacement(Coordinate c, int range_min){
   Coordinate cor = new Coordinate(0, 0);
   double range;
   do{
      cor.update_coords(floor(random(map_width)), floor(random(map_height)));
      range = Math.abs(Math.hypot(c.y(), c.x()) - Math.hypot(cor.y(), cor.x()));
   }while(range <= range_min);
  
  return cor;
}

void draw() {
  background(255);
  if (gameIsFinished()) {
    textSize(70);
    fill(100);
    text("gg", Math.abs(ending_coords.x()-border_x_i) < Math.abs(ending_coords.x()-border_x_f)?border_x_i - (width/10) 
                                                        : border_x_f + (width/10), ending_coords.y());
  }
  textSize(30);
  fill(0);
  
  int flag_c = 0;
  for(int i = 0; i < map_height; i++)
    for(int k = 0; k < map_width; k++)
      if(map_flagged[i][k]) flag_c++;
  
  text("Mines: " + mine_count + " | Flagged Mines: " + flag_c , 0, 50);
  fill(255);
  strokeWeight(4);
  rect(border_x_i, border_y_i, width_count, height_count);

  for (int i = 1; i < map_width; i++) { //columns
    strokeWeight(2);
    fill(100);
    line(border_x_i + (block_px_size * i), border_y_i, border_x_i + (block_px_size * i), border_y_f);
  }
  for (int i = 1; i < map_height; i++) { //rows
    strokeWeight(2);
    fill(100);
    line(border_x_i, border_y_i + (block_px_size * i), border_x_f, border_y_i + (block_px_size * i));
  }
  
  for (int i = 0; i < map_height; i++)
    for (int k = 0; k < map_width; k++) {
      char p = map[i][k];
      boolean revealed = map_revealed[i][k];
      boolean flagged = map_flagged[i][k];

      int x = border_x_i + block_px_size * k;
      int y = border_y_i + block_px_size * i;
      int dx = border_x_i + block_px_size * (k+1);
      int dy = border_y_i + block_px_size * (i+1);

      textSize(30);
      fill(200);
      if (p != '0')text(p + "", x + (block_px_size*(1/3)), dy - (block_px_size/2));

      if (!revealed && !game_over) {
        if (flagged) {
          fill(color(255, 0, 0));
          rect(x, y, block_px_size, block_px_size);
        } else {
          fill(200);
          rect(x, y, block_px_size, block_px_size);
        }
      }
    }
}

boolean gameIsFinished() {
  if(!game_complete){
    int c = 0;
    for (int i = 0; i < map_height; i++)
      for (int k = 0; k < map_width; k++) {
        char p = map[i][k];
        if (p != mineIndicator && map_revealed[i][k]) c++;
      }
    if (map_width * map_height - c == mine_count){
      game_complete = true;
      return true;
    }
    return false;
  }
  return true;
}

void mouseClicked() { //after press + release
  if ((mouseX >= border_x_i && mouseX <= border_x_f) //within game boundaries
    && (mouseY >= border_y_i && mouseY <= border_y_f)) {
      
      if(gameIsFinished())return;
      
      int x_pos = floor((mouseX-border_x_i)/block_px_size);
      int y_pos = floor((mouseY-border_y_i)/block_px_size);
      
      if(!first_click){
        generateMap(x_pos, y_pos);
        first_click = true;
      }
      
      boolean reveal = map_revealed[y_pos][x_pos];
      boolean flagged = map_flagged[y_pos][x_pos];
      if (mouseButton == LEFT) {
        if (!reveal && !flagged)
          clickedReveal(y_pos, x_pos);
      } else if (mouseButton == RIGHT && !reveal && first_click) {
        map_flagged[y_pos][x_pos] = !map_flagged[y_pos][x_pos];
      }
      
      if(gameIsFinished()){
       ending_coords.update_coords(mouseX, mouseY); 
      }
    }
}

void clickedReveal(int height_m, int width_m) {
  char p = map[height_m][width_m];
  if (map_revealed[height_m][width_m] == false) {
    map_revealed[height_m][width_m] = true;
    if (p == mineIndicator) game_over = true;
    else if (p == '0') {
      
      for(int i = -1; i <= 1; i++)
        for(int k = -1; k <= 1; k++)
          if(checkNear('M', height_m + i, width_m + k))clickedReveal(height_m + i, width_m + k);
    }
  }
}

boolean checkNear(char isnt, int height_m, int width_m) {
  if ((height_m >= 0 && height_m < map_height) && (width_m >= 0 && width_m < map_width))
    if (map[height_m][width_m] != isnt) return true;
  return false;
}

void mineCountPlus(int place_height, int place_width) {

  for (int i = -1; i <= 1; i++) {
    for (int k = -1; k <= 1; k++) {
      int x = place_width + i;
      int y = place_height + k;

      if ((x >= 0 && x < map_width) && (y >= 0 && y < map_height)) {
        char map_p = map[y][x];

        if (map_p != mineIndicator) {
          map[y][x] = char(int(map_p) + 1);
        }
      }
    }
  }
}
