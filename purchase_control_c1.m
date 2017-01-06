% server would control each trial (give the number each run)
% this is 1
clear all
clc;
Screen('Preference', 'SkipSyncTests', 1)
  %% You have to change by your self
couple=10; % fmri 
dummy=2; % 10 seconds
%%
surver_mode=1; %  530 is 1  ;b3 mode is 3
triggertype=0; % 0 is for client 1 setting 
run_duration= 320 ; % 320;
single_trial_duration=10; % setting by yourself
quit=0;
GetResponse=2;  % 0=false;    1=Luminar; 2=keyboard %56
halfp=200; % picture size
% cloeect data
c1_rank_resp=[];
c1_rank_rt=[];
c1_buy_resp=[];
c1_buy_rt=[];
event_record_other_rt_rank=[];
event_record_other_resp_rank=[];
time_fixation=[];
time_product=[];
time_present_rank=[];
time_purchase=[];
time_present_purchase=[];
% time zone
fix_time=1;
presented_time=6;
ranking_time=10;
show_time=1;

% Make sure keyboard mapping is the same on all supported operating systems
% Apple MacOS/X, MS-Windows and GNU/Linux:
KbName('UnifyKeyNames');
HideCursor;
switch surver_mode
    case {0}
    case {1} 
        % b530
   t1 = tcpip('192.168.0.120', 5565, 'NetworkRole', 'Client'); % 'localhost' for different instances of matlab
%528
% t1 = tcpip('192.168.0.23', 5566, 'NetworkRole', 'client'); % 'localhost' for different instances of matlab
%  %B3
%  t1 = tcpip('192.168.1.157', 5566, 'NetworkRole', 'client'); % 'localhost' for different instances of matlab
disp(sprintf('C1: Waiting for connection'))  
fopen(t1);
disp(sprintf('Connection with server is ok'))
    case {56} % B3
  t1 = tcpip('192.168.1.157', 5566, 'NetworkRole', 'client'); % 'localhost' for different instances of matlab
disp(sprintf('Waiting for connection'))  
  fopen(t1);
disp(sprintf('Try to connect with server, wait to start')) 
end
    % waiting dafault information from server
while t1.BytesAvailable == 0
    pause(1)
end
run=fread(t1, floor(t1.BytesAvailable / 8), 'double')
switch GetResponse
    case {2} % keyboard
one =   KbName('1!');
two =   KbName('2@'); % button 1..4
three = KbName('3#');
four =  KbName('4$'); 
% five =  KbName('5%');
% six =   KbName('6^');
end %switch
load('list_new_order.mat');
new_order=object_order';
% prepare
moneytxt= strcat('$');
% go_time=GetSecs;
ListenChar(2);
%initialize the random number generator to a new state
rand('state',sum(100*clock));
%Screen('Screens');
white = [255 255 255];
black = [0 0 0];
    screens=Screen('Screens');
    screenNumber=max(screens);
[params.w,params.rect] = Screen('OpenWindow',screenNumber,black);
[params.center(1), params.center(2)] = RectCenter(params.rect);
Screen('TextSize',params.w,32);
Screen(params.w,'DrawText','Waiting for signal from other computer',params.center(1),params.center(2),white);
Screen('Flip',params.w);
switch triggertype
    case{0}
GetChar;
fwrite(t1, 1,'double');       % transmiss data % cue server to start
    case{3}
GetChar;
fwrite(t1, 1,'double');       % transmiss data % cue server to start
end
WaitSecs(0.1);
Screen(params.w,'DrawText','Ready',params.center(1),params.center(2),white);
Screen('Flip',params.w);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Wait for first trigger  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    switch triggertype
        case {0}
              GetChar;
              % transmiss data % cue server to start
    fwrite(t1, 1,'double');       
        case {1,2}
            flag=getvalue(dio);while (getvalue(dio)==flag); end;
            t0=GetSecs;
        case {3}
    GetChar;
    % transmiss data % cue server to start
    fwrite(t1, 1,'double');
    end %switch
    prepare_time=dummy;
    prepare = [1:prepare_time];
