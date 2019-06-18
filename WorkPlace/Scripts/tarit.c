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
    "changelog",
    "LICENCE",
    "licence",
    "README.md",
    "readme.md",
    "*eslint*",
    "package-*",
    "yarn*",
    "*~",
    "t.tar.gz"
  };
  char exclude[PATH_MAX];
  int size=sizeof(toexclude)/sizeof(char*);
  for(int i=1;i<arg;i++){
    sprintf(exclude+strlen(exclude),"'%s',",argv[i]);
  }
  for(int i=0;i<size;i++){
    if(i+1==size){
      sprintf(exclude+strlen(exclude),"'%s'",toexclude[i]);
    }else{
      sprintf(exclude+strlen(exclude),"'%s',",toexclude[i]);
    }
  }
  char exec[PATH_MAX];
  sprintf(exec,"tar --exclude={%s} -cvf '%s/t.tar.gz' -C '%s' .",exclude,pwd,pwd);
  system(exec);
  return 0;
}
