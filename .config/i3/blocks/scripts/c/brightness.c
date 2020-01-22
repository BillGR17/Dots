#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// could change char r to int or float since
// we only get int values from brightness
void readFile(char* e, char* r, int size) {
  FILE* f = fopen(e, "r");
  char buf[size];
  if (f == NULL) {
    fprintf(stderr, "Could not open file %s\n", e);
    exit(2);
  }
  if (fgets(buf, sizeof(buf), f) != NULL) {
    strncpy(r, buf, sizeof(buf));
  } else {
    puts("Could not find shit in file\n");
    exit(3);
  }
  fclose(f);
}
void writeFile(char* e, int x) {
  FILE* f = fopen(e, "w+");
  if (f == NULL) {
    fprintf(stderr, "Could not open file %s\n", e);
    exit(2);
  }
  fprintf(f, "%d", x);
  fclose(f);
}
int main(void) {
  char* e = getenv("BLOCK_INSTANCE");
  if (e == NULL) {
    fprintf(stderr, "All you had to do was to provide a BLOCK_INSTANCE!\n");
    exit(1);
  }
  // get max brightness path
  char p_m[256];
  sprintf(p_m, "/sys/class/backlight/%s/max_brightness", e);
  // get current brightness path
  char p_c[256];
  sprintf(p_c, "/sys/class/backlight/%s/brightness", e);
  // get max brightness
  char m_b[128];
  readFile(p_m, m_b, sizeof(m_b));
  // get current brightness
  char c_b[128];
  readFile(p_c, c_b, sizeof(c_b));
  // get&store current percentage of brightness
  int c_b_p = atof(c_b) / atof(m_b) * 100;
  // calculate the 5 percentage of brightness
  int c_b_p_5 = ((double)5 / (double)100) * atof(m_b);
  // now read button events and increase or decrease the brightness by 5%
  char* e_b = getenv("BLOCK_BUTTON");
  // store
  int x = atoi(c_b);
  if (e_b != NULL) {
    int m = atoi(e_b);
    switch (m) {
      case 4:
        x += c_b_p_5;
        if (x > atoi(m_b)) { x = atoi(m_b); }
        writeFile(p_c, x);
        break;
      case 5:
        x -= c_b_p_5;
        if (x <= 0) { x = 1; }
        writeFile(p_c, x);
        break;
    }
  }
  c_b_p = x / atof(m_b) * 100;
  printf("%d%%\n", c_b_p);
  return 0;
}
