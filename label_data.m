clc;
close all;
clear;
spoon_data=[];
fork_data=[];
num=0;
for i=9:41
    if(i==15 || i==20)
        continue
    end
    num=num+1;
    if(i<10)
        subfolder=['user',num2str(i)];
    else
        subfolder=['user',num2str(i)];
    end
    subf1=[subfolder,'/fork/'];
    subf2=[subfolder,'/spoon/'];
    dir1=['Myodata/',subf1];
    dir2=['Myodata/',subf2];
    dinfo = dir([dir1,'*.txt']);
    for K = 1 : length(dinfo)
      thisfilename = dinfo(K).name;
      if(isempty(strfind(thisfilename, 'EMG')))
          filepath=[dir1,thisfilename];
          data = load(filepath);
          MyoData.fork.IMU.Data{num}=data;
      else
          filepath=[dir1,thisfilename];
          data = load(filepath);
          MyoData.fork.EMG.Data{num}=data;
      end
      
    end
    dinfo = dir([dir2,'*.txt']);
    for K = 1 : length(dinfo)
      thisfilename = dinfo(K).name;
      if(isempty(strfind(thisfilename, 'EMG')))
          filepath=[dir2,thisfilename];
          data = load(filepath);
          MyoData.spoon.IMU.Data{num}=data;
      else
          filepath=[dir2,thisfilename];
          data = load(filepath);
          MyoData.spoon.EMG.Data{num}=data;
      end
      
    end
    dir1=['groundTruth/',subf1];
    dir2=['groundTruth/',subf2];
    dinfo = dir([dir1,'*.txt']);
    for K = 1 : length(dinfo)
      thisfilename = dinfo(K).name;
      filepath=[dir1,thisfilename];
      data = load(filepath);
      GData.fork.Data{num}=data;
      
    end
    dinfo = dir([dir2,'*.txt']);
    for K = 1 : length(dinfo)
      thisfilename = dinfo(K).name;
      filepath=[dir2,thisfilename];
      data = load(filepath);
      GData.spoon.Data{num}=data;
    end
end

%% get the label data
%spoon EMG data
n=length(MyoData.spoon.EMG.Data);
for i =1:n
    D=MyoData.spoon.EMG.Data{i};
    gdata=GData.spoon.Data{i};
    m=length(D);
    if(m<=0)
        continue;
    end
    endStamp=D(m,1);
    Y=[];
    for j =1:m
        Tstamp=D(j,1);
        lab=get_label(gdata,Tstamp,endStamp);
        Y(j)=lab;
    end
    MyoData.spoon.EMG.label{i}=Y;
end
%spoon IMU data
n=length(MyoData.spoon.IMU.Data);
for i =1:n
    D=MyoData.spoon.IMU.Data{i};
    gdata=GData.spoon.Data{i};
    m=length(D);
    if(m<=0)
        continue;
    end
    endStamp=D(m,1);
    Y=[];
    for j =1:m
        Tstamp=D(j,1);
        lab=get_label(gdata,Tstamp,endStamp);
        Y(j)=lab;
    end
    MyoData.spoon.IMU.label{i}=Y;
end
%fork EMG data
n=length(MyoData.fork.EMG.Data);
for i =1:n
    D=MyoData.fork.EMG.Data{i};
    gdata=GData.fork.Data{i};
    m=length(D);
    if(m<=0)
        continue;
    end
    endStamp=D(m,1);
    Y=[];
    for j =1:m
        Tstamp=D(j,1);
        lab=get_label(gdata,Tstamp,endStamp);
        Y(j)=lab;
    end
    MyoData.fork.EMG.label{i}=Y;
end
%fork IMU data
n=length(MyoData.fork.IMU.Data);
for i =1:n
    D=MyoData.fork.IMU.Data{i};
    gdata=GData.fork.Data{i};
    m=length(D);
    if(m<=0)
        continue;
    end
    endStamp=D(m,1);
    Y=[];
    
    for j =1:m
        Tstamp=D(j,1);
        lab=get_label(gdata,Tstamp,endStamp);
        Y(j)=lab;
    end
    MyoData.fork.IMU.label{i}=Y;
end
save ('labelled_data','MyoData','GData')
