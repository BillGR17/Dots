/*
 * Quick tar cvf as t.tar.gz on the current folder.
 * Everything added to tarit will be added as an exclude file&folder 
 * excludes node_modules .git* changelog licence readme eslint package&yarn logs and all files or folders with ~
 */
#include <linux/limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <unistd.h>
int main(int arg, char* argv[]) {
  char pwd[PATH_MAX];
  //Get current path
  if (getcwd(pwd, sizeof(pwd)) == NULL) {
    perror("getpwd() error");
    exit(1);
  }
  //Always exclude self
  char* toexclude[] = { "node_modules", ".git*",    "CHANGELOG", "changelog", "LICENCE", "licence", "README.md",
                        "readme.md",    "*eslint*", "package-*", "yarn*",     "*~",      "t.tar.gz" };
  //Checks and adds other files to exclude if they are any
  char exclude[PATH_MAX];
  int size = sizeof(toexclude) / sizeof(char*);
  for (int i = 1; i < arg; i++) { sprintf(exclude + strlen(exclude), "'%s',", argv[i]); }
  for (int i = 0; i < size; i++) {
    if (i + 1 == size) {
      sprintf(exclude + strlen(exclude), "'%s'", toexclude[i]);
    } else {
      sprintf(exclude + strlen(exclude), "'%s',", toexclude[i]);
    }
  }
  char exec[PATH_MAX];
  sprintf(exec, "tar --exclude={%s} -cvf '%s/t.tar.gz' -C '%s' .", exclude, pwd, pwd);
  system(exec);
  return 0;
}