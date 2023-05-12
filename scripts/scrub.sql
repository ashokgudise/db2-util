-- update address set firstname='firstname' where member_id in (select users_id from users where registertype ='G');
update address set firstname='firstname' where member_id in (select users_id from users where registertype ='R');

commit ;
 
-- update address set lastname='lastname' where member_id in (select users_id from users where registertype ='G');
update address set lastname='lastname' where member_id in (select users_id from users where registertype ='R');

commit ;
 
-- update address set email1='email1@email1.com' where member_id in (select users_id from users where registertype ='G');
update address set email1='email1@email1.com' where member_id in (select users_id from users where registertype ='R');
 commit ;
 
-- update address set phone1='888-888-8888' where member_id in (select users_id from users where registertype ='G');
update address set phone1='888-888-8888' where member_id in (select users_id from users where registertype ='R');
commit ;
 
-- update address set address1='address1' where member_id in (select users_id from users where registertype ='G');
update address set address1='address1' where member_id in (select users_id from users where registertype ='R');
commit ;  
-- update address set zipcode='88888' where member_id in (select users_id from users where registertype ='G');
update address set zipcode='88888' where member_id in (select users_id from users where registertype ='R');
commit ;

update address set nickname = 'nickname' where member_id in (select users_id from users where registertype ='G');
commit ; 
update address set nickname = 'nickname' where member_id in (select users_id from users where registertype ='R');
commit ;


update address set address2 = 'address'  where member_id in (select users_id from users where registertype ='G');
commit ;
update address set address2 = 'address'  where member_id in (select users_id from users where registertype ='R'); 
commit ;

update address set address3 = 'address'  where member_id in (select users_id from users where registertype ='G');
commit ;
update address set address3 = 'address'  where member_id in (select users_id from users where registertype ='R');
commit ;

update address set city = 'city'  where member_id in (select users_id from users where registertype ='G');
commit ;
update address set city = 'city'  where member_id in (select users_id from users where registertype ='R');
commit ;

--update userreg set logonid=users_id where users_id in (select users_id from users  where registertype='R');

