#!/bin/bash

mv accounts_new.csv accounts_new_reserve.csv

touch accounts_new.csv
chmod +x accounts_new.csv

while read linetitle;
do

####columns
id=$(echo $linetitle | cut -d',' -f1);
location=$(echo $linetitle | cut -d',' -f2);
organization=$(echo $linetitle | cut -d',' -f3);
service=$(echo $linetitle | cut -d',' -f4);
name=$(echo $linetitle | cut -d',' -f5);
title=$(echo $linetitle | cut -d',' -f6);
titlequotes=$(echo $linetitle | cut -d'"' -f2);
email=$(echo $linetitle | cut -d',' -f7);
department=$(echo $linetitle | cut -d',' -f8);

letter1=`echo $name | awk -F' ' '{print $1}' | echo ${name:0:1}`
letter2=`echo $name | awk -F' ' '{print $2}'`
fullemail=`echo $letter1$letter2 | awk '{print tolower($0)}'`
titleq=$(echo '"'$title'"')
nameh=$(echo $linetitle | cut -d',' -f5 | sed "s/\b\(.\)/\u\1/g")
samemail=`cat accounts_new.csv | grep $fullemail | wc -l`

if [[ ${title:0:1} = '"' ]];
then
        nameup=$(echo $linetitle | awk -F'"' '{print $1}' |  awk -F',' '{print $5}' | sed "s/\b\(.\)/\u\1/g" )
        echo $id,$location,$organization,$service,$nameh,'"'$titlequotes'"',$fullemail'@abc.com',$department  >> accounts_new.csv;

elif [[ $samemail > 0 ]];
then
        echo $id,$location,$organization,$service,$nameh,$titleq,$fullemail$samemail'@abc.com',$department  >> accounts_new.csv;
else
        echo $id,$location,$organization,$service,$nameh,$titleq,$fullemail'@abc.com',$department  >> accounts_new.csv;
fi
done < accounts.csv

#### Correct main columns
`sed -i 's/id,location_id,organization_id,service_id,Name,"title",n@abc.com,department/id,location_id,organization_id,service_id,name,title,email,department/g' accounts_new.csv`


