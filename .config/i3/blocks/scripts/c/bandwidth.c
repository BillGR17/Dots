#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
long long int u=0,d=0;

long long int grep(const char *x,int l){
  char ln[255];
  long long int r=0;
  FILE *fp = fopen("/proc/net/dev", "r");  
  if (fp == NULL){
    perror("Error while opening the file.\n");
    exit(EXIT_FAILURE);
  }
  while(fgets(ln,255,fp)){
    if(strstr(ln,x)!=0){
      char *p = strtok (ln, " ");
      int i=0;
      char *array[20]; 
      while (p != NULL){
        array[i++] = p;
        p = strtok (NULL, " ");
      }
      r=atoll(array[l]);
    }
  }
  fclose(fp);
  return r;
}

int main(){
  const char *e=getenv("BLOCK_INSTANCE");
  long long int _u=0,_d=0;
  while(1){
    d=grep(e,1);u=grep(e,9);
    if(_d>0){
      printf("D:%.2fmb U:%.2fmb",(float)(d-_d)/1024/1024,(float)(u-_u)/1024/1024);
      fflush(stdout);
    }else{
      printf("Initializing...");
      fflush(stdout);
    }
    _u=u;_d=d;
    sleep(1);
  }
  return 0;
}
