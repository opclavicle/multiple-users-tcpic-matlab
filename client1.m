% client 1 C
% change the ip ('192.168.0.3') by your own; change your port number same
% as the server number. by CYC

obj1 = tcpip('192.168.0.3', 2049, 'NetworkRole', 'Client'); 

disp(sprintf('Waiting for connection'))
fopen(obj1);
 go_time=GetSecs;
disp(sprintf('Connection ok'))

while (GetSecs - go_time) <= 100
    while obj1.BytesAvailable == 0
    pause(1)
    end
    yoyo=fread(obj1, floor(obj1.BytesAvailable / 8), 'double')
    k=yoyo;
    if ( k == 1 )
        break;
    end
end
 fclose('all')
