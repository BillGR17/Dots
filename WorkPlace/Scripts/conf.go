package main

import(
  "fmt"
  "os"
  "os/exec"
  "os/user"
)
func err(e error){
  if e!=nil{panic(e)}
}

func Exec(l string,s string,){
  c := exec.Command("/bin/sh","-c",s+" nvim "+l)
  c.Stdin = os.Stdin
  c.Stdout = os.Stdout
  e:= c.Run()
  err(e)
}

func list(s string){
  user, e:= user.Current()
  err(e)
  switch s {
    case "i3":
      Exec(user.HomeDir+"/.config/i3/config","")
    case "vi":
      Exec(user.HomeDir+"/.config/nvim/init.vim","")
    case "ng":
      Exec("/etc/nginx/nginx.conf","sudo")
    case "ap":
      Exec("/etc/httpd/conf/httpd.conf","sudo")
    case "tm":
      Exec(user.HomeDir+"/.tmux.conf","")
    case "zh":
      Exec(user.HomeDir+"/.zshrc","")
    case "xr":
      Exec(user.HomeDir+"/.Xresources&&xrdb -merge ~/.Xresources","")
    default:
      help()
  }
}

func help(){
  fmt.Print("Specify What you need to confing\n[ng=nginx]\n[ap=apache]\n[i3=i3wm]\n[vi=nvim]\n[ra=ranger]\n[tm=tmux]\n[zh=zsh]\n[xr=xterm]\n")
}

func main(){
  if len(os.Args)>1{
    list(os.Args[1])
  }else{
    help()
  }
}
