#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <X11/Xlib.h>
Display* d;
Window w;
XEvent e;
XGCValues v;
XFontStruct* f;
Atom a;
GC gc;
short int s, terminate = 0, w_w = 400, w_h = 200;
// Print error and end process
void onError(char* t, int c) {
  fprintf(stderr, "%s\n", t);
  exit(c);
}
// Adding button[s]
void button(char* txt, int x, int y, void (*func)()) {
  // Split width per button
  int x_max = w_w / 2;
  // Draw border
  XDrawRectangle(d, w, gc, x, y, x_max, w_h);
  // Draw text also center it vertically and horizontally
  XDrawString(d, w, gc, x - ((XTextWidth(f, txt, strlen(txt)) - x_max) / 2), y + w_h / 2, txt, strlen(txt));
  // Get cursor location
  int r_x, r_y, wm_x, wm_y;
  Window r_w, r_c;
  unsigned int m;
  XQueryPointer(d, w, &r_w, &r_c, &r_x, &r_y, &wm_x, &wm_y, &m);
  if ((x < wm_x && (x + x_max) > wm_x) && (y < wm_y && (y + w_h) > wm_y) && (e.type == ButtonRelease)) { func(d); }
}
// System shutdown
void shutitdown() {
  system("/usr/bin/poweroff");
}
// End process
void destroy() {
  terminate = 1;
}
// Handle Xorg errors
int handler(Display* d, XErrorEvent* e) {
  short int buffer = 1024;
  char msg[buffer];
  XGetErrorText(d, e->error_code, msg, buffer);
  fprintf(stderr, "%s\n", msg);
  return e->type;
}
int main(void) {
  char* btn = getenv("BLOCK_BUTTON");
  if (btn != NULL && atoi(btn) == 1) {
    // Check for errors
    XSetErrorHandler(handler);
    // Set display
    d = XOpenDisplay(NULL);
    if (d == NULL) { onError("Cant open display", 1); }
    // Set font
    f = XLoadQueryFont(d, "*-hack-medium-r-normal-*");
    if (d == NULL) { onError("Cant load font", 2); }
    // Find default screen [start the window there]
    s = DefaultScreen(d);
    // Create window
    w = XCreateSimpleWindow(d, RootWindow(d, s), 0, 0, w_w, w_h, 1, BlackPixel(d, s), WhitePixel(d, s));
    // Place new window on screen
    gc = XCreateGC(d, w, 0, &v);
    XMapWindow(d, w);
    XSetFont(d, gc, f->fid);
    XStoreName(d, w, "Shutdown PC");
    XSelectInput(d, w, ExposureMask | KeyPressMask | ButtonReleaseMask | ButtonPressMask);
    while (1) {
      if (e.type == KeyPress || terminate) break;
      XNextEvent(d, &e);
      button("System Shutdown", 0, 0, shutitdown);
      button("Close Window", 200, 0, destroy);
    }
    XCloseDisplay(d);
  }
  return 0;
}
