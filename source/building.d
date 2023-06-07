/*
 * Author: Denis
 * Date: 6/7/23
 * Description: Building class
*/

import raylib;
import std.stdio;

class Building {
private:
    Model                       model;
    Texture2D                   texture;
    string                      towerPath;
    string                      texturePath;
    Vector3                     position;
    Vector3                     offset;
    float                       scale;
    Color                       color;
    static Model[string]        models = null;
    static Texture2D[string]    textures = null;

public:
    this(string towerPath, string texturePath, Vector3 position, Vector3 offset, float scale) {
        if (!models || !textures) {
            models = new Model[string];
            textures = new Texture2D[string];
        }
        this.towerPath = towerPath;
        this.texturePath = texturePath;
        this.position = position;
        this.offset = offset;
        this.scale = scale;
        this.color = Colors.WHITE;
        if (!(towerPath in models))
            models[towerPath] = LoadModel(towerPath.ptr);
        model = models[towerPath];
        if (this.towerPath.length > 0) {
            if (!(texturePath in textures))
                textures[texturePath] = LoadTexture(texturePath.ptr);
            texture = textures[texturePath];
            model.materials[0].maps[MATERIAL_MAP_DIFFUSE].texture = texture;
        }
    }

    void draw() {
        position.x += offset.x;
        position.y += offset.y;
        position.z += offset.z;
        DrawModel(model, position, scale, color);
        position.x -= offset.x;
        position.y -= offset.y;
        position.z -= offset.z;
    }

    void setPosition(Vector3 position) {
        this.position = position;
    }

    void setScale(float scale) {
        this.scale = scale;
    }

    void setOffset(Vector3 offset) {
        this.offset = offset;
    }

    void setColor(Color color) {
        this.color = color;
    }

    Vector3 getPosition() {
        return position;
    }

    float getScale() {
        return scale;
    }

    Vector3 getOffset() {
        return offset;
    }

    Color getColor() {
        return model.materials[0].maps[MATERIAL_MAP_DIFFUSE].color;
    }
}
