import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_MINES = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r=0; r<NUM_ROWS; r++){
      for(int c=0; c<NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    setMines();
}
public void setMines()
{
    for(int i=0; i<NUM_MINES; i++){
      int row = (int)(Math.random()*NUM_ROWS);
      int col = (int)(Math.random()*NUM_COLS);
      if(! mines.contains(buttons[row][col])){
        mines.add(buttons[row][col]);
      }
    }
}
public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for(int i=0; i<mines.size(); i++){
      if(! mines.get(i).isFlagged()){
        return false;
      }
    }
    for(int r=0; r<NUM_ROWS; r++){
      for(int c=0; c<NUM_COLS; c++){
        if(! mines.contains(buttons[r][c]) && buttons[r][c].isFlagged()){
          return false;
        }
      }
    }
    return true;
}
public void displayLosingMessage()
{
    for(int r=0; r<NUM_ROWS; r++){
      for(int c=0; c<NUM_COLS; c++){
        buttons[r][c].setClicked(true);
        buttons[r][c].setLabel("womp womp");
      }
    }
    for(int i=0; i<mines.size(); i++){
      mines.get(i).setLabel("BOMB");
    }
}
public void displayWinningMessage()
{
    for(int r=0; r<NUM_ROWS; r++){
      for(int c=0; c<NUM_COLS; c++){
        buttons[r][c].setClicked(false);
        buttons[r][c].setLabel("yippee!");
      }
    }
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
      return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1; r < row+2; r++){
      for(int c = col-1; c < col+2; c++){
        if(isValid(r,c) && mines.contains(buttons[r][c])){
          numMines++;
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
          flagged = !flagged;
          clicked = false;
        } else if (mines.contains(this)){
          displayLosingMessage();
        } else if (countMines(this.myRow, this.myCol) > 0){
          this.setLabel(countMines(this.myRow, this.myCol));
        } else {
          for(int r = this.myRow-1; r<this.myRow+2; r++){
            for(int c = this.myCol-1; c<this.myCol+2; c++){
              if(isValid(r,c) && ! buttons[r][c].clicked){
                buttons[r][c].mousePressed();
              }
            }
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );
        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public void setClicked(boolean z)
    {
        clicked = z;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
