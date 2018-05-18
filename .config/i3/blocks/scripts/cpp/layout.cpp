#include <iostream>
#include <algorithm>
#include <vector>
#include <sstream>

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
  std::string cmd = "xset -q|grep LED| awk '{ print $10 }'";
  int x = stoi(exec(cmd.c_str()));
  std::istringstream b(getenv("BLOCK_INSTANCE"));
  std::string token;
  std::vector<std::string> lang;
  while(std::getline(b,token,';')){
    lang.push_back(token);
  }
  for(std::string s : lang){
    std::string t=s.substr(0,s.find(','));
    int n = stoi(s.substr(s.find(',')+1,s.length()));
    if(n==x||( x>=n&&x<=(n+6) )){
    std::cout<< t;
    }
  }

}
