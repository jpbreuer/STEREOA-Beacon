function [jds,vm,Nm,Tm,Bxm,Bym,Bzm,rm,HEEQlonm,HEEQlatm,HEElonm,HEElatm] = getSTEREOABeaconlastN(jd0,NN)
% % 
jds=NaN;vm=NaN;Nm=NaN;Tm=NaN;Bxm=NaN;Bym=NaN;Bzm=NaN;rm=NaN; 
HEEQlonm=NaN;HEEQlatm=NaN;HEElonm=NaN;HEElatm=NaN;

if jd0 == 0
    [yyyy,mm,dd] = ymd(datetime('now','TimeZone','UTC'));
    [h,m,s]=hms(datetime('now','TimeZone','UTC'));
    utct = h + m/60;
    jd0 = jd2000_new(yyyy,mm,dd,utct);
%     doy = day(datetime('now','TimeZone','UTC'),'dayofyear');
end
% jd0 = 6.3472e+03;%jd2000(300);
% NN = 5;

[startyear,startmonth,startday,starttime]=jd2date(jd0-NN/24);
[endyear,endmonth,endday,endtime]=jd2date(jd0);

totaldays = datenum(datetime([endyear,endmonth,endday]))-datenum(datetime([startyear,startmonth,startday]));

% [a,b,c,d]=jd2date((jd0-1)-NN/24);
FileList = dir('./data/*.mat');
Data = cell(1, totaldays);

if totaldays == 0
    filename = sprintf('./data/STEABeacon_%s%02d%02d.mat',num2str(startyear),startmonth,startday);
    Data{1} = load(filename);
else
    counter = 0;
    for days = 1:totaldays+1
        [yyyy,mm,dd,utc] = jd2date((jd0+counter)-NN/24);
        counter = counter+1;
        FileData = load(sprintf('./data/STEABeacon_%s%02d%02d.mat',num2str(yyyy),mm,dd));
        Data{counter} = FileData;
    end
    Data = cat(1, Data{:});
end

fieldNames = fieldnames(Data);
for ii = 1:length(fieldNames)
    combineddata.(fieldNames{ii}) = vertcat(Data.(fieldNames{ii}));
end

jd2000 = combineddata.jd2000;
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

ii = find(jd2000 >= jd0-NN/24 & jd2000 <= jd0);
jds = jd2000(ii);
vm = vm(ii);
Nm = Nm(ii);
Tm = Tm(ii);
Bxm = Bxm(ii);
Bym = Bym(ii);
Bzm = Bzm(ii);
rm = rm(1);
HEEQlonm = HEEQlonm(1);
HEEQlatm = HEEQlatm(1);
HEElonm = HEElonm(1);
HEElatm = HEElatm(1);