#include <stdio.h>
#include <stdlib.h>
#include <string.h>
char h[] = "Specify What you need to "
           "confing\n[ng=nginx]\n[ap=apache]\n[i3=i3wm]\n[vi=nvim]\n[ra=ranger]\n[tm=tmux]\n[zh=zsh]\n[xr=xterm]\n[co="
           "compton]\n[du=dunst]";
void exec(char x[]) {
  char c[100];
  sprintf(c, "nvim %s", x);
  system(c);
}
void list(char s[]) {
  if (strcmp(s, "i3") == 0) {
    exec("~/.config/i3/config");
  } else if (strcmp(s, "vi") == 0) {
    exec("~/.config/nvim/init.vim");
  } else if (strcmp(s, "ra") == 0) {
    exec("~/.config/ranger/rc.conf");
  } else if (strcmp(s, "ng") == 0) {
    exec("/etc/nginx/nginx.conf&&systemctl restart nginx.service");
  } else if (strcmp(s, "ap") == 0) {
    exec("/etc/httpd/conf/httpd.conf&&systemctl restart httpd.service");
  } else if (strcmp(s, "co") == 0) {
    exec("~/.config/compton/compton.conf");
  } else if (strcmp(s, "du") == 0) {
    exec("~/.config/dunst/dunstrc");
  } else if (strcmp(s, "tm") == 0) {
    exec("~/.tmux.conf");
  } else if (strcmp(s, "zh") == 0) {
    exec("~/.zshrc");
  } else if (strcmp(s, "xr") == 0) {
    exec("~/.Xresources&&xrdb -merge ~/.Xresources");
  } else {
    puts(h);
  }
}
int main(int argc, char* argv[]) {
  if (argc == 2) {
    list(argv[1]);
  } else {
    puts(h);
    return 1;
  }
  return 0;
}
