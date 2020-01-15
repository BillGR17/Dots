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
void onError(char* t, int c) {
  fprintf(stderr, "%s\n", t);
  exit(c);
}
void button(char* txt, int x, int y, void (*func)()) {
  int xx = w_w / 2;
  XDrawRectangle(d, w, gc, x, y, xx, w_h);
  XDrawString(d, w, gc, x - ((XTextWidth(f, txt, strlen(txt)) - xx) / 2), y + w_h / 2, txt, strlen(txt));
  int r_x, r_y, wm_x, wm_y;
  Window r_w, r_c;
  unsigned int m;
  XQueryPointer(d, w, &r_w, &r_c, &r_x, &r_y, &wm_x, &wm_y, &m);
  if ((x < wm_x && (x + xx) > wm_x) && (y < wm_y && (y + w_h) > wm_y) && (e.type == ButtonRelease)) { func(d); }
}
void printit() {
  system("/usr/bin/poweroff");
}
void destroy() {
  terminate = 1;
}
int handler(Display* d, XErrorEvent* e) {
  char msg[256];
  XGetErrorText(d, e->error_code, msg, 256);
  fprintf(stderr, "%s\n", msg);
  return e->type;
}
int main(void) {
  XSetErrorHandler(handler);
  d = XOpenDisplay(NULL);
  if (d == NULL) { onError("Cant open display", 1); }
  f = XLoadQueryFont(d, "*-hack-medium-r-normal-*");
  if (d == NULL) { onError("Cant load font", 2); }
  s = DefaultScreen(d);
  w = XCreateSimpleWindow(d, RootWindow(d, s), 0, 0, w_w, w_h, 1, BlackPixel(d, s), WhitePixel(d, s));
  gc = XCreateGC(d, w, 0, &v);
  XMapWindow(d, w);
  XSetFont(d, gc, f->fid);
  XStoreName(d, w, "Shutdown PC");
  XSelectInput(d, w, ExposureMask | KeyPressMask | ButtonReleaseMask | ButtonPressMask);
  while (1) {
    if (e.type == KeyPress || terminate) break;
    XNextEvent(d, &e);
    button("System Shutdown", 0, 0, printit);
    button("Close Window", 200, 0, destroy);
  }
  XCloseDisplay(d);
  return 0;
}
