#include <stdio.h>
#include <strings.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <linux/limits.h>

int main(int arg,char *argv[]){
  char pwd[PATH_MAX];
  if (getcwd(pwd, sizeof(pwd))== NULL) {
    perror("getpwd() error");
    exit(1);
  }
  char *toexclude[]={
    "node_modules",
    ".git*",
    "CHANGELOG",
    "*eslint*",
    "package-*",
    "yarn*",
    "*~",
    "t.tar.gz"
  };
  char exclude[PATH_MAX];
  for(int i=0;i<sizeof(toexclude)/sizeof(char*);i++){
    sprintf(exclude+strlen(exclude),"'%s',",toexclude[i]);
  }
  for(int i=1;i<arg;i++){
    sprintf(exclude+strlen(exclude),"'%s',",argv[i]);
  }
  char exec[PATH_MAX];
  exclude[strlen(exclude)-1]='\0';
  sprintf(exec,"tar --exclude={%s} -cvf %s/t.tar.gz -C %s .",exclude,pwd,pwd);
  system(exec);
  return 0;
}
