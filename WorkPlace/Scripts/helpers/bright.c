#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// card will set the current device
char card[128];
char dec = 0; // 0 for increase, 1 for decrease
int percentage = 1;

// Checks the card name for dangerous characters.
void sanitize_card(const char* input_card) {
  if (strchr(input_card, '/') != NULL || strchr(input_card, '.') != NULL) {
    fprintf(stderr, "Error: Invalid card name. The characters '/' and '.' are not allowed.\n");
    exit(10);
  }
}

int readFile(const char* e) {
  FILE* f = fopen(e, "r");
  char buf[128];
  int r = 0;
  if (f == NULL) {
    fprintf(stderr, "Could not open file %s\n", e);
    exit(2);
  }
  if (fgets(buf, sizeof(buf), f) != NULL) {
    r = atoi(buf);
  } else {
    fprintf(stderr, "Could not find data in file %s\n", e);
    exit(3);
  }
  fclose(f);
  return r;
}

void writeFile(const char* e, int x) {
  FILE* f = fopen(e, "w");
  if (f == NULL) {
    perror("Could not open file for writing");
    exit(2);
  }
  fprintf(f, "%d", x);
  fclose(f);
}

void args(int argc, char* argv[]) {
  int opt;
  while ((opt = getopt(argc, argv, "c:dv:")) != -1) {
    switch (opt) {
      case 'c':
        sanitize_card(optarg); // We sanitize the input
        strncpy(card, optarg, sizeof(card) - 1);
        card[sizeof(card) - 1] = '\0'; // Ensure null-termination
        break;
      case 'd': dec = 1; break;
      case 'v':
        percentage = atoi(optarg);
        if (percentage < 1) { percentage = 1; }
        break;
    }
  }
}

int main(int argc, char* argv[]) {
  args(argc, argv);

  if (strlen(card) == 0) {
    fprintf(stderr, "Usage: %s -c \"intel_backlight\" [-d] [-v 5]\n", argv[0]);
    exit(1);
  }

  char p_m[256];
  snprintf(p_m, sizeof(p_m), "/sys/class/backlight/%s/max_brightness", card);

  char p_c[256];
  snprintf(p_c, sizeof(p_c), "/sys/class/backlight/%s/brightness", card);

  double m_b = readFile(p_m);
  double c_b = readFile(p_c);

  double c_b_p_n = (percentage / 100.0) * m_b;

  if (!dec) {
    c_b += c_b_p_n;
    if (c_b > m_b) { c_b = m_b; }
  } else {
    c_b -= c_b_p_n;
    if (c_b <= 0) {
      c_b = 1; // Brightness should not be 0
    }
  }

  writeFile(p_c, (int)c_b);

  if (setuid(getuid()) != 0) { perror("Failed to drop privileges"); }

  return 0;
}
