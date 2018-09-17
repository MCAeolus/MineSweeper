int map_width = 16;
int map_height = 16;

int mine_count = 40;
int block_px_size = 60;


char [][] map = new char[map_height][map_width];
boolean [][] map_revealed = new boolean[map_height][map_width];
boolean [][] map_flagged = new boolean[map_height][map_width];

boolean game_over = false;

char mineIndicator = 'M';


void setup(){
  fullScreen(1);
  background(255);
  for(int i = 0; i < map_height; i++)
   for(int k = 0; k < map_width; k++){
    map[i][k] = '0';
    map_revealed[i][k] = false;
    map_flagged[i][k] = false;
   }
   
  
  for(int i = 0; i < mine_count; i++){
    
      int place_height = 0;
      int place_width = 0;
      do{
        place_height = floor(random(map_width));
        place_width = floor(random(map_height));
      }while(map[place_height][place_width] == mineIndicator);
            
      map[place_height][place_width] = mineIndicator;
      mineCountPlus(place_height, place_width);
   }
   
   for(int i = 0; i < map_height; i++)
    print(new String(map[i]) + "\n");
   
}

void draw(){
  if(gameIsFinished()){
   text("gg", 100, 100);
   return;
  }
  background(255);
  int border_x = block_px_size * map_width;
  int border_y = block_px_size * map_height;
  fill(255);
  strokeWeight(4);
  rect(0, 0, border_x, border_y);
  
  for(int i = 1; i < map_width; i++){ //columns
    strokeWeight(2);
    fill(100);
    line(block_px_size * i, 0, block_px_size * i, border_y);
  }
  for(int i = 1; i < map_height; i++){ //rows
    strokeWeight(2);
    fill(100);
    line(0, block_px_size * i, border_x, block_px_size * i);
}
  
  for(int i = 0; i < map_height; i++)
    for(int k = 0; k < map_width; k++){
      char p = map[i][k];
      boolean revealed = map_revealed[i][k];
      boolean flagged = map_flagged[i][k];
      
      int x = block_px_size * k;
      int y = block_px_size * i;
      int dx = block_px_size * (k+1);
      int dy = block_px_size * (i+1);
      
      textSize(30);
      fill(200);
      if(p != '0')text(p + "", x + (block_px_size*(1/3)), dy - (block_px_size/2));
      
      if(!revealed && !game_over){
        if(flagged){
          fill(color(255, 0, 0));
          rect(x, y, block_px_size, block_px_size);
        }else{
         fill(200);
         rect(x, y, block_px_size, block_px_size);
        }
      }
    }
}

boolean gameIsFinished(){
  int c = 0;
  for(int i = 0; i < map_height; i++)
    for(int k = 0; k < map_width; k++){
      char p = map[i][k];
      if(p != mineIndicator && map_revealed[i][k]) c++;
    }
   if(map_width * map_height - c == mine_count) return true;
   return false;
}

void mouseClicked(){ //after press + release
  int borderx_i = 0;
  int bordery_i = 0;
  int borderx_f = block_px_size * map_width;
  int bordery_f = block_px_size * map_height;
  
  if((mouseX >= borderx_i && mouseX <= borderx_f) //within game boundaries
  && (mouseY >= bordery_i && mouseY <= bordery_f)){
      int x_pos = mouseX/block_px_size;
      int y_pos = mouseY/block_px_size;
      char p = map[y_pos][x_pos];
      boolean reveal = map_revealed[y_pos][x_pos];
    if(mouseButton == LEFT){
      if(!reveal)
        clickedReveal(y_pos, x_pos);
    }else if(mouseButton == RIGHT){
      map_flagged[y_pos][x_pos] = !map_flagged[y_pos][x_pos];
    }
  }
}

void clickedReveal(int height_m, int width_m){
    char p = map[height_m][width_m];
    if(map_revealed[height_m][width_m] == false){
      map_revealed[height_m][width_m] = true;
      if(p == mineIndicator) game_over = true;
      else if(p == '0'){
        if(checkNear('0', height_m+1, width_m))clickedReveal(height_m+1, width_m);
        if(checkNear('0', height_m-1, width_m))clickedReveal(height_m-1, width_m);
        if(checkNear('0', height_m, width_m+1))clickedReveal(height_m, width_m+1);
        if(checkNear('0', height_m, width_m-1))clickedReveal(height_m, width_m-1);
      }
    }
}

boolean checkNear(char is, int height_m, int width_m){
 if((height_m >= 0 && height_m < map_height) && (width_m >= 0 && width_m < map_width))
  if(map[height_m][width_m]== is) return true;
 return false;
}

void mineCountPlus(int place_height, int place_width){
  
  for(int i = -1; i <= 1; i++){
   for(int k = -1; k <= 1; k++){
       int x = place_width + i;
       int y = place_height + k;
        
       if((x >= 0 && x < map_width) && (y >= 0 && y < map_height)){
         char map_p = map[y][x];
         
         if(map_p != mineIndicator){
          map[y][x] = char(int(map_p) + 1); 
         }
       }
     }
   }
}
