package ai.docty.devicecare;

interface Synthesizer {
    void start();
    void stop();
    int keyDown(int key);
    int keyUp(int key);
}