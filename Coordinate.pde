class Coordinate{
  int x;
  int y;
  
  Coordinate(int x, int y){
   this.x = x;
   this.y = y;
  }
  
  int x(){
   return x; 
  }
  
  int y(){
   return y;
  }
  
  void set_x(int x){
   this.x = x; 
  }
  
  void set_y(int y){
   this.y = y; 
  }
  
  void update_coords(int x, int y){
   this.set_x(x);
   this.set_y(y);
  }
  
  
}
