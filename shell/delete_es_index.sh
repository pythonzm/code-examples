#!/bin/bash
index_names=$(curl -s http://10.1.4.153:9200/_cat/indices|grep -Ev '(ui_template|sw_ui_template)'|awk '{print $3}'|sort|uniq)
log_reservered_day=$(date -d '5 days ago' +%Y%m%d)
log_reservered_day_convert=$(date -d "$log_reservered_day" +%s)

for index_name in $(echo "$index_names")
do
        index_day=$(echo  ${index_name}|awk -F '-' '{print $NF}'|sed 's/\./-/g')
        index_convert_day=$(date -d "$index_day" +%s )
        if [ ${index_convert_day} -lt ${log_reservered_day_convert} ];then
                curl -X DELETE 10.1.4.153:9200/${index_name}
        fi
done
