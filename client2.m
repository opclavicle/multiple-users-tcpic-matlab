% client2, this one should be your 3rd matlab windows
% run it and notice the ip and port ^^ CYC 20160908
obj2 = tcpip('192.168.0.3', 2050, 'NetworkRole', 'Client'); % 'localhost' for different instances of matlab


%528
% obj2 = tcpip('192.168.0.23', 5566, 'NetworkRole', 'client'); % 'localhost' for different instances of matlab
 fopen(obj2);
 go_time=GetSecs;
disp(sprintf('Try to connect with server, wait to start'))

while (GetSecs - go_time) <= 100
    while obj2.BytesAvailable == 0
    pause(1)
    end
    yoyo=fread(obj2, floor(obj2.BytesAvailable / 8), 'double')
    k=yoyo;
    if ( k == 1 )
        break;
    end
end

fclose('all')