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
    std::cout<<std::setprecision(0) << bytes<<" b ";
  }else if(bytes < 1048576){
    std::cout<<std::setprecision(0) << (bytes / 1024)<<" kb ";
  }else if(bytes < 1073741824){
    std::cout<<std::setprecision(2) << (bytes / 1048576)<<" mb ";
  }else {
    std::cout<<std::setprecision(2) << (bytes / 1073741824)<<" gb ";
  }
}

int main(){
  system("ip route | awk '/^default/ { print $5 ; exit }'>/tmp/.net_con");
  std::string toExec="grep $(cat /tmp/.net_con)  /proc/net/dev | awk -F: '{print  $2}' | awk '{print $1\" \"$9}'";
  std::string bw=exec(toExec.c_str());
  std::string obw=exec("cat /tmp/.net_bw");
  system("grep $(cat /tmp/.net_con)  /proc/net/dev | awk -F: '{print  $2}' | awk '{print $1\" \"$9}'>/tmp/.net_bw&");
  int down = std::stoll(bw.substr(0,bw.find(" "))) - std::stoll(obw.substr(0,obw.find(" ")));
  int up = std::stoll(bw.substr(bw.find(" "),bw.length())) - std::stoll(obw.substr(obw.find(" "),obw.length()));
  format(down);
  std::cout<<"  ";
  format(up);
  return 0;
}
