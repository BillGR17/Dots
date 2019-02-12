#include <stdio.h>
#include <sys/types.h>
#include <pwd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>
#include <sys/stat.h>
void deleteEnd (char* myStr){
  char *lastslash;
  if ((lastslash=strrchr(myStr, '/'))){
    *lastslash = '\0';
  }
  return;
}
void cp(char *u,char *r){
  FILE *uf,*rf;
  char buf[255];
  printf("%s -> %s\n",u,r);
  uf=fopen(u,"r");
  if(uf==NULL){
    perror("Couldn't read user file");
    exit(3);
  }
  int retry=0;
  while(retry<2){
    rf=fopen(r,"w+");
    if(errno==2){
      retry++;
      errno=0;
      char dir[500];
      sprintf(dir,"%s",r);
      deleteEnd(dir);
      mkdir(dir,700);
    }else if(rf==NULL){
      perror("Couldn't write root file");
      exit(4);
    }else{
      break;
    }
  }
  while(fgets (buf, 255, uf)!=NULL ) {
    fputs(buf,rf);
  }
  fclose(rf);
  fclose(uf);
}
int isFolder(const char *path) {
  struct stat buf;
  stat(path, &buf);
  return S_ISDIR(buf.st_mode);
}
void cp_dir(char *fu,char *fr){
  DIR *dir;
  struct dirent *ent;
  if((dir=opendir(fu)) != NULL){
    while((ent=readdir(dir))!= NULL){
      if(strcmp(ent->d_name,".")!=0&&strcmp(ent->d_name,"..")!=0&&strstr(ent->d_name,"~")==NULL){
        char c[500],r[500];
        sprintf(c,"%s/%s",fu,ent->d_name);
        sprintf(r,"%s/%s",fr,ent->d_name);
        if(isFolder(c)){
          mkdir(r,700);
          cp_dir(c,r);
        }else{
          cp(c,r);
        }
      }
    }
    closedir (dir);
  }else{
    perror("Couldn't readdir");
    exit(5);
  }
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
        char u[128],r[128];
        sprintf(u,"/home/%s/%s",argv[1],files[i]);
        sprintf(r,"/root/%s",files[i]);
        cp(u,r);
        sprintf(u,"/home/%s/.config/%s",argv[1],folders[i]);
        sprintf(r,"/root/.config/%s",folders[i]);
        cp_dir(u,r);
      }
    }
  }else{
    puts("Please execute with a user as argument");
    exit(1);
  }
  return 0;
}
