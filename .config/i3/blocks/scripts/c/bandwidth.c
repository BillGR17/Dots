#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
long long int u=0,d=0;

long long int readf(const char *x){
  long long int r=0;
  FILE *fp = fopen(x, "r");
  if (fp == NULL){
    perror("Error while opening the file.\n");
    exit(EXIT_FAILURE);
  }
  fscanf(fp,"%lld",&r);
  fclose(fp);
  return r;
}

int main(){
  const char *e=getenv("BLOCK_INSTANCE");
  char tu[256];
  char td[256];
  sprintf(td,"/sys/class/net/%s/statistics/rx_bytes",e);
  sprintf(tu,"/sys/class/net/%s/statistics/tx_bytes",e);
  long long int _u=0,_d=0;
  while(1){
    d=readf(td);u=readf(tu);
    if(_d>0){
      printf(":%.2fmb :%.2fmb",(float)(d-_d)/1024/1024,(float)(u-_u)/1024/1024);
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
