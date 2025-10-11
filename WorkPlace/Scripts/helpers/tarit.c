/*
 * Quick tar cvf as t.tar.gz on the current folder.
 * This is a robust and secure implementation using execvp instead of system().
 */
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <linux/limits.h>

#define ARCHIVE_NAME "t.tar.gz"

void print_command(char *const argv[]) {
  fprintf(stderr, "Executing command:\n");
  for (int i = 0; argv[i] != NULL; ++i) {
    fprintf(stderr, "%s ", argv[i]);
  }
  fprintf(stderr, "\n----------------------------------------\n");
}

int main(int argc, char *argv[]) {
  char pwd[PATH_MAX];
  if (getcwd(pwd, sizeof(pwd)) == NULL) {
    perror("getcwd() error");
    return EXIT_FAILURE;
  }

  // Use const for data that should not be modified.
  const char *const base_excludes[] = {"node_modules", ".git*",    "CHANGELOG", "changelog", "LICENCE", "licence", "README.md",
                                       "readme.md",    "*eslint*", "package-*", "yarn*",     "*~",      "~*",      ARCHIVE_NAME};
  int base_excludes_count = sizeof(base_excludes) / sizeof(char *);
  int custom_excludes_count = argc - 1;

  // Calculate the total number of arguments needed for the execvp call.
  // tar, -cvf, archive_path, -C, pwd, ., NULL_terminator
  int static_arg_count = 7;
  // Each exclude pattern needs two slots: "--exclude" and "pattern"
  int total_arg_count = static_arg_count + (2 * base_excludes_count) + (2 * custom_excludes_count);

  // Allocate memory for the argument vector.
  char **arg_vector = malloc(total_arg_count * sizeof(char *));
  if (arg_vector == NULL) {
    perror("malloc for argument vector failed");
    return EXIT_FAILURE;
  }

  // Buffer to hold the full path to the archive file.
  char archive_path[PATH_MAX];
  int written = snprintf(archive_path, sizeof(archive_path), "%s/%s", pwd, ARCHIVE_NAME);
  if (written >= sizeof(archive_path)) {
    fprintf(stderr, "Error: Archive path is too long.\n");
    free(arg_vector);
    return EXIT_FAILURE;
  }

  int i = 0;
  arg_vector[i++] = "tar";

  // Add base excludes. This is the robust way to exclude files.
  for (int j = 0; j < base_excludes_count; ++j) {
    arg_vector[i++] = "--exclude";
    arg_vector[i++] = (char *)base_excludes[j];
  }

  // Add custom excludes from command-line arguments.
  for (int j = 1; j < argc; ++j) {
    arg_vector[i++] = "--exclude";
    arg_vector[i++] = argv[j];
  }

  // Add the main tar arguments.
  arg_vector[i++] = "-cvf";
  arg_vector[i++] = archive_path;
  arg_vector[i++] = "-C";
  arg_vector[i++] = pwd;
  arg_vector[i++] = ".";
  arg_vector[i++] = NULL; // The argument list must be NULL-terminated.

  // Optional: Print the command that is about to be executed for debugging.
  print_command(arg_vector);

  // Execute the command directly, replacing the current process.
  // This is much safer than system() as it avoids the shell.
  execvp("tar", arg_vector);

  // execvp only returns if an error occurred.
  perror("execvp failed");
  free(arg_vector); // Free memory only on the error path.
  return EXIT_FAILURE;
}
