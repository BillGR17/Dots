#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char *exec(const char *x){
  char b[128],*r=malloc(256*sizeof(*r));
  FILE *cmd=popen(x,"r");
  if (cmd == NULL){
    perror("Error while running the command.\n");
    exit(2);
  }
  while(fgets(b,128,cmd)){
    strcpy(r,strtok(b,"\n"));
  }
  pclose(cmd);
  return r;
}

int main(){
  char *e=getenv("BLOCK_INSTANCE");
  if(e==NULL){
    exit(1);
  }
  char cmd[200];
  sprintf(cmd,"upower -e|grep %s|head -1",e);
  char *battery=exec(cmd);
  sprintf(cmd,"upower -i %s|grep time|awk '{print $4 substr($5,1,3)}'",battery);
  free(battery);
  char *time=exec(cmd);
  printf("%s",time);
  fflush(stdout);
  free(time);
  return 0;
}
