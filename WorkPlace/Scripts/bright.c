#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
// card will set the
// current device/direction to
// get/set the brightness
char card[128];
// so basically this is the
// dec 0 means false
// there is no need for
// another variables to
// increase
char dec = 0;
// how much percentage
// to change
// the brightness
int percentage = 1;
void readFile(char* e, double r) {
  FILE* f = fopen(e, "r");
  char buf[128];
  if (f == NULL) {
    fprintf(stderr, "Could not open file %s\n", e);
    exit(2);
  }
  if (fgets(buf, sizeof(buf), f) != NULL) {
    r = atof(buf);
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
/*
 * Checks the arguments then it will change the files
 */
void args(int argc, char* argv[]) {
  int opt;
  while ((opt = getopt(argc, argv, "c:dv:")) != -1) {
    switch (opt) {
      case 'c': strncpy(card, optarg, sizeof(card)); break;
      case 'd': dec = 1; break;
      case 'v':
        percentage = atoi(optarg);
        // atoi returns 0 instead of error so i think
        // we are cool using it
        if (percentage < 1) { percentage = 1; }
        break;
    }
  }
}
int main(int argc, char* argv[]) {
  args(argc, argv);
  if (strlen(card) == 0) {
    fprintf(
      stderr,
      "Usage: bright -c \"intel_backlight\" -d -v 5\nIf you want to increase you only need to type the card name\n"
      "\nAll you had to do was to provide the god damn card!\n");
    exit(1);
  }
  // get max brightness path
  char p_m[128];
  sprintf(p_m, "/sys/class/backlight/%s/max_brightness", card);
  // get current brightness path
  char p_c[128];
  sprintf(p_c, "/sys/class/backlight/%s/brightness", card);
  // get max brightness
  double m_b = 0;
  readFile(p_m, m_b);
  // get current brightness
  double c_b = 0;
  readFile(p_c, c_b);
  // calculate the percentage of brightness
  int c_b_p_n = ((double)percentage / (double)100) * m_b;
  // now read button events and increase or decrease the brightness
  if (!dec) {
    c_b += c_b_p_n;
    if (c_b > m_b) { c_b = m_b; }
    writeFile(p_c, (int)c_b);
  } else {
    c_b -= c_b_p_n;
    if (c_b <= 0) { c_b = 1; }
    writeFile(p_c, (int)c_b);
  }
  return 0;
}
