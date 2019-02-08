#include <stdio.h>
#include <sys/types.h>
#include <pwd.h>
#include <stdlib.h>
#include <string.h>

void cp(char *user,char *file){
  FILE *uf,*rf;
  char buf[255];
  char f[50];
  sprintf(f,"/home/%s/%s",user,file);
  puts(f);
  uf=fopen(f,"r");
  if(uf==NULL){
    perror("Couldn't read user file");
    exit(3);
  }
  sprintf(f,"/root/%s",file);
  rf=fopen(f,"w+");
  if(rf==NULL){
    perror("Couldn't write root file");
    exit(3);
  }
  while(fgets (buf, 255, uf)!=NULL ) {
    fputs(buf,rf);
  }
  fclose(rf);
  fclose(uf);
}
int main(int argc, char *argv[]){
  if(argc==2){
    if(getpwnam(argv[1])==NULL||strcmp(argv[1],"root")==0){
      puts("Please check the User Name");
      exit(2);
    }else {
      char *files[4]={".zshrc",".tmux.conf",".Xresources",".xinitrc"};
      char *folders[4]={"i3","nvim","ranger","compton"};
      for(int i=0;i<4;i++){
        cp(argv[1],files[i]);
        char c[128];
        sprintf(c,"cp -TRv /home/%s/.config/%s /root/.config/%s",argv[1],folders[i],folders[i]);
        system(c);
      }
    }
  }else{
    puts("Please execute with a user as argument");
    exit(1);
  }
  return 0;
}
