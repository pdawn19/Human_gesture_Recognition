function y=get_label(gdata,Tstamp,endStamp)
dt=(endStamp-Tstamp)/1000.0*30;
L=length(gdata);
End_frame=gdata(L,2);
current_frame=End_frame-dt;
if(current_frame<=0)
    y=-1;
else
    y=0;
    for i=L:-1:1
        f1=gdata(i,1);
        f2=gdata(i,2);
        if(current_frame>=f1 && current_frame<=f2)
            y=1;
            break;
        end
    end
end

end