import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS=5;
private final static int NUM_COLS=5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
   buttons= new MSButton[NUM_ROWS][NUM_COLS];
   for(int r=0;r<NUM_ROWS;r++){
     for(int c=0;c<NUM_COLS;c++){
       buttons[r][c]= new MSButton(r,c);
       
     }
   }
     mines = new ArrayList<MSButton>();

    
    setMines();
}
public void setMines()
{
   mines = new ArrayList<MSButton>();
        while (mines.size() < 3) {
            int r = (int) random(NUM_ROWS);
            int c = (int) random(NUM_COLS);
            MSButton button = buttons[r][c];
            if (!mines.contains(button)) {
                mines.add(button);
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
    for (int r = 0; r < NUM_ROWS; r++) {
            for (int c = 0; c < NUM_COLS; c++) {
                if (!buttons[r][c].isFlagged() && !buttons[r][c].clicked)
                    return false;
            }
        }
        return true;
}
public void displayLosingMessage()
{
  for (MSButton mine : mines) {
            mine.setLabel("*");
        }
}
public void displayWinningMessage()
{
     for (int r = 0; r < NUM_ROWS; r++) {
            for (int c = 0; c < NUM_COLS; c++) {
                if (!mines.contains(buttons[r][c])) {
                    buttons[r][c].setLabel("WIN");
                }
            }
        }
}
public boolean isValid(int r, int c)
{
     return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}
public int countMines(int row, int col)
{
   int numMines = 0;
        for (int dr = -1; dr <= 1; dr++) {
            for (int dc = -1; dc <= 1; dc++) {
                int r = row + dr;
                int c = col + dc;
                if (isValid(r, c) && mines.contains(buttons[r][c])) {
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

    // called by manager
    public void mousePressed () 
    {
       clicked = true;
            if (mouseButton == RIGHT) {
                flagged = !flagged;
                if (!flagged)
                    clicked = false;
            } else {
                if (mines.contains(this)) {
                    displayLosingMessage();
                } else {
                    int numMines = countMines(myRow, myCol);
                    if (numMines > 0) {
                        setLabel(numMines);
                    } else {
                        for (int dr = -1; dr <= 1; dr++) {
                            for (int dc = -1; dc <= 1; dc++) {
                                int r = myRow + dr;
                                int c = myCol + dc;
                                if (isValid(r, c) && !buttons[r][c].clicked) {
                                    buttons[r][c].mousePressed();
                                }
                            }
                        }
                    }
                }
            }
    }
    public void draw () 
    {    
      if (flagged)
                fill(0);
            else if (clicked && mines.contains(this))
                fill(255, 0, 0);
            else if (clicked)
                fill(200);
            else
                fill(100);

            rect(x, y, width, height);
            fill(0);
            text(myLabel, x + width / 2, y + height / 2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
