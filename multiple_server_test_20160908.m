% multiple users in the same tcpip 
% 2 clients and 1 server 
% combined with Psychtoobox 
% and we can seperate the outputs from two client, respectively. CYC 20160908

fclose ('all');
clc 
clear all
% obj1 = tcpip('127.0.0.1', 2011,'NetworkRole', 'server');
  obj1 = tcpip('0.0.0.0',2049, 'NetworkRole', 'server');   % connect to client1 via this tcpip
 obj2 = tcpip('0.0.0.0',2050, 'NetworkRole', 'server');   % connect to client1 via this tcpip
disp(sprintf('Waiting for connection'))   

fopen(obj1);
fopen(obj2);
disp(sprintf('Give a kick'))  

 GetChar;
fwrite(obj1, 1,'double')
fwrite(obj2, 1,'double');

disp(sprintf('Try to connect with clients, wait to start'))  

 fclose ('all');