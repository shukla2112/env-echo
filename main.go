package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"strings"
)

func main(){
	mux := http.NewServeMux()
	mux.HandleFunc("/", getEnv)
	s := http.Server{Handler: mux, Addr: ":8080"}
	err := s.ListenAndServe()
	if err != nil{
		log.Fatalf("error running server. err: %v",err)
	}
}


func getEnv(rw http.ResponseWriter, req *http.Request){
	allEnvs:= os.Environ()

	allHasuraEnvMap := map[string]string{}

	for _, env := range allEnvs{
		envKeyVal := strings.SplitN(env, "=" ,2)
		if len(envKeyVal) != 2{
			continue
		}
        if strings.HasPrefix(envKeyVal[0], "HASURA_") {
            allHasuraEnvMap[envKeyVal[0]] = envKeyVal[1]
        }
	}

	 ba, _ := json.MarshalIndent(allHasuraEnvMap, "", "\t")

	rw.Write(ba)

}
