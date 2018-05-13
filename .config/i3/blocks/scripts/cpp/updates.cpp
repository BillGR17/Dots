#include <iostream>
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
  std::string c ="checkupdates|wc -l";
  int p = std::stoi(exec(c.c_str()));
  if(p>0){
    std::cout<<p;
  }
  return 0;
}