for t = 1:prepare_time;
    start_Ta = GetSecs;
    Ta = (prepare_time + 1) - prepare (t);
    waittxt = strcat('Please wait');
    waittxts = strcat( num2str(Ta),' secs');
    Screen('FillRect', params.w, black);
    Screen('DrawText', params.w, waittxt, params.center(1)-50 , params.center(2)-80, white);
    Screen('DrawText', params.w, waittxts, params.center(1)-50, params.center(2)+20, white);
    Screen('Flip',params.w);
    while (GetSecs - start_Ta < 1)
        ;
    end
    Screen('FillRect', params.w,black, [params.center(1)-50, params.center(2)-100, params.center(1)+300, params.center(2)+100]);
    Screen('Flip', params.w);
end
Screen('FillRect', params.w,black);
Screen('Flip', params.w);
% prepare the picture
choice = imread('choice_new.png');
decision2_1 = imread('decision2_1.png');
decision2_3 = imread('decision2_3.png');
choice_texture = Screen('MakeTexture', params.w, choice);
decision2_1_texture = Screen('MakeTexture', params.w, decision2_1);
decision2_3_texture = Screen('MakeTexture', params.w, decision2_3);
theStart=GetSecs;   %record the start time of experiment
ranking_temp=0;
% main exp
%    for t = 1:run_duration

while ~quit || (GetSecs - theStart < run_duration-single_trial_duration)
while (t1.BytesAvailable == 0) 
    pause(1)
end
      
   gd=fread(t1, floor(t1.BytesAvailable / 8), 'double')
   if gd >1000
       quit=1;
   end
    trial_time_start=GetSecs;
    rank_way= rank_w(gd);
    now_order=new_order(gd);
    infor_isi=2+before_buy_isi(gd);
    KeyCode=0;
   % prepare the stimuli
    % money           
    number_temp=C{3}(now_order);
% product
f1 = imread(char(C{4}(now_order)));
f1t = Screen('MakeTexture', params.w, f1);
% MAIN EXP
% 1 s fixation block
fixation_start=GetSecs;
time_fixation=[time_fixation fixation_start-theStart];
if rank_way==1
DrawFormattedText(params.w,'> + <',params.center(1), params.center(2),white);
else
DrawFormattedText(params.w,'< + >',params.center(1), params.center(2),white);
end
Screen(params.w, 'Flip');
            while (GetSecs-fixation_start)< fix_time
            end         
% show "my rank"
 % money
label_presented=GetSecs; 
time_product=[time_product label_presented-theStart];
Screen('DrawText', params.w,moneytxt,params.center(1)-50,params.center(2)*1.2, white);               
Screen('DrawText', params.w,num2str(number_temp),params.center(1),params.center(2)*1.2, white);
% product          
Screen('DrawTexture', params.w, f1t,[],[params.center(1)-halfp,50,params.center(1)+halfp,50+halfp*2]); 
% my rank
Screen('DrawLine',params.w,white,params.center(1)*(3/20), params.center(2)*7/8,params.center(1)*(3/20), params.center(2),[2]);
Screen('DrawLine',params.w,white,params.center(1)*(5/20), params.center(2)*7/8,params.center(1)*(5/20), params.center(2),[2]);
Screen('DrawLine',params.w,white,params.center(1)*(7/20), params.center(2)*7/8,params.center(1)*(7/20), params.center(2),[2]);
Screen('DrawLine',params.w,white,params.center(1)*(1/20), params.center(2),    params.center(1)*(7/20), params.center(2),[2]);
Screen('DrawLine',params.w,white,params.center(1)*(1/20), params.center(2)*7/8,params.center(1)*(1/20), params.center(2),[2]);
Screen('DrawText', params.w,num2str(1), params.center(1)*(1/20), params.center(2), white);       
Screen('DrawText', params.w,num2str(2), params.center(1)*(3/20), params.center(2), white);           
Screen('DrawText', params.w,num2str(3), params.center(1)*(5/20), params.center(2), white);           
Screen('DrawText', params.w,num2str(4), params.center(1)*(7/20), params.center(2), white);           
Screen('Flip', params.w);
%%%%% ranking session%%%%%
        while GetSecs-label_presented< ranking_time  
                  if find(KeyCode)~=0
                  break;
                  end
                  [KeyIsDown, endrt, KeyCode]=KbCheck;
        end  
