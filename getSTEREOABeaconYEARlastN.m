function [jds,vm,Nm,Tm,Bxm,Bym,Bzm,rm,HEEQlonm,HEEQlatm,HEElonm,HEElatm] = getSTEREOABeaconlastN(jd0,NN)

jds=NaN;vm=NaN;Nm=NaN;Tm=NaN;Bxm=NaN;Bym=NaN;Bzm=NaN;rm=NaN;
HEEQlonm=NaN;HEEQlatm=NaN;HEElonm=NaN;HEElatm=NaN;

% jd0 = 0;
% NN = 24;

if jd0 == 0
    [yyy,mm,dd] = ymd(datetime('now','TimeZone','UTC'));
    [h,m,s]=hms(datetime('now','TimeZone','UTC'));
    utct = h + m/60;
    jd0 = jd2000_new(yyy,mm,dd,utct);
    %     doy = day(datetime('now','TimeZone','UTC'),'dayofyear');
end

[startyear,startmonth,startday,starttime] = jd2date(jd0-NN/24);
[endyear,endmonth,endday,endtime] = jd2date(jd0);

totaldays = datenum(datetime([endyear,endmonth,endday]))-datenum(datetime([startyear,startmonth,startday]));

x=[];
for yyyy = startyear:endyear
    x = [x;load(sprintf('./data/StereoA%s.mat',num2str(yyyy)))];
end

fieldNames = fieldnames(x);
for pp = 1:length(fieldNames)
    combineddata.(fieldNames{pp}) = vertcat(x.(fieldNames{pp}));
end

jds = combineddata.jds;
vm = combineddata.vm;
Nm = combineddata.Nm;
Tm = combineddata.Tm;
Bxm = combineddata.Bxm;
Bym = combineddata.Bym;
Bzm = combineddata.Bzm;
rm = combineddata.rm;
HEEQlatm = combineddata.HEEQlatm;
HEEQlonm = combineddata.HEEQlonm;
HEElatm = combineddata.HEElatm;
HEElonm = combineddata.HEElonm;

if totaldays < 365
    d1 = day(datetime([startyear startmonth startday]),'dayofyear');
    d2 = day(datetime([endyear endmonth endday]),'dayofyear');
    jj = d1:d2;
else
    d1 = day(datetime([startyear startmonth startday]),'dayofyear');
    for yyyy = startyear:endyear
        dayofyears = [yeardays(yyyy)];
    end
    d2 =  sum(dayofyears) + day(datetime([endyear endmonth endday]),'dayofyear');
    jj = d1:d2;
end

ii = find(jds >= jd0-NN/24 & jds <= jd0);
jds = combineddata.jds(ii);
vm = combineddata.vm(ii);
Nm = cell2mat(combineddata.Nm(ii));
Tm = cell2mat(combineddata.Tm(ii));
Bxm = double(combineddata.Bxm(ii));
Bym = double(combineddata.Bym(ii));
Bzm = double(combineddata.Bzm(ii));
rm = combineddata.rm(jj);
HEEQlatm = combineddata.HEEQlatm(jj);
HEEQlonm = combineddata.HEEQlonm(jj);
HEElatm = combineddata.HEElatm(jj);
HEElonm = combineddata.HEElonm(jj);

kk = find(vm > 10^10);vm(kk) = NaN;
kk = find(Nm < 10^-10);Nm(kk) = NaN;
kk = find(Tm < 10^-10);Tm(kk) = NaN;

end