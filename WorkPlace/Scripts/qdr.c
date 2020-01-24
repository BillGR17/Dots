/*
 * Quick Digit Rename
 */
#include <assert.h>
#include <ctype.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
/*
 * number is used on renaming
 * digit is used at renaming numbering
 */
int number = 0, digit = 1;
/*
 * Returns a pointer to the extension of 'string'.
 * If no extension is found, returns a pointer to the end of 'string'.
 */
char* file_ext(const char* string) {
  assert(string != NULL);
  char* ext = strrchr(string, '.');
  if (ext == NULL) return (char*)string + strlen(string);
  for (char* iter = ext + 1; *iter != '\0'; iter++) {
    if (!isalnum((unsigned char)*iter)) return (char*)string + strlen(string);
  }
  return ext;
}
/*
 * This function calls the actual rename method
 * Plus Prints all the info
 */
void rn(char* oldname) {
  char n[500];
  snprintf(n, sizeof(n), "%.*d%s", digit, number, file_ext(oldname));
  if (access(n, F_OK) != -1) {
    fprintf(stderr, "Cant rename %s to %s file with same name exist\n", oldname, n);
  } else {
    printf("%s", oldname);
    rename(oldname, n);
    printf(" -> %.*d%s\n", digit, number, file_ext(oldname));
  }
  number++;
}
/*
 * Checks the arguments then it will change the files
 */
void args(int argc, char* argv[]) {
  int opt;
  while ((opt = getopt(argc, argv, "d:f:h")) != -1) {
    switch (opt) {
      case 'd': digit = atoi(optarg); break;
      case 'f':;
        optind--;
        for (; optind < argc && *argv[optind] != '-'; optind++) { rn(argv[optind]); }
        break;
      default: puts("Usage: qdr -d 2 -f *.jpg");
    }
  }
}
int main(int argc, char* argv[]) {
  args(argc, argv);
  return 0;
}
