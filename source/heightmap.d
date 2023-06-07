/*
 * Author: Denis
 * Date: 6/7/23
 * Description: Heightmap class
*/

import raylib;
import std.stdio;

class Heightmap {
private:
    Image       image;
    Texture2D   texture;
    Mesh        mesh;
    Model       model;
    Vector3     position;
    Vector3     size;
    Color       color;
    int         width;
    int         height;
    float       scale;

public:
    this(int width, int height, Vector3 size, Color color) {
        this.width = width;
        this.height = height;
        this.size = size;
        this.color = color;
        regenerate(true);
    }

    ~this() {
        UnloadTexture(texture);
        UnloadModel(model);
        UnloadImage(image);
    }

    void regenerate(bool firstTime = false) {
        if (!firstTime) {
            UnloadImage(image);
            UnloadTexture(texture);
        }
        image = GenImagePerlinNoise(width, height, GetRandomValue(0, 100), GetRandomValue(0, 100), 1.5f);
        ImageColorTint(&image, color);
        texture = LoadTextureFromImage(image);
        mesh = GenMeshHeightmap(image, size);
        model = LoadModelFromMesh(mesh);
        model.materials[0].maps[MATERIAL_MAP_DIFFUSE].texture = texture;
        position = Vector3(0, 0, 0);
        scale = 1.0f;
    }

    void draw() {
        DrawModel(model, position, scale, Colors.WHITE);
    }

    void drawTexture() {
        DrawTexture(texture, 0, 0, Colors.WHITE);
    }

    int heightAt(int x, int y) {
        return GetImageColor(image, x, y).g;
    }

    void setPosition(Vector3 position) {
        this.position = position;
    }

    void setScale(float scale) {
        this.scale = scale;
    }

    Vector3 getPosition() {
        return position;
    }

    float getScale() {
        return scale;
    }

    int getWidth() {
        return width;
    }

    int getHeight() {
        return height;
    }

    Vector3 getSize() {
        return size;
    }

    Color getColor() {
        return color;
    }
}