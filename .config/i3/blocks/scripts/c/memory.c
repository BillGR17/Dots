#include <string.h>
#include <stdio.h>
#include <stdlib.h>
long int grep(char *x){
  char ln[60];
  long int r;
  FILE *fp = fopen("/proc/meminfo", "r");  
  if (fp == NULL){
    perror("Error while opening the file.\n");
    exit(EXIT_FAILURE);
  }
  while(fgets(ln,60,fp)){
    if(strstr(ln,x)!=0){
      sscanf(ln,"%*[^0123456789]%d",&r);
    }
  }
  fclose(fp);
  return r;
}
int main(){
  printf("%.2fgb %.2fgb",(float)grep("MemAvailable")/1024/1024,(float)grep("MemTotal")/1024/1024);
  return 0;
}
