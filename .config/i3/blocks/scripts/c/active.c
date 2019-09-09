// modified code from https://github.com/UltimateHackingKeyboard/current-window-linux/blob/master/get-current-window.c
#include <X11/Xatom.h>
#include <X11/Xlib.h>
#include <stdio.h>
Display* d;
unsigned long w;
unsigned char* p;
unsigned char* get_string_perty(char* perty_name) {
  Atom actual_type, filter_atom;
  int actual_format;
  unsigned long nitems, bytes_after;
  filter_atom = XInternAtom(d, perty_name, True);
  XGetWindowProperty(
    d, w, filter_atom, 0, 500, False, AnyPropertyType, &actual_type, &actual_format, &nitems, &bytes_after, &p);
  return p;
}
unsigned long get_long_perty(char* perty_name) {
  get_string_perty(perty_name);
  unsigned long long_perty = p[0] + (p[1] << 8) + (p[2] << 16) + (p[3] << 24);
  return long_perty;
}
int main(int argc, char** argv) {
  d = XOpenDisplay(NULL);
  int screen = XDefaultScreen(d);
  w = RootWindow(d, screen);
  w = get_long_perty("_NET_ACTIVE_WINDOW");
  printf("%s\n", get_string_perty("_NET_WM_NAME"));
  fflush(stdout);
  XCloseDisplay(d);
  return 0;
}
