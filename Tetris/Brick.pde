//One tetromino piece
class Brick
{
    int x;
    int y;
    
    Brick(int x, int y)
    {
        this.x = x;
        this.y = y;
    }
    
    void draw()
    {
        fill(0, 0, 255);
        rect(x*tileSize, y*tileSize, tileSize, tileSize);
    }
}
