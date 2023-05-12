db2pd -db live -locks -transactions -applications -dynamic > lockwait.out.$$

db2pd -wlocks -db live > lock_waits.out.$$

db2pd -apinfo AppHandl -db live > lock_owner.out.$$

db2pd -db live -locks > locks.out.$$

db2pd -db live -applications -dynamic > apps_report.out.$$

gzip *.out.$$
