#include <iostream>
#include <sstream>
#include <vector>
#include <iomanip>
std::string exec(const char* cmd) {
    char buffer[128];
    std::string result = "";
    FILE* pipe = popen(cmd, "r");
    if (!pipe) throw std::runtime_error("popen() failed!");
    try {
        while (!feof(pipe)) {
            if (fgets(buffer, 128, pipe) != NULL)
                result += buffer;
        }
    } catch (...) {
        pclose(pipe);
        throw;
    }
    pclose(pipe);
    return result;
}
int main(){
  std::string b = getenv("BLOCK_INSTANCE");
  std::string bt;
  std::string cmd="upower -e|grep "+b+" |head -1";
  bt=exec(cmd.c_str());
  bt=bt.substr(0, bt.size()-1);
  cmd="upower -i "+bt+"|grep time|awk '{print $4}'";
  double t = stof(exec(cmd.c_str()));
  std::stringstream time;
  std::string min;
  std::string secs;
  time<< std::fixed << std::setprecision(2) <<t;
  min=time.str().substr(0,time.str().find("."));
  secs=time.str().substr(time.str().find(".")+1,2);
  std::cout << min <<":" << secs;
  return 0;
}
