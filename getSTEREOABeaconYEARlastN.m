function [jds,vm,Nm,Tm,Bxm,Bym,Bzm,rm,HEEQlonm,HEEQlatm,HEElonm,HEElatm] = getSTEREOABeaconlastN(jd0,NN)
%
jds=NaN;vm=NaN;Nm=NaN;Tm=NaN;Bxm=NaN;Bym=NaN;Bzm=NaN;rm=NaN;
HEEQlonm=NaN;HEEQlatm=NaN;HEElonm=NaN;HEElatm=NaN;

% jd0 = 6.3472e+03;%jd2000(300);
% NN = 5;

if jd0 == 0
    [yyy,mm,dd] = ymd(datetime('now','TimeZone','UTC'));
    [h,m,s]=hms(datetime('now','TimeZone','UTC'));
    utct = h + m/60;
    jd0 = jd2000_new(yyy,mm,dd,utct);
    %     doy = day(datetime('now','TimeZone','UTC'),'dayofyear');
end

[startyear,startmonth,startday,starttime]=jd2date(jd0-NN/24);
[endyear,endmonth,endday,endtime]=jd2date(jd0);

totaldays = datenum(datetime([endyear,endmonth,endday]))-datenum(datetime([startyear,startmonth,startday]));

x=[];
for yyyy = startyear:endyear
    x = [x;load(sprintf('./data/StereoA%s.mat',num2str(yyyy)))];   % read/concatenate into x
end

fieldNames = fieldnames(x);
for pp = 1:length(fieldNames)
    combineddata.(fieldNames{pp}) = vertcat(x.(fieldNames{pp}));
end

ii = find(jds >= jd0-NN/24 & jds <= jd0);
jds = combineddata.jds(ii);
vm = combineddata.vm(ii);
Nm = combineddata.Nm(ii);
Tm = combineddata.Tm(ii);
Bxm = combineddata.Bxm(ii);
Bym = combineddata.Bym(ii);
Bzm = combineddata.Bzm(ii);
rm = combineddata.rm(ii);
HEEQlatm = combineddata.HEEQlatm(ii);
HEEQlonm = combineddata.HEEQlonm(ii);
HEElatm = combineddata.HEElatm(ii);
HEElonm = combineddata.HEElonm(ii);

end