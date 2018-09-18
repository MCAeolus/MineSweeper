class Slider{
 
  int x;
  int y;
  int x2;
  int y2;
  int default_percent;
  int current_percent;
  
  int slide_x1 = 0;
  int slide_y1 = 0;
  int slide_x2 = 0;
  int slide_y2 = 0;
  
  int slide_width = 10;
  int slide_height = 50;
  
  Slider(int x, int y, int x2, int y2, int default_percent, int starting_percent){
    this.x = x;
    this.y = y;
    this.x2 = x2;
    this.y2 = y2;
    this.default_percent = default_percent;
    this.setPercent(starting_percent);
    this.updateSlide();
  }
  
  void updateSlide(){
    int length_div = x2-x;
    int center = length_div/current_percent;
    int len_rad_width = slide_width/2;
    int len_rad_height = slide_height/2;
    
    slide_x1 = x + (center-len_rad_width);
    slide_x2 = x + (center+len_rad_width);
    
    slide_y1 = y + len_rad_height;
    slide_y2 = y - len_rad_height;
  }
  
  Coordinate slidePositionL(){
   return new Coordinate(slide_x1, slide_y1); 
  }
  
  Coordinate slidePositionR(){
   return new Coordinate(slide_x2, slide_y2); 
  }
  
  void setPercent(int percent){
    this.current_percent = percent; 
  }
  
  int getPercent(){
    return this.current_percent; 
  }
  
}
