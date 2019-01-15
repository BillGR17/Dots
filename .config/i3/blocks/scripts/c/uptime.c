#include <sys/sysinfo.h>
#include <stdio.h>
int main(){
  struct sysinfo info;
  sysinfo(&info);
  int uptime=info.uptime,h=0,m=0,s=0;
  h=uptime/3600;
  m=(uptime%3600)/60;
  s=(uptime%60)%60;
  printf("%d:%d:%d\n", h,m,s);
}
