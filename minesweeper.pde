int map_width = 16;
int map_height = 16;

int mine_count = 20;

char [][] map = new char[map_height][map_width];
boolean [][] map_revealed = new boolean[map_height][map_width];

char mineIndicator = 'M';


void setup(){
  fullScreen();
  background(255);
  for(int i = 0; i < map_height; i++)
   for(int k = 0; k < map_width; k++){
    map[i][k] = '0';
    map_revealed[i][k] = false;
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
  int block_px_size = 50;
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
  for(int i = 1; i < map_height; i++){ //columns
    strokeWeight(2);
    fill(100);
    line(0, block_px_size * i, border_x, block_px_size * i);
  }  
  
  
}

void mouseClicked(){ //after press + release
  return;
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
