#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
long long int u = 0, d = 0, _d = 0, _u = 0;
long long int readf(const char* x) {
  long long int r = 0;
  FILE* fp = fopen(x, "r");
  if (fp == NULL) return 0;
  fscanf(fp, "%lld", &r);
  fclose(fp);
  return r;
}
void writef(const char* x, long long int y) {
  FILE* fp = fopen(x, "w");
  if (fp == NULL) return;
  fprintf(fp, "%lld", y);
  fclose(fp);
}
int main() {
  const char* e = getenv("BLOCK_INSTANCE");
  char tu[512];
  char td[512];
  sprintf(td, "/sys/class/net/%s/statistics/rx_bytes", e);
  sprintf(tu, "/sys/class/net/%s/statistics/tx_bytes", e);
  d = readf(td);
  u = readf(tu);
  _d = readf("/tmp/_d_rx_bytes");
  _u = readf("/tmp/_u_tx_bytes");
  fprintf(stdout, "D:%.2fmb U:%.2fmb\n", (float)(d - _d) / 1024 / 1024, (float)(u - _u) / 1024 / 1024);
  fflush(stdout);
  writef("/tmp/_d_rx_bytes", d);
  writef("/tmp/_u_tx_bytes", u);
  return 0;
}