duration_temp=GetSecs;         
sss = round(1000*(GetSecs -label_presented));   
if     KeyCode(one)==1
               ranking_temp=1;
elseif KeyCode(two)==1
               ranking_temp=2;
elseif KeyCode(three)==1;
               ranking_temp=3;
elseif KeyCode(four)==1;
               ranking_temp=4;
end
 % money          
Screen('DrawText', params.w,moneytxt,params.center(1)-50,params.center(2)*1.2, white);               
Screen('DrawText', params.w,num2str(number_temp),params.center(1),params.center(2)*1.2, white);
% product          
Screen('DrawTexture', params.w, f1t,[],[params.center(1)-halfp,50,params.center(1)+halfp,50+halfp*2]);  
Screen('DrawLine', params.w,white, params.center(1)*(1/20), params.center(2),     params.center(1)*(7/20), params.center(2),[2]);
Screen('DrawLine', params.w,white, params.center(1)*(1/20), params.center(2)*7/8, params.center(1)*(1/20), params.center(2),[2]);
Screen('DrawLine', params.w,white, params.center(1)*(3/20), params.center(2)*7/8, params.center(1)*(3/20), params.center(2),[2]);
Screen('DrawLine', params.w,white, params.center(1)*(5/20), params.center(2)*7/8, params.center(1)*(5/20), params.center(2),[2]);
Screen('DrawLine', params.w,white, params.center(1)*(7/20), params.center(2)*7/8, params.center(1)*(7/20), params.center(2),[2]);
if     ranking_temp ==1 
Screen('DrawText', params.w,num2str(ranking_temp), params.center(1)*(1/20), params.center(2), white);           
elseif ranking_temp ==2
Screen('DrawText', params.w,num2str(ranking_temp), params.center(1)*(3/20), params.center(2), white);           
elseif ranking_temp ==3
Screen('DrawText', params.w,num2str(ranking_temp), params.center(1)*(5/20), params.center(2), white);   
elseif ranking_temp ==4
Screen('DrawText', params.w,num2str(ranking_temp), params.center(1)*(7/20), params.center(2), white);           
else
end
c1_rank_resp=[c1_rank_resp ranking_temp];
c1_rank_rt  =[c1_rank_rt sss];   
      Screen('Flip', params.w);         
% transmiss data to the client
fwrite(t1, ranking_temp,'double');
% waiting the data from the client
% Screen('Flip', params.w);
while t1.BytesAvailable == 0
    pause(1)
end
ranking_other=fread(t1, floor(t1.BytesAvailable / 8), 'double');
event_record_other_rt_rank  =[event_record_other_rt_rank      GetSecs-theStart];
event_record_other_resp_rank=[event_record_other_resp_rank    ranking_other];
% after received the information from server
% show the rank and information together %%
if rank_way==1
else
     % money          
