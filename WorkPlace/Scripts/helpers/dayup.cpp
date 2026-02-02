#include <iostream>
#include <iomanip>
#include <utmpx.h>
#include <ctime>
#include <cstring>
#include <algorithm>

int main() {
  // Get current time to establish the "now" and "midnight" reference points
  std::time_t now = std::time(nullptr);
  struct std::tm *tm_info = std::localtime(&now);

  // Reset hours, minutes, and seconds to get the timestamp for 00:00:00 today
  tm_info->tm_hour = 0;
  tm_info->tm_min = 0;
  tm_info->tm_sec = 0;
  std::time_t midnight = std::mktime(tm_info);

  // Open the wtmp file which contains historical boot/shutdown records
  utmpxname("/var/log/wtmp");
  setutxent(); // Rewind to start of file

  struct utmpx *ent;
  long total_uptime_seconds = 0;
  long current_boot_timestamp = 0;

  // Iterate through all entries in wtmp
  while ((ent = getutxent()) != nullptr) {

    // Detect a system boot entry
    if (ent->ut_type == BOOT_TIME) {
      current_boot_timestamp = ent->ut_tv.tv_sec;
    }
    // Detect a system shutdown entry to close the session
    else if (ent->ut_type == RUN_LVL && std::strcmp(ent->ut_user, "shutdown") == 0) {
      if (current_boot_timestamp != 0) {
        long session_start = current_boot_timestamp;
        long session_end = ent->ut_tv.tv_sec;

        // Check if the session ended after midnight (belongs to today)
        if (session_end > midnight) {
          // If the boot started before midnight, clamp the start time to midnight.
          // This ensures we only count seconds that elapsed *today*.
          long effective_start = std::max((long)midnight, session_start);
          total_uptime_seconds += (session_end - effective_start);
        }

        // Reset boot timestamp as the session is closed
        current_boot_timestamp = 0;
      }
    }
  }
  endutxent(); // Close the wtmp file

  // Handle the current active session (from last boot until now)
  // This is necessary because the current session has no "shutdown" entry yet.
  if (current_boot_timestamp != 0) {
    long session_start = current_boot_timestamp;
    long session_end = now; // The session is still running, so end is "now"

    if (session_end > midnight) {
      long effective_start = std::max((long)midnight, session_start);
      total_uptime_seconds += (session_end - effective_start);
    }
  }

  // Calculate hours, minutes, and seconds from total seconds
  int h = total_uptime_seconds / 3600;
  int m = (total_uptime_seconds % 3600) / 60;
  int s = total_uptime_seconds % 60;

  // Output formatted as HH:MM:SS
  std::cout << std::setfill('0') << std::setw(2) << h << ":" << std::setfill('0') << std::setw(2) << m << ":" << std::setfill('0') << std::setw(2)
            << s << std::endl;

  return 0;
}
