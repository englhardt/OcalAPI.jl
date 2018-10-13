#!/bin/bash

curl -X POST -H "Content-Type:application/json" http://127.0.0.1:8081 -d @request.json --compressed --output response.json

