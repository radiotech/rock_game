Board board = new Board();
int selected = -1;
int best = -1;
int itterations = 0;

void setup(){
  size(1000,600);
  
  showBest(board, true);
  println(itterations);
}

void draw(){
  
  background(255);
  
  board.drawBoard(width/2,height/2,width*9/10);
}

void renderCup(float x, float y, float w, float h, int k, int l){
  float spot = w/4;
  float size = w/5;
  
  if(floor(h/spot) <= ceil(k/4)){
    renderCup(x,y, w, h+spot, k, l);
  } else {
    rectMode(CENTER);
    noStroke();
    fill(0,100);
    if(l == best){
      fill(0,255,0,100);
    }
    rect(x,y,w,h,size/2);
    
    randomSeed(int(x+y));
    for(int i = 0; i < k; i++){
      fill(random(255),random(255),random(255),200);
      rect(x-w/2+spot*(.5+i%4),y+h/2-spot*(.5+floor(i/4)),size,size,size/3);
    }
  }
  
  if(abs(mouseX-x)<w/2){
    if(abs(mouseY-y)<h/2){
      selected = l;
    }
  }
  
}

void mousePressed(){
  
  if(selected > -1){
    println(board.rotateCups(selected,true));
    itterations = 0;
    showBest(board, true);
    println(itterations);
  }
  
}

void showBest(Board a, boolean me){
  int[] tempWeights = a.getBoardWeight(true);
  int bestSpotFirst = 0;
  int bestWeightFirst = 0;
  int bestSpotLast = 0;
  int bestWeightLast = 0;
  for(int i = 0; i < 6; i++){
    if(tempWeights[i] > bestWeightFirst){
      bestWeightFirst = tempWeights[i];
      bestSpotFirst = i;
    }
    if(tempWeights[i] >= bestWeightLast){
      bestWeightLast = tempWeights[i];
      bestSpotLast = i;
    }
  }
  if(bestSpotLast != bestSpotFirst){
    println("2 Bests at " + bestSpotFirst + " and " + bestSpotLast);
  }
  best = bestSpotLast;
  if(me == false){
    best += 7;
  }
}

class Board{
  int[] cups = new int[14];
  
  Board(){
    for(int i = 0; i < 6; i++){
      cups[i] = 4;
      cups[i+7] = 4;
    }
    cups[6] = 0;
    cups[13] = 0;
  }
  
  void drawBoard(float x, float y, float w){
    float cupWidth = w/10;
    float cupSpace = w/8;
    float h = cupSpace*2.5;
    
    rectMode(CENTER);
    rect(x,y,w,w/3);
    
    selected = -1;
    for(int i = 0; i < 6; i++){
      renderCup(x-w/2+cupSpace*(1.5+i),y+h/2-cupSpace/2,cupWidth,cupWidth,cups[i],i);
      renderCup(x+w/2-cupSpace*(1.5+(i)),y-h/2+cupSpace/2,cupWidth,cupWidth,cups[i+7],i+7);
    }
    renderCup(x+w/2-cupSpace*.5,y,cupWidth,cupWidth+cupSpace*1.5,cups[6],6);
    renderCup(x-w/2+cupSpace*.5,y,cupWidth,cupWidth+cupSpace*1.5,cups[13],13);
    
  }
  
  int rotateCups(int a, boolean me){
    itterations++;
    int myReturn = 0;
    int hand = cups[a];
    cups[a] = 0;
    for(int pointer = a+1; hand > 0; pointer++){
      if(me){
        if(pointer==13){
          pointer++;
        }
      } else {
        if(pointer==6){
          pointer++;
        }
      }
      if(pointer > 13){
        pointer -= 14;
      }
      
      cups[pointer]++;
      hand--;
      
      if(pointer == 13 || pointer == 6){
        myReturn++;
      }
      if(hand == 0){
        if(pointer == 13 || pointer == 6){
          myReturn = myReturn+1000;
        } else if(cups[pointer] > 1){
          myReturn += rotateCups(pointer,me);
        }
      }
    }
    return myReturn;
  }
  
  int[] getBoardWeight(boolean me){
    int[] myReturn = new int[6];
    for(int i = 0; i < 6; i++){
      Board testingBoard = copyBoard(this);
      int tempReturn = testingBoard.rotateCups(i,me);
      if(tempReturn > 999){
        int[] nextGetBoardWeight = testingBoard.getBoardWeight(me);
        int maxWeight = 0;
        for(int j = 0; j < 6; j++){
          if(nextGetBoardWeight[j] > maxWeight){
            maxWeight = nextGetBoardWeight[j];
          }
        }
        tempReturn+=maxWeight;
      }
      myReturn[i] = tempReturn%1000;
    }
    return myReturn;
  }
  
}

Board copyBoard(Board a){
  Board tempBoard = new Board();
  for(int i = 0; i < 14; i++){
    tempBoard.cups[i] = a.cups[i];
  }
  return tempBoard;
}
