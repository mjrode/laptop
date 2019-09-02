#!/bin/sh

ssh -t preproduction.malauzai.com "sudo su - mastermonkey -c \"ls /home/mastermonkey/statement-fetching-service/statements/*service \""
ssh -t preproduction.malauzai.com "sudo su - mastermonkey -c \"rm -rf /home/mastermonkey/statement-fetching-service/statements/*service \""