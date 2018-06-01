#include <iostream>
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
void format(float bytes){
  std::cout<<std::fixed;
  if(bytes < 1024){
    std::cout<<std::setprecision(0) << bytes<<"kb ";
  }else if(bytes < 1048576){
    std::cout<<std::setprecision(0) << (bytes / 1024)<<"mb ";
  }else if(bytes < 1073741824){
    std::cout<<std::setprecision(2) << (bytes / 1048576)<<"gb ";
  }else {
    std::cout<<std::setprecision(2) << (bytes / 1073741824)<<"tb ";
  }
}
int main(){
  long long int active = stoll(exec("free -k|grep Mem|awk '{print $3}'"));
  long long int total = stoll(exec("free -k|grep Mem|awk '{print $2}'"));
  format(active);
  std::cout<<"/";
  format(total);
  return 0;
}
