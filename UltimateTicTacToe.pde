

class Message {
  int x, y, mWidth, mHeight;
  String s;
  int [] RGBBackground;
  public Message (int xLoc, int yLoc, String line) {
    x=xLoc;
    y=yLoc;
    s=line;
    mWidth=550;
    mHeight=100;
    RGBBackground= new int [] {255, 255, 255};//default is white
  }
  
  public Message (int xLoc, int yLoc, int w, int h, String line) {
    x=xLoc;
    y=yLoc;
    s=line;
    mWidth=w;
    mHeight=h;
    RGBBackground= new int [] {255, 255, 255};//default is white
  }
  
    public Message (int xLoc, int yLoc, int w, int h, String line, int [] rgbbackcolor) {
    x=xLoc;
    y=yLoc;
    s=line;
    mWidth=w;
    mHeight=h;
    RGBBackground= new int [] {rgbbackcolor[0], rgbbackcolor[1], rgbbackcolor[2]};//default is white
  }

  public void display () {
    stroke(0);
    strokeWeight(1);
    fill(RGBBackground[0], RGBBackground[1], RGBBackground[2]);
    rect(x, y, mWidth, mHeight);
    fill(0, 0, 0);
    textSize(20);
    text(s, x+10, y+30);
  }

  public void setM (String line) {
    s=line;
  }
  public boolean click (int tx, int ty) {
    int mx = tx;
    int my = ty;

    // checks to see if the message was clicked.
    if (mx > x && mx< x + mWidth && my > y && my < y + mHeight) {
      return true;
    }
    return false;
  }
}
public class Cell {
  // A cell object knows about its location in the grid 
  // as well as its size with the variables x,y,w,h
  // as well as it's state (O = empty, 1 = X, 2 = O)

  private float x, y;   // x,y location
  private float w, h;   // width and height
  private int state=0;
  private int r,g,b=255;
  // Cell Constructor
  public Cell(float tempX, float tempY, float tempW, float tempH) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
  } 

  public boolean click (int tx, int ty) {
    int mx = tx;
    int my = ty;
    // checks to see if the cell was clicked.
    if (mx > x && mx< x + w && my > y && my < y + h) {

      // Looks at who the player is and to see if the square is open
      //if player 1 circle clicks
      if (player == 0 && state == 0) {
        state = 1;
        player = 1;
        mainMsg.setM("Player 2's Turn (Red X)");
        
      } else if (player == 1 && state ==0) {
        state = 2;
        player = 0;
        mainMsg.setM("Player 1's Turn (Blue O)");
      }
      turns++;
      return true;
    }
    return false;
  }

  public void clean() {
    state = 0;
  }

  public int checkState() {
    return state;
  }

  public float checkX() {
    return x;
  }

  public float checkY() {
    return y;
  }
  
  public void setRGB(int r, int g, int b){
    this.r=r;
    this.g=g;
    this.b=b;
  }
  
  public void setRGB(int [] rgb){
    this.r=rgb[0];
    this.g=rgb[1];
    this.b=rgb[2];
  }

  public void display() {
    stroke(0);
    strokeWeight(1);
    fill(r,g,b);
    rect(x, y, w, h); 
    if (state == 1 ) { // makes an O
      ellipseMode(CORNER);
      stroke(0, 0, 255);
      strokeWeight(5);
      ellipse(x, y, w, h);
    } else if (state == 2) { // makes an X
      stroke(255, 0, 0);
      strokeWeight(5);
      line(x, y, x+w, y+h);
      line(x+w, y, x, y+h);
    }
  }
}

public class Board {
  private float xLoc;
  private float yLoc;
  private float cellSize;
  private int rows;
  private int cols;
  private Cell[][] theCells;
  private boolean highlight=false;
  private int state;
  private  int lastR=-1;
  private int lastC=-1;
  //winning state that indicate which player won the board game, to save calculation in ultimate game
  private int winstatus=0; //0 is no one win, 1 is X, 2 is O
  private int markedcells=0;
  private int [] highlightcolor = new int[]{255, 255, 0};
  private int[]  Owiningcolor = new int[]{255, 102, 102};
  private int[]  Xwiningcolor = new int[]{51, 153, 255};
  private int[]  Drawcolor = new int[]{204, 204, 179};
    
  public Board() {
    xLoc = 0;
    yLoc = 0;
    cellSize = 100; 
    rows = cols = 3;
    // initalize theBoard
    theCells=new Cell[rows][cols];
    // fill theBoard with the appropriate Cell objects
    for (int i=0; i<theCells.length; i++) {
      for (int j=0; j<theCells[0].length; j++) {
        theCells[i][j]=new Cell(j*cellSize, i*cellSize, cellSize, cellSize);
      }
      winstatus=0;
      markedcells=0;
    }
  }
  
