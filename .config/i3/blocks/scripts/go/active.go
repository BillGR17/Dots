package main
import (
  "go.i3wm.org/i3"
  "fmt"
)
func main(){
  oc:= i3.Subscribe(i3.WindowEventType)
  for oc.Next() {
    ev := oc.Event().(*i3.WindowEvent)
    fmt.Printf("%s\n",ev.Container.Name)
  }
  oc.Close()
}
