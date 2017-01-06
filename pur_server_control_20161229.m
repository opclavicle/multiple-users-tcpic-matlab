% multiple users in the same tcpip 
% 2 clients and 1 server 
% server would control each trial (give the number each run)

fclose ('all');
clc 
clear all
%  setting by your hand, them send to anther one
run=10; % in two computer
i=215; % run 5 is 99; 125
run_duration=320;
dummy_duration=2;
max_single_trial=10;
obj1 = tcpip('0.0.0.0',5565, 'NetworkRole', 'server');   % connect to client1 via this tcpip
obj2 = tcpip('0.0.0.0',5564, 'NetworkRole', 'server');   % connect to client1 via this tcpip
disp(sprintf('server: Waiting for connection'))  
fopen(obj1);
fopen(obj2);
% data collection
clinet1_rank_resp=[];
clinet1_rank_rt=[];
clinet1_buy_resp=[];
clinet1_buy_rt=[];
clinet2_rank_resp=[];
clinet2_rank_rt=[];
clinet2_buy_resp=[];
clinet2_buy_rt=[];
%% default setting output
fwrite(obj1, run,'double'); % client 2 run  put where??
fwrite(obj2, run,'double'); % client 2 run  put where??
WaitSecs(1.1);
% just collect two kb from client, then wait 10s to skip dummy 
while obj1.BytesAvailable == 0
    pause(1)
end
cue =  fread(obj1, floor(obj1.BytesAvailable / 8), 'double');
fwrite(obj2, cue,'double'); % client 2 run 
while obj1.BytesAvailable == 0
    pause(1)
end
cue =  fread(obj1, floor(obj1.BytesAvailable / 8), 'double');
fwrite(obj2, cue,'double'); % client 2 run  put where??
% just collect two kb from client, then wait 10s to skip dummy 
WaitSecs(dummy_duration);
server_Start=GetSecs; % reference point 
% after two clients starts
while (GetSecs-server_Start< run_duration )||(i<1000) 
    %
   fwrite(obj1, i,'double'); % client 2 run  put where??
   fwrite(obj2, i,'double'); % client 2 run  put where?? 
    
% collect the data from client 1, then send to client 2 
while obj1.BytesAvailable == 0 ||  obj2.BytesAvailable == 0
    pause(1)
end
ranking_client1 =  fread(obj1, floor(obj1.BytesAvailable / 8), 'double');
clinet1_rank_rt =  [clinet1_rank_rt  round(1000*(GetSecs-server_Start))];
clinet1_rank_resp =[clinet1_rank_resp ranking_client1];
% transmiss data to the client 2
fwrite(obj2, ranking_client1,'double');
ranking_client2 =  fread(obj2, floor(obj2.BytesAvailable / 8), 'double');
clinet2_rank_rt =  [clinet2_rank_rt  round(1000*(GetSecs-server_Start))];
clinet2_rank_resp =[clinet2_rank_resp ranking_client2];
% transmiss data to the client 1
fwrite(obj1, ranking_client2,'double');
% purchase or not 
while obj1.BytesAvailable == 0
    pause(1)
end
clinet1_buy_resp_temp  =  fread(obj1, floor(obj1.BytesAvailable / 8), 'double');
clinet1_buy_rt_temp= round(1000*(GetSecs-server_Start));
clinet1_buy_rt =  [clinet1_buy_rt  clinet1_buy_rt_temp];
clinet1_buy_resp =[clinet1_buy_resp clinet1_buy_resp_temp];
% purchase or not 
while obj2.BytesAvailable == 0
    pause(1)
end
clinet2_buy_resp_temp  =  fread(obj2, floor(obj2.BytesAvailable / 8), 'double');
clinet2_buy_rt =  [clinet2_buy_rt  round(1000*(GetSecs-server_Start))];
clinet2_buy_resp =[clinet2_buy_resp clinet2_buy_resp_temp];
% 320s ¤º
if GetSecs-server_Start< run_duration- max_single_trial
i=i+1 

 str=['Purchase_server_r',num2str(run),'_',num2str(i),'_',date];  
else 
    i=5566
    break;
end
end
   save (str);
disp(sprintf('Hello World'))   
 fclose ('all');