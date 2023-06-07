/*
 * Author: Denis
 * Date: 6/7/23
 * Description: GameState class
*/

import game;
import astate;
import raylib;
import std.conv : text;
import std.stdio;
import std.math;
import heightmap;
import building;
import bindbc.opengl;

class GameState : AState {
private:
    Vector3[]   cubePositions;
    Building[]  towers;
    Camera3D    camera;
    Heightmap   map;
    Heightmap   waterMap;
    Building    tower;
    Music       music;
    float       renderingDistance;
    int         timer;
    int         size;

    void placeCities() {
        towers = new Building[0];
        const float scale = 1.0f; // 0.162f;
        for (int i = 0; i < size; i+=4){
            for (int j = 0; j < size; j+=4) {
                float height = map.heightAt(i, j) * 0.06f;
                if (height > 6.5f) {
                    if (GetRandomValue(0, 150) > 147)
                        towers ~= new Building("assets/towers/avengers/avenger.obj",
                                            "",
                                            Vector3(i * scale + cast(float) GetRandomValue(-1, 1) / 2.0f, height, j * scale + cast(float) GetRandomValue(-1, 1) / 2.0f),
                                            Vector3(0.2, 0, -4.7),
                                            0.05f);
                    else
                        towers ~= new Building("assets/towers/city-building/building3.obj",
                                            "assets/towers/city-building/textures/atlas.png",
                                            Vector3(i * scale + cast(float) GetRandomValue(-1, 1) / 2.0f, height, j * scale + cast(float) GetRandomValue(-1, 1) / 2.0f),
                                            Vector3(0.2, 0, -4.7),
                                            0.5f);
                }
            }
        }
    }

    void updateInput(float dt) {
        if (IsKeyDown(KeyboardKey.KEY_SPACE)) {
            // random position
            cubePositions ~= Vector3(
                GetRandomValue(-15, 15),
                GetRandomValue(-15, 15),
                GetRandomValue(-15, 15));
        }

        // Regenerate map if 'R' is pressed
        if (IsKeyPressed(KeyboardKey.KEY_R)) {
            map.regenerate();
            waterMap.regenerate();
            placeCities();
        }

        if (IsKeyDown(KeyboardKey.KEY_KP_ADD)) {
            renderingDistance += 0.5f;
        } else if (IsKeyDown(KeyboardKey.KEY_KP_SUBTRACT)) {
            renderingDistance -= 0.5f;
        }


        UpdateCamera(&camera, CameraMode.CAMERA_FREE);
    }

    void draw3D() {
        
        DrawGrid(100, 1.0f);

        map.setPosition(Vector3(0, 0, -5));
        static int timer = 0;
        timer++;
        waterMap.setPosition(Vector3(0, 6 + sin(cast(float)timer * 0.01) * 0.1f, -5));

        map.draw();
        waterMap.draw();

        for (int i = 0; i < towers.length; i++) {
            // check distance between item and camera
            float dist = Vector3Distance(camera.position, towers[i].getPosition());
            int c = cast(int) (255.0f * (1.0f - dist / renderingDistance) * 3);
            towers[i].setColor(Color( // Change alpha depending on distance
                towers[i].getColor().r,
                towers[i].getColor().g,
                towers[i].getColor().b,
                cast(byte) ((c > 255) ? 255 : c)));
            if (dist < renderingDistance)
                towers[i].draw();
        }
        for (int i = 0; i < cubePositions.length; i++) {
            auto cubePosition = cubePositions[i];
            DrawCube(cubePosition, 2.0f, 2.0f, 2.0f, Colors.RED);
            DrawCubeWires(cubePosition, 2.0f, 2.0f, 2.0f, Colors.MAROON);
        }
    }

public:
    this(Game* game) {
        super(game);
        size = 128;
        map = new Heightmap(size, size, Vector3(size, 48, size), Color(0, 255, 0, 255));
        waterMap = new Heightmap(size, size, Vector3(size, 2, size), Color(64, 64, 255, 128));
        camera.position = Vector3(0.0f, 10.0f, 10.0f);
        camera.target = Vector3(0.0f, 0.0f, 0.0f);
        camera.up = Vector3(0.0f, 1.0f, 0.0f);
        camera.fovy = 45.0f;
        camera.projection = CameraProjection.CAMERA_PERSPECTIVE;
        renderingDistance = 30.0f;
        timer = 0;

        music = LoadMusicStream("assets/musics/advance_australia.ogg");
        PlayMusicStream(music);

        placeCities();
    }

    ~this() {
        map.destroy();
        waterMap.destroy();
        StopMusicStream(music);
        UnloadMusicStream(music);
    }

    override void update(float dt) {
        UpdateMusicStream(music);
        updateInput(dt);
    }

    override void draw() {
        ClearBackground(Color(135, 206, 235)); // skyblue
        BeginMode3D(camera);
        draw3D();
        EndMode3D();

        map.drawTexture();
        DrawRectangle(10, 8, 200, 60, Fade(Colors.BLACK, 0.5f));
        DrawText((cast(string) text("FPS: ", GetFPS())).ptr, 12, 12, 20, Colors.YELLOW);
        DrawText((cast(string) text("Render dist.: ", renderingDistance)).ptr, 12, 36, 20, Colors.YELLOW);
    }
}