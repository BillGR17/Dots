#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// A struct to hold the command details
typedef struct {
  const char *alias;
  const char *description;
  const char *command;
} ConfigCommand;

// Array of all available commands
// Adding a new one is as simple as adding a new line here.
static const ConfigCommand commands[] = {
    {"al", "alacritty", "nvim ~/.config/alacritty/alacritty.toml"},
    {"ap", "apache", "nvim /etc/httpd/conf/httpd.conf && systemctl restart httpd.service"},
    {"du", "dunst", "nvim ~/.config/dunst/dunstrc"},
    {"hy", "hyprland", "nvim ~/.config/hypr/hyprland.conf"},
    {"i3", "i3wm", "nvim ~/.config/i3/config"},
    {"ng", "nginx", "nvim /etc/nginx/nginx.conf && systemctl restart nginx.service"},
    {"pb", "polybar", "nvim ~/.config/polybar/config.ini"},
    {"pi", "picom", "nvim ~/.config/picom/pi.conf"},
    {"ra", "ranger", "nvim ~/.config/ranger/rc.conf"},
    {"ro", "rofi", "nvim ~/.config/rofi/config.rasi"},
    {"tm", "tmux", "nvim ~/.tmux.conf"},
    {"vi", "nvim", "nvim ~/.config/nvim/init.lua"},
    {"wb", "waybar", "nvim ~/.config/waybar/config"},
    {"xr", "xterm", "nvim ~/.Xresources && xrdb -merge ~/.Xresources"},
    {"zh", "zsh", "nvim ~/.zshrc"},
};

// Function to print the help message dynamically
void printHelp() {
  puts("Specify what you need to configure:\n");
  // Calculate the number of commands in the array
  size_t numCommands = sizeof(commands) / sizeof(commands[0]);
  for (size_t i = 0; i < numCommands; ++i) {
    printf("[%s] %s\n", commands[i].alias, commands[i].description);
  }
  printf("\n");
}

int main(int argc, char *argv[]) {
  // Ensure exactly one argument is provided
  if (argc != 2) {
    printHelp();
    return 1;
  }

  const char *inputAlias = argv[1];
  int commandFound = 0;

  // Loop through the commands array to find a match
  size_t numCommands = sizeof(commands) / sizeof(commands[0]);
  for (size_t i = 0; i < numCommands; ++i) {
    if (strcmp(inputAlias, commands[i].alias) == 0) {
      system(commands[i].command);
      commandFound = 1;
      break; // Exit loop once command is found and executed
    }
  }

  // If no match was found after checking all commands, show help
  if (!commandFound) {
    fprintf(stderr, "Error: Unknown alias \"%s\"\n\n", inputAlias);
    printHelp();
    return 1;
  }

  return 0;
}
