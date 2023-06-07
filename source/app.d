import std.stdio;
import game;
import gamestate;
import raylib;
import bindbc.opengl;

void loadOpenGLLib() {
	loadOpenGL();
	if (isOpenGLLoaded()) {
		printf("OpenGL loaded\n");
	} else {
		printf("OpenGL not loaded\n");
	}
}

void main() {
	// SetTraceLogLevel(TraceLogLevel.LOG_WARNING | TraceLogLevel.LOG_ERROR);
	Game game = new Game(1280, 720, "waou");

	game.setState(new GameState(&game));
	game.run();
}
