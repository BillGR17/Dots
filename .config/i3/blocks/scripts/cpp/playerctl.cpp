#include <iostream>
#include <vector>

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
  std::vector<std::string> s={"status","title","artist","album"};
  std::vector<std::string> r;
  for(int i=0; i<4; i++){
    std::string o="";
    if(i==0){
      o+="playerctl -p "+b+" "+s[i];
    }else{
      o+="playerctl -p "+b+" metadata "+s[i];
    }
    r.push_back(exec(o.c_str()));
  }
  std::string icon;
  if(r[0].find("Playing") != std::string::npos) {
    icon="";
  }
  else{
    icon="";
  }
  r.erase(r.begin());
  if (r[0].find("(null)") == std::string::npos){
    std::cout << icon << " ";
    for(std::string& x : r ){
      if(x.find("(null)") ==  std::string::npos){
        std::cout << x ;
        if(&x!=&r.back())
          std::cout<<" ~ ";
      }
    }
   }
  return 0;
}

