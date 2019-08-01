#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <curl/curl.h>

//hide all response text
size_t write_data(void *buffer, size_t size, size_t nmemb, void *userp){
  return size * nmemb;
}

//Put all the info here
#define WEBSITE "example.com" //the protocol is used on F_WEBSITE
#define F_WEBSITE "https://" WEBSITE //Protocol Only!
#define N_FROM_ADDR "no-reply@emai.com"//enter the senders email
#define FROM_ADDR "<"N_FROM_ADDR ">"//ignore this
#define ADDR_PASS "pass"//The senders Password
#define TO_ADDR "<receiver@email.com>"//Enter the Receiver email with < >
#define SMTP_SERVER "smtp://mail.examplesmtp.com:587"

char *payload_text[768];

struct upload_status {
  int lines_read;
};

static size_t payload_source(void *ptr, size_t size, size_t nmemb, void *userp){
  struct upload_status *upload_ctx = (struct upload_status *)userp;
  const char *data;
  if((size == 0) || (nmemb == 0) || ((size*nmemb) < 1)) {
    return 0;
  }
  data = payload_text[upload_ctx->lines_read];
  if(data) {
    size_t len = strlen(data);
    memcpy(ptr, data, len);
    upload_ctx->lines_read++;
    return len;
  }
  return 0;
}

void GetDate(char *Date,int size){
  time_t rawtime;
  struct tm * timeinfo;
  time ( &rawtime );
  timeinfo = localtime (&rawtime);
  strftime(Date,size, "DATE: %a, %d %b %Y %H:%M:%S %z", timeinfo);
}

void sendMail(char *alert,long int status,double t){
  CURL *curl = curl_easy_init();
  if(curl) {
    struct upload_status upload_ctx;
    upload_ctx.lines_read = 0;
    char buffer[100];
    GetDate(buffer,sizeof(buffer));
    payload_text[0]=malloc(sizeof(buffer)*sizeof(char));
    strncpy(payload_text[0],buffer,100);
    payload_text[1]="To: " TO_ADDR "\r\n";
    payload_text[2]="From: " FROM_ADDR "\r\n";
    sprintf(buffer,"Subject: %s %s\r\n",alert,WEBSITE);
    payload_text[3]=malloc(sizeof(buffer)*sizeof(char));
    strncpy(payload_text[3],buffer,100);
    payload_text[4]="\r\n";
    payload_text[5]=malloc(sizeof(buffer)*sizeof(char));
    if(t!=0){
      int h = ((double)t / 3600);
      int m = ((double)t -(3600*h))/60;
      int s = ((double)t -(3600*h)-(m*60));
      sprintf(buffer,"The Site is back online after: %.2d:%.2d:%.2d\r\n",h,m,s);
    }else{
      sprintf(buffer,"The Site returns code status : %li\r\n",status);
    }
    strncpy(payload_text[5],buffer,100);
    payload_text[6]="\r\n";
    struct curl_slist *recipients = NULL;
    curl_easy_setopt(curl, CURLOPT_USERNAME, N_FROM_ADDR);
    curl_easy_setopt(curl, CURLOPT_PASSWORD, ADDR_PASS);
    curl_easy_setopt(curl, CURLOPT_URL, SMTP_SERVER);
    curl_easy_setopt(curl, CURLOPT_MAIL_FROM, FROM_ADDR);
    recipients = curl_slist_append(recipients, TO_ADDR);
    curl_easy_setopt(curl, CURLOPT_MAIL_RCPT, recipients);
    curl_easy_setopt(curl, CURLOPT_READFUNCTION, payload_source);
    curl_easy_setopt(curl, CURLOPT_READDATA, &upload_ctx);
    curl_easy_setopt(curl, CURLOPT_UPLOAD, 1L);
    CURLcode res = CURLE_OK;
    res = curl_easy_perform(curl);
    if(res != CURLE_OK)
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    curl_slist_free_all(recipients);
    curl_easy_cleanup(curl);
    free(payload_text[3]);
    free(payload_text[5]);
  }
}
int err;
time_t s_t, e_t;

void setErr(int val){
  err=val;
}

void checkPage(int err){
  CURL *curl = curl_easy_init();
  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL,F_WEBSITE);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);
    if(curl_easy_perform(curl) == CURLE_OK){
      long http_code=0;
      curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &http_code);
      if(http_code>399&&err==0) {
        setErr(1);
        time(&s_t);
        sendMail("Website is Down",http_code,0);
      }
      if(http_code<400&&err==1){
        setErr(0);
        time(&e_t);
        sendMail("Website is Up",http_code,(double)difftime(e_t, s_t));
      }
    }
    curl_easy_cleanup(curl);
  }
}

int main(void){
  while(1){
    checkPage(err);
    sleep(1);
  }
  return 0;
}
