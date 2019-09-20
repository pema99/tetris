//Frame count for timing
int frames = 0;

//Grid info
int gridWidth = 10;
int gridHeight = 20;
int tileSize = 40;
int[][] grid;

//Current and next tetromino
Tetromino current;
Tetromino next;

//State variables
boolean bottom = false;
boolean fast = false;
int tuckFrames = 0;
boolean tucking = false;

//Score and level
int score = 0;
int lines = 0;
int level = 1;
int framesPerCell = 48;
int fastFramesPerCell = 3;

void setup()
{
    surface.setSize(gridWidth*tileSize + 150, gridHeight*tileSize);
    
    grid = new int[gridWidth][gridHeight];
    
    current = MakeTetromino();
    next = MakeTetromino();
}

void draw()
{
    //Backbuffer
    background(255);
    frames++;
    
    //Draw UI
    pushMatrix();
    translate(gridWidth*tileSize, 0);
    textSize(15);
    text("Score", 10, 15);
    textSize(30);
    text(score, 10, 45);
    textSize(15);
    text("Level", 10, 80);
    textSize(30);
    text(level, 10, 110);
    textSize(15);
    text("Next", 10, 145);
    translate(-145, 160);
    next.draw();
    popMatrix();
    
    //Draw board
    for (int x = 0; x < gridWidth; x++)
    {
        for (int y = 0; y < gridHeight; y++)
        {
            if (grid[x][y] > 0)
            {
                fill(0, 0, 255);   
            }
            else
            {
                fill(255);   
            }
            rect(x*tileSize, y*tileSize, tileSize, tileSize);   
        }
    }
    
    //Draw current tetromino
    current.draw();
    
    //Decrement tucking frames
    if (tuckFrames > 0)
    {
        tuckFrames--;   
    }
    
    //Update tetromino, check collision. If we are bottoming out, repeat until we hit something.
    do 
    {
        //Check collision
        boolean hit = false;
        for (Brick b : current.bricks)
        {
            //Bottom
            if (b.y + 1 >= gridHeight)
            {
                hit = true;
                break;
            }
            //Hit
            if (grid[b.x][b.y + 1] > 0)
            {
                hit = true;
                break;
            } 
        }
        
        //Start tucking if we just hit the bottom
        if (hit && !tucking)
        {
            tucking = true;
            tuckFrames = framesPerCell;
        }
        
        //If we are at the bottom and we are done tucking or we are bottoming out, spawn next tetromino
        if (tucking && tuckFrames == 0 || tucking && bottom)
        {   
            //Block might have moved to a place where it can go further down, if so let it go
            if (hit)
            {
                for (Brick b : current.bricks)
                {
                    grid[b.x][b.y] = 1;   
                }
                current = next;
                next = MakeTetromino();
                bottom = false;        
                for (Brick b : current.bricks)
                {
                    //Game over
                    if (grid[b.x][b.y] > 0)
                    {
                        grid = new int[gridWidth][gridHeight];
                        score = 0;
                        lines = 0;
                        level = 1;
                        framesPerCell = 48;
                        break;
                    }
                }
            }
            tucking = false;
        }
        
        //If there is no collision and it is time to move tetromino, move tetromino
        if (!hit && ((frames % framesPerCell == 0) || (frames % min(framesPerCell, fastFramesPerCell) == 0 && fast) || bottom))
        {
            for (Brick b : current.bricks)
            {
                b.y++;   
            }
        }     
    } 
    while(bottom);
    
    //Remove lines if necessary, max of 4 per frame (tetris)
    int combo = 0;
    for (int k = 0; k < 4; k++)
    {
        for (int i = 0; i < gridHeight; i++)
        {
            boolean line = true;
            for (int j = 0; j < gridWidth; j++)
            {
                if (grid[j][gridHeight-1-i] == 0)
                {
                    line = false;
                    break;
                }
            }
            if (line)
            {
                combo++;
                Line(i);
                break;
            }
        }
    }
    
    //Add score
    switch (combo)
    {
        case 0:
            break; 
            
        case 1:
            score += 40 * level;
            break; 
            
        case 2:
            score += 100 * level;
            break; 
            
        case 3:
            score += 300 * level;
            break; 
            
        case 4:
            score += 1200 * level;
            break; 
    }
    
    //Level logic
    lines += combo;
    if (lines >= level * 10 + 10)
    {
        lines -= level * 10 + 10;
        level++;
        //Behold my magical formula
        framesPerCell = (int)(-4e-06*pow(level, 6) + 
                              0.0004*pow(level, 5) - 
                              0.016*pow(level, 4) + 
                              0.2878*pow(level, 3) -
                              2.2049*pow(level, 2) +
                              1.5096*level +
                              47.649);
    }
}

//Move block
void keyPressed()
{
    //Move left
    if (keyCode == LEFT)
    {
        boolean canMove = true;
        for (Brick b : current.bricks)
        {
            if (!IsValid(b.x - 1, b.y))
            {
                canMove = false;
                break;
            }
        }
        if (canMove)
        {
            for (Brick b : current.bricks)
            {
                b.x--;
            }
        }
    }
    //Move right
    if (keyCode == RIGHT)
    {
        boolean canMove = true;
        for (Brick b : current.bricks)
        {
            if (!IsValid(b.x + 1, b.y))
            {
                canMove = false;
                break;
            }
        }
        if (canMove)
        {
            for (Brick b : current.bricks)
            {
                b.x++;
            }
        }
    }  
    //Rotate
    if (keyCode == UP)
    {        
        if (current.pivot != null)
        {
            boolean canRotate = true;
            for (Brick b : current.bricks)
            {
                int dx = - (b.y - current.pivot.y);
                int dy = b.x - current.pivot.x;
                
                if (!IsValid(current.pivot.x + dx, current.pivot.y + dy))
                {
                    canRotate = false;
                    break;
                }
            }
            if (canRotate)
            {
                for (Brick b : current.bricks)
                {
                    int dx = - (b.y - current.pivot.y);
                    int dy = b.x - current.pivot.x;
                    
                    b.x = current.pivot.x + dx;
                    b.y = current.pivot.y + dy;
                }
            }
        }
    }
    //Bottom
    if (key == ' ')
    {
        bottom = true;
    }
    //Fast
    if (keyCode == DOWN)
    {
        fast = true;   
    }
}

void keyReleased()
{
    //Fast
    if (keyCode == DOWN)
    {
        fast = false;   
    }   
}

//Check if a position is valid and unoccupied
boolean IsValid(int x, int y)
{
    if (x < 0 || x >= gridWidth || y < 0 || y >= gridHeight)
    {
        return false;   
    }
    if (grid[x][y] > 0)
    {
        return false;
    }
    return true;
}

//Remove a line
void Line(int start)
{
    for (int i = start; i < gridHeight - 1; i++)
    {
        for (int j = 0; j < gridWidth; j++)
        {
            grid[j][gridHeight-1-i] = grid[j][gridHeight-2-i];   
        }
    }
}
