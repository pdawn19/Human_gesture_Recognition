function [Fs, Fs_lab] = dep_user_data(MyoData, i, index)

    Fs=[];
    Fs_lab=[];
    num=1;
    L1=0;
    D=MyoData.spoon.EMG.Data{i};
    %     display(size(D));
    lab=MyoData.spoon.EMG.label{i};
    m=length(D);
    if(m<=0)
        return;
    end
    D = D(:, 2:9);
    [f,f_lab]=features(D,lab,index);
    nn=size(f,1);
    if(nn>0)
        for j=1:nn
            Fs(num,:)=f(j,:);
            Fs_lab(num)=f_lab(j);
            if(L1==0)
                L1=size(f,2);
            end
            num=num+1;
        end
    end

    num=1;
    L2=0;
    D=MyoData.spoon.IMU.Data{i};
    lab=MyoData.spoon.IMU.label{i};
    m=length(D);
    if(m<=0)
        %continue;
    end
    D = D(:, 2:11);
    [f,f_lab]=features(D,lab,index);
    nn=size(f,1);
    if(L2==0)
        L2=size(f,2);
    end
    if(nn>0)
        for j=1:nn
            Fs(num,L1+1:L1+L2)=f(j,:);
            num=num+1;
        end
    end

    num1=0;
    D=MyoData.fork.EMG.Data{i};
    lab=MyoData.fork.EMG.label{i};
    m=length(D);
    if(m<=0)
        %continue;
    end
    D = D(:, 2:9);
    [f,f_lab]=features(D,lab,index);
    nn=size(f,1);
    if(nn>0)
        for j=1:nn
            Fs(num+num1,1:L1)=f(j,:);
            Fs_lab(num+num1)=f_lab(j);
            num1=num1+1;
        end
    end

    num1=0;

    D=MyoData.fork.IMU.Data{i};
    lab=MyoData.fork.IMU.label{i};
    m=length(D);
    if(m<=0)
        %continue;
    end
    D = D(:, 2:11);
    [f,f_lab]=features(D,lab,index);
    nn=size(f,1);
    if(nn>0)
        for j=1:nn
            Fs(num+num1,L1+1:L1+L2)=f(j,:);
            num1=num1+1;
        end
    end
    Fs_lab = Fs_lab';
end
    