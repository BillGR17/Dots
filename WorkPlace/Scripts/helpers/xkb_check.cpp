// clang++ -std=c++23 -O3 xkb_check.cpp -o xkb_check -lX11 -lxkbfile
#include <print>
#include <vector>
#include <string_view>
#include <ranges>
#include <algorithm>
#include <memory>
#include <X11/XKBlib.h>
#include <X11/extensions/XKBrules.h>

struct DisplayDeleter {
  void operator()(Display *d) const {
    if (d)
      XCloseDisplay(d);
  }
};

using UniqueDisplay = std::unique_ptr<Display, DisplayDeleter>;

int main() {
  UniqueDisplay dpy(XOpenDisplay(nullptr));
  if (!dpy) {
    std::println(stderr, "Cannot open display");
    return 1;
  }

  XkbStateRec state;
  XkbGetState(dpy.get(), XkbUseCoreKbd, &state);

  XkbRF_VarDefsRec vd;
  if (!XkbRF_GetNamesProp(dpy.get(), nullptr, &vd)) {
    std::println(stderr, "Cannot get XKB names");
    return 1;
  }

  // RAII wrapper to ensure XFree is called on vd.layout
  auto layout_guard = std::unique_ptr<char, decltype([](char *p) {
                                        if (p)
                                          XFree(p);
                                      })>(vd.layout);

  if (!vd.layout)
    return 1;

  // Split layout string by comma and skip to the active group index
  auto layouts_view = std::string_view(vd.layout) | std::views::split(',');
  auto active_layout_view = layouts_view | std::views::drop(state.group);

  if (!active_layout_view.empty()) {
    auto result_range = active_layout_view.front();
    std::println("{}", std::string_view(result_range.begin(), result_range.end()));
  }

  return 0;
}
