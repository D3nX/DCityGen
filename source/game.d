/*
 * Author: Denis
 * Date: 6/7/23
 * Description: Game class
*/

import raylib;
import astate;
import std.stdio;

class Game {
private:
    AState  state;
    int     width;
    int     height;
    string  title;

public:
    this(int width, int height, string title) {
        this.width = width;
        this.height = height;
        this.title = title;
        SetTraceLogLevel(TraceLogLevel.LOG_WARNING | TraceLogLevel.LOG_ERROR);
        InitWindow(width, height, title.ptr);
        InitAudioDevice();
        SetTargetFPS(144);
        ToggleFullscreen();
        HideCursor();
    }

    ~this() {
        state.destroy();
        CloseWindow();
    }
    
    void setState(AState state) {
        this.state = state;
    }

    void run() {
        while (!WindowShouldClose()) {
            BeginDrawing();
            if (state) {
                state.update(GetFrameTime());
                state.draw();
            }
            SetMousePosition(width / 2, height / 2);
            EndDrawing();
        }
    }
}
