db2top -d live -f locks.$$ -C -m 2 -i 5
gzip lock.$$

