#include <dirent.h>
#include <errno.h>
#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
void deleteEnd(char* myStr) {
  char* lastslash;
  if ((lastslash = strrchr(myStr, '/'))) { *lastslash = '\0'; }
  return;
}
int isExecutable(const char* path) {
  struct stat buf;
  return stat(path, &buf) == 0 && buf.st_mode & S_IXUSR ? 1 : 0;
}
int isFolder(const char* path) {
  struct stat buf;
  stat(path, &buf);
  return S_ISDIR(buf.st_mode);
}
void cp(char* u, char* r) {
  FILE *uf, *rf;
  char buf[4096];
  printf("%s -> %s\n", u, r);
  uf = fopen(u, "r");
  if (uf == NULL) {
    perror("Couldn't read user file");
    exit(3);
  }
  int retry = 0;
  while (retry < 2) {
    rf = fopen(r, "w+");
    if (errno == 2) {
      retry++;
      errno = 0;
      char dir[500];
      sprintf(dir, "%s", r);
      deleteEnd(dir);
      mkdir(dir, 700);
    } else if (rf == NULL) {
      perror("Couldn't write root file");
      exit(4);
    } else {
      break;
    }
  }
  while (fgets(buf, sizeof(buf), uf) != NULL) { fputs(buf, rf); }
  fclose(rf);
  fclose(uf);
  if (isExecutable(u)) {
    puts("Marked as Executable");
    chmod(r, S_IRWXU);
  }
}
void cp_dir(char* fu, char* fr) {
  DIR* dir;
  if ((dir = opendir(fu)) != NULL) {
    struct dirent* ent;
    while ((ent = readdir(dir)) != NULL) {
      if (strcmp(ent->d_name, ".") != 0 && strcmp(ent->d_name, "..") != 0 && strstr(ent->d_name, "~") == NULL) {
        char c[500], r[500];
        sprintf(c, "%s/%s", fu, ent->d_name);
        sprintf(r, "%s/%s", fr, ent->d_name);
        if (isFolder(c)) {
          mkdir(r, 700);
          cp_dir(c, r);
        } else {
          cp(c, r);
        }
      }
    }
    closedir(dir);
  } else {
    perror("Couldn't readdir");
    exit(5);
  }
}
int main(int argc, char* argv[]) {
  if (argc == 2) {
    if (getpwnam(argv[1]) == NULL || strcmp(argv[1], "root") == 0) {
      puts("Please check the User Name");
      exit(2);
    } else {
      char* files[4] = { ".zshrc", ".tmux.conf", ".Xresources", ".xinitrc" };
      char* folders[6] = { "i3", "nvim", "ranger", "picom", "dunst", "rofi" };
      for (int i = 0; i < 4; i++) {
        char u[128], r[128];
        sprintf(u, "/home/%s/%s", argv[1], files[i]);
        sprintf(r, "/root/%s", files[i]);
        cp(u, r);
        sprintf(u, "/home/%s/.config/%s", argv[1], folders[i]);
        sprintf(r, "/root/.config/%s", folders[i]);
        cp_dir(u, r);
      }
    }
  } else {
    puts("Please execute with a user as argument");
    exit(1);
  }
  return 0;
}
