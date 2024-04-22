awk -F ', ' '{printf "update table1 SET ip = \x27%s\x27 where domain like \x27%s\x27;\n", $2, $1}' input.txt
