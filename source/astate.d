/*
 * Author: Denis
 * Date: 6/7/23
 * Description: Abstract State class
*/

import game;

abstract class AState {
    protected Game* game;

    this(Game* game) {
        this.game = game;
    }

    abstract void update(float dt);
    abstract void draw();
}