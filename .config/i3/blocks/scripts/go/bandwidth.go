package main

import (
  "os"
  "log"
  "bufio"
  "time"
  "strings"
  "strconv"
  "io/ioutil"
  "fmt"
)

type NetBytes struct{
  up,down float64
}
//get env or throw err
func info()(string){
  w:=os.Getenv("BLOCK_INSTANCE")
  if len(w)==0{
    log.Fatal("No Env Found")
  }
  return w
}
//reads proc/net/dev/ searches for line that contains env
//then returns the result
func netstats(w string) *NetBytes {
  n,e:=ioutil.ReadFile("/proc/net/dev")
  if e!=nil{
    log.Fatal(e)
  }
  net:=bufio.NewScanner(strings.NewReader(string(n)))
  r:=new(NetBytes)
  for net.Scan() {
    if strings.Contains(net.Text(),w){
      if strings.Contains(net.Text(),w){
        d,e:=strconv.ParseFloat(string(strings.Fields(net.Text())[1]),64)
        u,e:=strconv.ParseFloat(string(strings.Fields(net.Text())[9]),64)
        if e!=nil{
          log.Fatal(e)
        }
        r.down=d
        r.up=u
      }
    }
  }
  return r
}
//format byte to kb,mb,gb
func format(f float64) (string) {
  r:=""
  if f<1024 {
    r=strconv.FormatFloat(f,'f',0,64)+" b"
  }else if f<1048576 {
    r=strconv.FormatFloat(f/1024,'f',0,64)+" kb"
  }else if f<1073741824{
    r=strconv.FormatFloat(f/1048576,'f',2,64)+" mb"
  }else{
   r=strconv.FormatFloat(f/1073741824,'f',2,64)+" gb"
  }
  return r
}

func main(){
  w:=info()
  nn:=new(NetBytes)//new network bytes
  on:=new(NetBytes)//old network bytes
  d:=""; u:=""
  //throw a msg on start
  fmt.Printf("Initialize...")
  //repeat every sec
  for range time.Tick(time.Second * 1){
    nn=netstats(w)
    //if first run dont show nothing and save
    //as old value
    if on.down!=0 {
      //get new values and format
      //them then print them
      d=format(nn.down-on.down)
      u=format(nn.up-on.up)
      fmt.Printf(" %v  %v",d,u)
    }
    on=nn
  }
}