Screen('DrawText', params.w,moneytxt,params.center(1)-50,params.center(2)*1.2, white);               
Screen('DrawText', params.w,num2str(number_temp),params.center(1),params.center(2)*1.2, white);
% product          
Screen('DrawTexture', params.w, f1t,[],[params.center(1)-halfp,50,params.center(1)+halfp,50+halfp*2]); 
% own-rank
Screen('DrawLine',params.w,white,params.center(1)*(1/20), params.center(2),         params.center(1)*(7/20),      params.center(2),[2]);
Screen('DrawLine',params.w,white,params.center(1)*(1/20), params.center(2)*7/8,     params.center(1)*(1/20),      params.center(2),[2]);
Screen('DrawLine',params.w,white,params.center(1)*(3/20), params.center(2)*7/8,     params.center(1)*(3/20), params.center(2),[2]);
Screen('DrawLine',params.w,white,params.center(1)*(5/20), params.center(2)*7/8,     params.center(1)*(5/20), params.center(2),[2]);
Screen('DrawLine',params.w,white,params.center(1)*(7/20), params.center(2)*7/8,     params.center(1)*(7/20), params.center(2),[2]);
% show the rank
if     ranking_temp ==1 
Screen('DrawText', params.w,num2str(ranking_temp), params.center(1)*(1/20), params.center(2), white);           
elseif ranking_temp ==2
Screen('DrawText', params.w,num2str(ranking_temp), params.center(1)*(3/20), params.center(2), white);           
elseif ranking_temp ==3
Screen('DrawText', params.w,num2str(ranking_temp), params.center(1)*(5/20), params.center(2), white);   
elseif ranking_temp ==4
Screen('DrawText', params.w,num2str(ranking_temp), params.center(1)*(7/20), params.center(2), white);           
else
end
Screen('DrawLine', params.w,white, params.center(1)*(33/20), params.center(2),     params.center(1)*(39/20), params.center(2),[2]);
Screen('DrawLine', params.w,white, params.center(1)*(33/20), params.center(2)*7/8, params.center(1)*(33/20), params.center(2),[2]);
Screen('DrawLine', params.w,white, params.center(1)*(35/20), params.center(2)*7/8, params.center(1)*(35/20), params.center(2),[2]);
Screen('DrawLine', params.w,white, params.center(1)*(37/20), params.center(2)*7/8, params.center(1)*(37/20), params.center(2),[2]);
Screen('DrawLine', params.w,white, params.center(1)*(39/20), params.center(2)*7/8, params.center(1)*(39/20), params.center(2),[2]);
if     ranking_other ==1 
Screen('DrawText', params.w,num2str(ranking_other), params.center(1)*(33/20), params.center(2), white);           
elseif ranking_other ==2
Screen('DrawText', params.w,num2str(ranking_other), params.center(1)*(35/20), params.center(2), white);           
elseif ranking_other ==3
Screen('DrawText', params.w,num2str(ranking_other), params.center(1)*(37/20), params.center(2), white);   
elseif ranking_other ==4
Screen('DrawText', params.w,num2str(ranking_other), params.center(1)*(39/20), params.center(2), white);           
else
end
Screen('Flip', params.w);
end
KeyCode =0;% for the next one
% show the rank and information together %%
if rank_way==1
else
Screen('DrawLine', params.w,white, params.center(1)*(33/20), params.center(2),     params.center(1)*(39/20), params.center(2),[2]);
Screen('DrawLine', params.w,white, params.center(1)*(33/20), params.center(2)*7/8, params.center(1)*(33/20), params.center(2),[2]);
Screen('DrawLine', params.w,white, params.center(1)*(35/20), params.center(2)*7/8, params.center(1)*(35/20), params.center(2),[2]);
Screen('DrawLine', params.w,white, params.center(1)*(37/20), params.center(2)*7/8, params.center(1)*(37/20), params.center(2),[2]);
Screen('DrawLine', params.w,white, params.center(1)*(39/20), params.center(2)*7/8, params.center(1)*(39/20), params.center(2),[2]);
if     ranking_other ==1 
Screen('DrawText', params.w,num2str(ranking_other), params.center(1)*(33/20), params.center(2), white);           
elseif ranking_other ==2
Screen('DrawText', params.w,num2str(ranking_other), params.center(1)*(35/20), params.center(2), white);           
elseif ranking_other ==3
Screen('DrawText', params.w,num2str(ranking_other), params.center(1)*(37/20), params.center(2), white);   
elseif ranking_other ==4
Screen('DrawText', params.w,num2str(ranking_other), params.center(1)*(39/20), params.center(2), white);           
else
end
end
% show rank
% money          
Screen('DrawText', params.w,moneytxt,params.center(1)-50,params.center(2)*1.2, white);               
Screen('DrawText', params.w,num2str(number_temp),params.center(1),params.center(2)*1.2, white);
% product          
Screen('DrawTexture', params.w, f1t,[],[params.center(1)-halfp,50,params.center(1)+halfp,50+halfp*2]); 
% own-rank
Screen('DrawLine',params.w,white,params.center(1)*(1/20), params.center(2),         params.center(1)*(7/20),      params.center(2),[2]);
Screen('DrawLine',params.w,white,params.center(1)*(1/20), params.center(2)*7/8,     params.center(1)*(1/20),      params.center(2),[2]);
Screen('DrawLine',params.w,white,params.center(1)*(3/20), params.center(2)*7/8,     params.center(1)*(3/20), params.center(2),[2]);
Screen('DrawLine',params.w,white,params.center(1)*(5/20), params.center(2)*7/8,     params.center(1)*(5/20), params.center(2),[2]);
Screen('DrawLine',params.w,white,params.center(1)*(7/20), params.center(2)*7/8,     params.center(1)*(7/20), params.center(2),[2]);
% show the rank
if     ranking_temp ==1 
Screen('DrawText', params.w,num2str(ranking_temp), params.center(1)*(1/20), params.center(2), white);           
elseif ranking_temp ==2
Screen('DrawText', params.w,num2str(ranking_temp), params.center(1)*(3/20), params.center(2), white);           
elseif ranking_temp ==3
Screen('DrawText', params.w,num2str(ranking_temp), params.center(1)*(5/20), params.center(2), white);   
elseif ranking_temp ==4
Screen('DrawText', params.w,num2str(ranking_temp), params.center(1)*(7/20), params.center(2), white);           
else
end
time_present_rank=[time_present_rank GetSecs-theStart];
WaitSecs(infor_isi);
% decision 1
decision_duration=GetSecs;
time_purchase=[time_purchase decision_duration-theStart];
Screen('DrawTexture', params.w, choice_texture,[],[(params.center(1)-size(choice,2)/4),params.rect(4)-size(choice,1)/2-100,params.center(1)+size(choice,2)/4,params.rect(4)-100]);
Screen('Flip', params.w);
        while GetSecs-decision_duration<presented_time
            % money    
                  if find(KeyCode)~=0
                  break;
                  end
                  [KeyIsDown, endrt, KeyCode]=KbCheck; 
        end

   record_decision_temp = round(1000*(GetSecs -decision_duration));  
