//One tetromino
class Tetromino
{
    Brick[] bricks;
    Brick pivot;
    
    Tetromino(Brick[] bricks, Brick pivot)
    {
        this.bricks = bricks;
        this.pivot = pivot;
    }
    
    void draw()
    {
        for (Brick b : bricks)
        {
            b.draw();   
        }
    }
}

//Returns a tetromino
Tetromino MakeTetromino()
{
    Brick[] result = new Brick[4];
    Brick pivot = null;
    switch ((int)random(7))
    {
        case 0:
            result[0] = new Brick(4, 0);
            result[1] = new Brick(4, 1);
            result[2] = new Brick(4, 2);
            result[3] = new Brick(4, 3);
            pivot = result[1];
            break;
            
        case 1:
            result[0] = new Brick(4, 0);
            result[1] = new Brick(4, 1);
            result[2] = new Brick(5, 0);
            result[3] = new Brick(5, 1);
            pivot = null;
            break;
            
        case 2:
            result[0] = new Brick(4, 0);
            result[1] = new Brick(5, 0);
            result[2] = new Brick(6, 0);
            result[3] = new Brick(5, 1);
            pivot = result[3];
            break;
            
        case 3:
            result[0] = new Brick(4, 0);
            result[1] = new Brick(5, 0);
            result[2] = new Brick(6, 0);
            result[3] = new Brick(4, 1);
            pivot = result[1];
            break;
            
        case 4:
            result[0] = new Brick(4, 0);
            result[1] = new Brick(5, 0);
            result[2] = new Brick(6, 0);
            result[3] = new Brick(6, 1);
            pivot = result[1];
            break;
            
        case 5:
            result[0] = new Brick(4, 0);
            result[1] = new Brick(5, 0);
            result[2] = new Brick(5, 1);
            result[3] = new Brick(6, 1);
            pivot = result[1];
            break;
        
        case 6:
            result[0] = new Brick(4, 1);
            result[1] = new Brick(5, 1);
            result[2] = new Brick(5, 0);
            result[3] = new Brick(6, 0);
            pivot = result[1];
            break;
    }
    return new Tetromino(result, pivot);
}