  public void Reset()
  {
    winstatus=0;
    markedcells=0;
  }
  

  public Board(float xLoc, float yLoc, int c) {
    this.xLoc = xLoc;
    this.yLoc = yLoc;
    cellSize = c; 
    rows = cols = 3;
    // initalize theBoard
    theCells=new Cell[rows][cols];
    // fill theBoard with the appropriate Cell objects
    for (int i=0; i<theCells.length; i++) {
      for (int j=0; j<theCells[0].length; j++) {
        theCells[i][j]=new Cell(xLoc+j*cellSize, yLoc+i*cellSize, cellSize, cellSize);
      }
      winstatus=0;

    }
  }

  public void setfinalcolor(int status)
  {
       for (int i=0; i<theCells.length; i++) {
          for (int j=0; j<theCells[0].length; j++) {
             if(status==2) {
               theCells[i][j].setRGB(Owiningcolor);  
                theCells[i][j].display();
             }
             else if(status==1) {
                //theCells[i][j].setRGB(51, 153, 255);
                theCells[i][j].setRGB(Xwiningcolor);
                theCells[i][j].display();
             }
             else if(status<0) {
                //theCells[i][j].setRGB(204, 204, 179);
                theCells[i][j].setRGB(Drawcolor);
               theCells[i][j].display();
            }
          }
       }
  }

  public int[] getRGBXWinningColor()
  {
    return Xwiningcolor;
  }
  
  public int[] getRGBOWinningColor()
  {
    return Owiningcolor;
  }
  
  public int[] getRGBXODrawColor()
  {
    return Drawcolor;
  }
  
  public void display() {
    //highlight board cells
    if (highlight) {
      for (int i=0; i<theCells.length; i++) {
        for (int j=0; j<theCells[0].length; j++) {
          theCells[i][j].setRGB(highlightcolor);
        }
      }
    } else {
      for (int i=0; i<theCells.length; i++) {
        for (int j=0; j<theCells[0].length; j++) {
          theCells[i][j].setRGB(255, 255, 255);
        }
      }
    }
    // loop through each Cell in theBoard and call the Cell display function
    for (int i=0; i<theCells.length; i++) {
      for (int j=0; j<theCells[0].length; j++) {
        theCells[i][j].display();
      }
    }
    //border around board
    strokeWeight(5);
    stroke(0, 0, 0);
    noFill();
    rect(xLoc, yLoc, cellSize*3, cellSize*3);
    if (win()!=0) {
      state=win();
      //draw big x or big o over board //draw big X may mix up with past moves, try color code
      //if (state == 1 ) { // makes an 0
        //ellipseMode(CORNER);
        //stroke(0, 0, 255);
        //strokeWeight(5);
        //ellipse(xLoc, yLoc, (int)cellSize*3, (int)cellSize*3);
       // setwinningcolor(state);
      //} else if (state == 2) { // makes an X
        //stroke(255, 0, 0);
        //strokeWeight(5);
        //line(xLoc, yLoc, xLoc+(int)cellSize*3, yLoc+(int)cellSize*3);
        //line(xLoc+(int)cellSize*3, yLoc, xLoc, yLoc+(int)cellSize*3);
       // setwinningcolor(state);
      //}
      //use a color that is close seems working better
      setfinalcolor(state);
    }
  }

  // include the following getter methods
  public Cell [][] getBoard() {
    return theCells;
  }
  public int getRows() {
    return rows;
  }
  public int getCols() {
    return cols;
  }
  public int getLastR() {
    return lastR;
  }
  public int getLastC() {
    return lastC;
  }
  public void setHighlight(boolean h) {
    highlight=h;
  }

