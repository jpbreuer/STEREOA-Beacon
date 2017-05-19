function [jds,vm,Nm,Tm,Bxm,Bym,Bzm,rm,HEEQlonm,HEEQlatm,HEElonm,HEElatm] = getSTEREOlastN(jd0,NN,sat)
%Get the last NN hourls  of omni minute data
%   jds0 end time of requested Nhour interval
%   jds NN values of beginning of the last NN hours

jds=NaN;vm=NaN;Nm=NaN;Tm=NaN;Bxm=NaN;Bym=NaN;Bzm=NaN;rm=NaN; HEEQlonm=NaN;
HEEQlatm=NaN;HEElonm=NaN;HEElatm=NaN;

[iys,ims,ids,uts]=jd2date(jd0-NN/24);
[iy0,im0,id0,ut0]=jd2date(jd0);
for iy=iys:iy0
    if sat=='a'
        sat1='A';
    elseif sat=='b'
        sat1='B';
    else
        sat1=sat;
    end
filnam=['Stereo' sat1  num2str(iy) '.mat'];
eval(['load ' filnam ';']);
ii=find(jd0-NN/24<jdIMF & jdIMF<=jd0);
if iy==iys;
    jds=jdIMF(ii)';
    vm=v(ii)';
    Nm=N(ii)';
    Tm=T(ii)';
    Bxm=Bx(ii)';
    Bym=By(ii)';
    Bzm=Bz(ii)';
    rm=r(ii)';
    HEEQlonm=HEEQlon(ii)';
    HEEQlatm=HEEQlat(ii)';
    HEElonm=HEElon(ii)';
    HEElatm=HEElat(ii)';
else
    jds=[jds jdIMF(ii)'];
    vm=[vm v(ii)'];
    Nm=[Nm N(ii)'];
    Tm=[Tm T(ii)'];
    Bxm=[Bxm Bx(ii)'];
    Bym=[Bym By(ii)'];
    Bzm=[Bzm Bz(ii)'];
    rm=[rm r(ii)'];
    HEEQlonm=[HEEQlonm HEEQlon(ii)'];
    HEEQlatm=[HEEQlatm HEEQlat(ii)'];
    HEElonm=[HEElonm HEElon(ii)'];
    HEElatm=[HEEQlonm HEElat(ii)'];
end
end  

% if max([abs(jd0-24-jd1(1)) abs(jd0-24-jd2(1))])>0.2/24
%     keyboard
%     return


return
