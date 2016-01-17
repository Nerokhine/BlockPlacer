public class Block{
    int ID;
    float len;
    float wid;
    int type;
    float xPos;
    float yPos;
    float speedX;
    float speedY; 
    int moving;

    public Block(int ID, float len, float wid, int type, float xPos, float yPos, float speedX, float speedY, int moving){
        this.ID = ID;
        this.len = len;
        this.wid = wid;
        this.type = type;
        this.xPos = xPos;
        this.yPos = yPos;
        this.speedX = speedX;
        this.speedY = speedY;
        this.moving = moving;
    }
    
    public int getID() {
        return ID;
    }
    
    public float getLen() {
        return len;
    }

    public float getWid() {
        return wid;
    }

    public int getType() {
        return type;
    }

    public float getxPos() {
        return xPos;
    }

    public float getyPos() {
        return yPos;
    }
    
    public float getSpeedX() {
        return speedX;
    }
    
    public float getSpeedY() {
        return speedY;
    }
    
    public int getMoving() {
        return moving;
    }
    
    public void setID(int ID) {
        this.ID = ID;
    }
    
    public void setLen(float len) {
        this.len = len;
    }

    public void setWid(float wid) {
        this.wid = wid;
    }

    public void setType(int type) {
        this.type = type;
    }

    public void setxPos(float xPos) {
        this.xPos = xPos;
    }

    public void setyPos(float yPos) {
        this.yPos = yPos;
    }

    public void setSpeedX(float speedX) {
        this.speedX = speedX;
    }
    
    public void setSpeedY(float speedY) {
        this.speedY = speedY;
    }
    
    public void setMoving(int moving) {
        this.moving = moving;
    }
    
}