  public int win() {
    if(winstatus>0)
        return  winstatus;
        
    //check diagonal top left to bottom right
    if (theCells[0][0].checkState()!=0&&theCells[0][0].checkState()==theCells[1][1].checkState()&& theCells[0][0].checkState()==theCells[2][2].checkState()) {
      winstatus=theCells[0][0].checkState();
      return winstatus;
    }
    //check diagonal bottom left to top right
    if (theCells[2][0].checkState()!=0&&theCells[2][0].checkState()==theCells[1][1].checkState()&& theCells[2][0].checkState()==theCells[0][2].checkState()) {
      winstatus=theCells[2][0].checkState();
      return winstatus;
    }
    for (int i=0; i<playBoard.getRows(); i++) {
      //check row win
      if (theCells[i][0].checkState()!=0&&theCells[i][0].checkState()==theCells[i][1].checkState()&& theCells[i][0].checkState()==theCells[i][2].checkState()) {
        winstatus=theCells[i][0].checkState();
        return winstatus;
      }
      //check column win
      if (theCells[0][i].checkState()!=0&&theCells[0][i].checkState()==theCells[1][i].checkState()&& theCells[0][i].checkState()==theCells[2][i].checkState()) {
        winstatus=theCells[0][i].checkState();
        return winstatus;
      }
    }
    //if all 9 cells are marked, it is a draw
    if (markedcells>=9) {
      //println("all cells are marked. Game could not go on");
      return -1;
    } else {
      //println("empty cell exists");
      return 0;
    }
  }
  //if click is valid (clicked inside the board and the board is not won by anyplayer), return true, otherwise return false
  public boolean click (int tx, int ty) {
    int mx = tx;
    int my = ty;
    int w=(int)cellSize*3;

    // checks to see if the cell was clicked.
    if (mx > xLoc && mx< xLoc + w && my > yLoc && my < yLoc + w) {
      // only allow play when nobody has won yet
      if (win()==0) {
        boolean foundwhereclicked=false;
        for (int i=0; i<getRows() &&!foundwhereclicked; i++) {
          for (int j=0; j<getRows(); j++) {
            //getBoard()[i][j].click(mouseX, mouseY);
            if (getBoard()[i][j].click(mouseX, mouseY)) {
              lastR=i;
              lastC=j;
              print("board cell, row=",lastR, "column=",lastC);
              markedcells++;//increase number marked cells
              foundwhereclicked=true;
              break;
            }
          }
        }
        return true;
      }
    }
    lastR=-1;
    lastC=-1;
    return false;
  }
}

class UltimateTTT { //<>//

  private Board[][] ultGame=new Board[3][3];
  private int targetR, targetC;
  private int xoffset=100;

  public UltimateTTT() {
    //make nine boards
    for (int i=0; i<3; i++) {
      for (int j=0; j<3; j++) {
        ultGame[i][j]=new Board(xoffset+j*150, i*150, 50);
      }
    }
  }
  
  public void display() {
    if (ultTTT) {
      for (Board[] arr : ultGame) {
        for (Board b : arr) {
          b.setHighlight(false);
          b.display();
          fill(0, 0, 0);
          textSize(20);
          text("if board is highlighted yellow, next move must be inside it", 10, 615);
        }
      }
      if (turns>0) {
        if(ultGame[targetR][targetC].win()==0) {
          ultGame[targetR][targetC].setHighlight(true);
          ultGame[targetR][targetC].display();
        }
      }
    }
  }
  
  public int win() {
    //check diagonal top left to bottom right
    if (ultGame[0][0].win()!=0&&ultGame[0][0].win()==ultGame[1][1].win()&& ultGame[0][0].win()==ultGame[2][2].win()) {
      return ultGame[0][0].win();
    }
    //check diagonal bottom left to top right
    if (ultGame[2][0].win()!=0&&ultGame[2][0].win()==ultGame[1][1].win()&& ultGame[2][0].win()==ultGame[0][2].win()) {
      return ultGame[2][0].win();
    }
    for (int i=0; i<playBoard.getRows(); i++) {
      //check row win
      if (ultGame[i][0].win()!=0&&ultGame[i][0].win()==ultGame[i][1].win()&& ultGame[i][0].win()==ultGame[i][2].win()) {
        return ultGame[i][0].win();
      }
      //check column win
      if (ultGame[0][i].win()!=0&&ultGame[0][i].win()==ultGame[1][i].win()&& ultGame[0][i].win()==ultGame[2][i].win()) {
        return ultGame[0][i].win();
      }
    }
    if (turns>54) {
      return -1;
    } else {
      return 0;
    }
  }
  
  public void click(int tx, int ty) {
    int mx = tx;
    int my = ty;
    if (mx > 0 && mx< 450 && my >0 && my < 450) {
      //first move is open to any one
      if (turns==0) {
        boolean foundclick=false;
        for (int i=0; i<3 && !foundclick; i++) {
          for (int j=0; j<3; j++) {
            //ultGame[i][j].click(mx, my);
            if ( ultGame[i][j].click(mx, my)) {
              targetR=ultGame[i][j].getLastR();
              targetC=ultGame[i][j].getLastC();
              println("First run, TargetR=",targetR, "TargetC",targetC);
              foundclick=true;
              break;
            }
          }
        }
      } else  {
        //ultGame[targetR][targetC].click(mx, my);
        //all following moves is sent by previous player
        //except a local board that is won, that is draw, then next player is free to choose whatever board are left
        if(ultGame[targetR][targetC].win()==0) {
          if ( ultGame[targetR][targetC].click(mx, my)) {
            int tempR=ultGame[targetR][targetC].getLastR();
            int tempC=ultGame[targetR][targetC].getLastC();
            targetR=tempR;
            targetC=tempC;
            println("non winning local board,set TargetR=",targetR, "TargetC",targetC);
            }
        }
        else {   
          for (int i=0; i<3; i++) {
            for (int j=0; j<3; j++) {
              if (ultGame[i][j].click(mx, my)) {
                targetR=ultGame[i][j].getLastR();
                targetC=ultGame[i][j].getLastC();
                println("won or draw board, free user choice, set TargetR=",targetR, "TargetC",targetC);
                break;
              }
            }
          }
        }
      }
    }
  }
  