if KeyCode(one)==1
    decision_temp=1;
elseif KeyCode(two)==1
    decision_temp=2;
else % if no response
    decision_temp=0; 
end
% transmiss data
fwrite(t1, decision_temp,'double');
c1_buy_rt  =[c1_buy_rt   record_decision_temp];
c1_buy_resp=[c1_buy_resp decision_temp];
% presented_time
time_present_purchase=[time_present_purchase  GetSecs-theStart ];
         if decision_temp==1
              Screen('DrawTexture', params.w,decision2_1_texture);
         else
              Screen('DrawTexture', params.w,decision2_3_texture);
         end
         Screen('Flip', params.w);
         WaitSecs(show_time);
         if (GetSecs - theStart > run_duration-single_trial_duration)
         break;
         end
end
% single_trial_duration=round(GetSecs-trial_time_start);
% end
    end_time_point=GetSecs;
  DrawFormattedText(params.w,'+',params.center(1), params.center(2),white);
  Screen('Flip', params.w);
  WaitSecs(run_duration-end_time_point-theStart);
  ShowCursor;
    Whole = GetSecs - theStart
    Screen('CloseAll');
    fclose('all');
    Priority(0);
    ListenChar(0);
   % str=['Purchase_c1_r',num2str(run),'_couple',num2str(couple),'_',date];  
     str=['Purchase_c1_couple',num2str(couple),'_r',num2str(run),'_',date];
   save (str);