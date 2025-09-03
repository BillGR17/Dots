/*
 *
 * wget https://raw.githubusercontent.com/Immediate-Mode-UI/Nuklear/master/demo/glfw_opengl3/nuklear_glfw_gl3.h
 * clang++ -std=c++20 -Wall hyprsysctl.cpp -o hyprsysctl $(pkg-config --static --libs glfw3) -lGLEW -lGL -lm
 *
 */
#define NK_INCLUDE_FIXED_TYPES
#define NK_INCLUDE_STANDARD_IO
#define NK_INCLUDE_STANDARD_VARARGS
#define NK_INCLUDE_DEFAULT_ALLOCATOR
#define NK_INCLUDE_VERTEX_BUFFER_OUTPUT
#define NK_INCLUDE_FONT_BAKING
#define NK_INCLUDE_DEFAULT_FONT

#define NK_IMPLEMENTATION
#define NK_GLFW_GL3_IMPLEMENTATION

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <nuklear.h>
#include "nuklear_glfw_gl3.h"

#define WINDOW_WIDTH 400
#define WINDOW_HEIGHT 100
#define MAX_VERTEX_BUFFER 512 * 1024
#define MAX_ELEMENT_BUFFER 128 * 1024

static void error_callback(int e, const char *d) { printf("Error %d: %s\n", e, d); }

int main(void) {
  struct nk_context *ctx;
  struct nk_glfw glfw = {0};
  GLFWwindow *win;

  glfwSetErrorCallback(error_callback);
  if (!glfwInit()) {
    fprintf(stdout, "[GFLW] failed to init!\n");
    exit(1);
  }
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);

  glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);

  win = glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Hyprland System Logout", NULL, NULL);
  glfwMakeContextCurrent(win);
  glfwSwapInterval(1);

  glewExperimental = 1;
  if (glewInit() != GLEW_OK) {
    fprintf(stderr, "Failed to setup GLEW\n");
    exit(1);
  }

  ctx = nk_glfw3_init(&glfw, win, NK_GLFW3_INSTALL_CALLBACKS);

  struct nk_font_atlas *atlas;
  nk_glfw3_font_stash_begin(&glfw, &atlas);
  nk_glfw3_font_stash_end(&glfw);

  struct nk_colorf bg = {0.1f, 0.1f, 0.1f, 1.0f};

  while (!glfwWindowShouldClose(win)) {
    glfwPollEvents();
    nk_glfw3_new_frame(&glfw);

    int display_w, display_h;
    glfwGetWindowSize(win, &display_w, &display_h);

    if (nk_begin(ctx, "LogoutUI", nk_rect(0, 0, display_w, display_h), NK_WINDOW_NO_SCROLLBAR)) {
      const int button_count = 4;
      const float button_width = 85;
      const float button_height = 40;
      const float padding = 10;

      const float total_buttons_width = button_count * button_width;
      const float total_padding_width = (button_count - 1) * padding;
      const float total_block_width = total_buttons_width + total_padding_width;

      float start_x = (display_w - total_block_width) / 2.0f;
      float start_y = (display_h - button_height) / 2.0f;

      nk_layout_space_begin(ctx, NK_STATIC, display_h, button_count);

      nk_layout_space_push(ctx, nk_rect(start_x, start_y, button_width, button_height));
      if (nk_button_label(ctx, "Shutdown")) {
        system("systemctl poweroff");
        glfwSetWindowShouldClose(win, GLFW_TRUE);
      }

      nk_layout_space_push(ctx, nk_rect(start_x + (button_width + padding), start_y, button_width, button_height));
      if (nk_button_label(ctx, "Reboot")) {
        system("systemctl reboot");
        glfwSetWindowShouldClose(win, GLFW_TRUE);
      }

      nk_layout_space_push(ctx, nk_rect(start_x + 2 * (button_width + padding), start_y, button_width, button_height));
      if (nk_button_label(ctx, "Logout")) {
        system("hyprctl dispatch exit");
        glfwSetWindowShouldClose(win, GLFW_TRUE);
      }

      nk_layout_space_push(ctx, nk_rect(start_x + 3 * (button_width + padding), start_y, button_width, button_height));
      if (nk_button_label(ctx, "Close")) {
        glfwSetWindowShouldClose(win, GLFW_TRUE);
      }

      nk_layout_space_end(ctx);
    }
    nk_end(ctx);

    glViewport(0, 0, display_w, display_h);
    glClearColor(bg.r, bg.g, bg.b, bg.a);
    glClear(GL_COLOR_BUFFER_BIT);

    nk_glfw3_render(&glfw, NK_ANTI_ALIASING_ON, MAX_VERTEX_BUFFER, MAX_ELEMENT_BUFFER);
    glfwSwapBuffers(win);
  }

  nk_glfw3_shutdown(&glfw);
  glfwTerminate();
  return 0;
}