  public Board [][] getBoard() {
    return ultGame;
  }
}

private Board playBoard;
private UltimateTTT ultBoard;
public int player = 0;
public int turns=0;
private Message Xwinlabel, Owinlabel, drawlabel, mainMsg, resetButton, modeButton;
public boolean ultTTT=false;

public void settings() {
  size(650, 700);
}

public void setup() {
  // 1 - Initialize the playboard here
  settings();
  background(50, 180, 255);
  ultBoard=new UltimateTTT();
  playBoard=new Board(160, 25, 100);
  Xwinlabel= new Message(10, 470, 150,40,"X win color", playBoard.getRGBXWinningColor());
  Owinlabel= new Message(210, 470, 150,40,"O win color", playBoard.getRGBOWinningColor());
  drawlabel= new Message(420, 470, 160,40,"XO draw color",playBoard.getRGBXODrawColor());
  mainMsg=new Message(10, 520,620,50, "Player 1's Turn (Blue O)");
  resetButton=new Message(15, 625, 150, 50, "Reset Button");
  modeButton=new Message(200, 625, 300, 50, "Play Ultimate Tic Tac Toe");
}

public void draw() {
  // 2 - decide what color you want the background to be here
  background(50, 180, 255);
  // 3 - call the display function on the playBoard
  Xwinlabel.display();
  Owinlabel.display();
  drawlabel.display();
  mainMsg.display();
  resetButton.display();
  modeButton.display();
  if (ultTTT) {
    ultBoard.display();
  }
  else {
    playBoard.display();
  }
  result();
}

public void newGame() {
  if (!ultTTT) {
    for (int i=0; i<playBoard.getRows(); i++) {
      for (int j=0; j<playBoard.getRows(); j++) {
        playBoard.getBoard()[i][j].clean();
        playBoard.Reset();
      }
      turns=0;
      player=0;
      mainMsg.setM("New Game has begun! Player 1's Turn (Blue O)");
    }
  } else {
    for (int i=0; i<3; i++) {
      for (int j=0; j<3; j++) {
        Board b=ultBoard.getBoard()[i][j];
        for (int r=0; r<playBoard.getRows(); r++) {
          for (int c=0; c<playBoard.getRows(); c++) {
            b.getBoard()[r][c].clean();
          }
          b.Reset();
        }
        turns=0;
        player=0;
        mainMsg.setM("New Game has begun! Player 1's Turn (Blue O)");
      }
    }
  }
}

public void result() {
  if (ultTTT) {
    if (ultBoard.win()==2) {
      mainMsg.setM("Player 2 Wins! (Red X). Click Reset to start new game.");
    }
    else if (ultBoard.win()==1) {
      mainMsg.setM("Player 1 Wins! (Blue O). Click Reset to start new game.");
    }
    else if (ultBoard.win()==-1) {
      mainMsg.setM("Game has ended in draw. Click Reset to start new game.");
    }
  } else {
    if (playBoard.win()==2) {
      mainMsg.setM("Player 2 Wins! (Red X). Click Reset to start new game.");
    }
    else if (playBoard.win()==1) {
      mainMsg.setM("Player 1 Wins! (Blue O). Click Reset to start new game.");
    }
    else if (playBoard.win()==-1) {
      mainMsg.setM("Game has ended in draw. Click Reset to start new game.");
    }
  }
}

void mousePressed() {
  // Loop through each cell in the board.  
  // Call the click function for each cell
  // Pass mouseX and mouseY as the parameters
  //System.out.println("Win =" + win());
  //if (player==1) {
  //  mainMsg.setM("Player 1's Turn (Blue O)");
  //} else {
  //  mainMsg.setM("Player 2's Turn (Red X)");
  //}
  if (resetButton.click(mouseX, mouseY)) {
    newGame();
  }
  else if (modeButton.click(mouseX, mouseY)) {
    ultTTT= !(ultTTT);
    newGame();
    if (ultTTT) {
      modeButton.setM("Play Normal Tic Tac Toe");
    } else {
      modeButton.setM("Play Ultimate Tic Tac Toe");
    }
  }
  else if (ultTTT) {
    ultBoard.click(mouseX, mouseY);
  } else {
    playBoard.click(mouseX, mouseY);
  }
  System.out.println(turns);
}
