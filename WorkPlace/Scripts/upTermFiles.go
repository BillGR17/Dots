package main
import (
  "fmt"
  "io/ioutil"
  "net/http"
  "os/user"
)
//get raws from master
var url string = "https://raw.githubusercontent.com/BillGR17/Dots/master/"
//goGet grabs stuff from the internet
func goGet(path string) string {
  res, err := http.Get(url + path)
  onErr(err)
  defer res.Body.Close()
  pt, err := ioutil.ReadAll(res.Body)
  onErr(err)
  return string(pt)
}
//goRead grabs stuff from the local file
func goRead(path string) string {
  f, err := ioutil.ReadFile(path)
  // something is wrong if it doesnt exist in the first place so
  // its better to crash instead of creating the file...
  onErr(err)
  return string(f)
}
//onErr START PANICKING!!!
func onErr(e error) {
  if e != nil {
    panic(e)
  }
}
//Remember to only change the freaking confings from the terminal programs
//and never ever ever put tmux here! ssh requires special attention!
func main() {
  file := []string{
    ".config/nvim/init.vim",
    ".config/ranger/rc.conf",
    ".config/ranger/rifle.conf",
    ".config/ranger/scope.sh",
    ".zshrc",
  }
  //just to get the users homedir
  user, err := user.Current()
  onErr(err)
  for i := 0; i < len(file); i++ {
    fmt.Printf("[\033[1;36mChecking\033[0m]\033[0;36m%s\033[0m\n", file[i])
    res := goGet(file[i])
    f := goRead(user.HomeDir + "/" + file[i])
    if res != f {
      err := ioutil.WriteFile(user.HomeDir+"/"+file[i], []byte(res), 0644)
      onErr(err)
    }
  }
}
