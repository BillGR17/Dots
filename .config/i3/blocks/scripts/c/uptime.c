#include <sys/sysinfo.h>
#include <stdio.h>
struct sysinfo info;
int main(){
  int uptime,h,m,s;
  sysinfo(&info);
  uptime=info.uptime;
  h=uptime/3600;
  m=(uptime%3600)/60;
  s=(uptime%60)%60;
  printf("%02d:%02d:%02d", h,m,s);
  return 0;
}
