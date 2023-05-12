
update address set address3 = 'address'  where member_id in (select users_id from users where registertype ='G');
commit ;
update address set address3 = 'address'  where member_id in (select users_id from users where registertype ='R');
commit ;

update address set city = 'city'  where member_id in (select users_id from users where registertype ='G');
commit ;
update address set city = 'city'  where member_id in (select users_id from users where registertype ='R');
commit ;

--update userreg set logonid=users_id where users_id in (select users_id from users  where registertype='R');

