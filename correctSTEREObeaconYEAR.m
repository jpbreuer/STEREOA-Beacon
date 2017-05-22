clear all;clc

[yyyy,mm,dd] = ymd(datetime('now','TimeZone','UTC'));
[h,m,s]=hms(datetime('now','TimeZone','UTC'));
utct = h + m/60;
jdnow = jd2000_new(yyyy,mm,dd,utct);
% NN = 2;
% jdthen = jdnow - NN/24;

d1 = datenum('2017-01-01','yyyy-mm-dd');
d2 = datenum(datetime('today','TimeZone','UTC'));
d = d1:d2;

for kk = 1:numel(d)
    date = datestr(d(kk),'yyyymmdd');
    yyyy = date(1:4);mm = date(5:6);dd = date(7:8);
    doy = day(datetime(datestr(d(kk)),'Format','D'),'dayofyear');
    
    impactfiles=dir([sprintf('./data/impact/*%s%s%s',yyyy,mm,dd) '*.cdf']);
    plasticfiles=dir([sprintf('./data/plastic/*%s%s%s',yyyy,mm,dd) '*.cdf']);
    
    impactinfo = cdfinfo(['./data/impact/' impactfiles(1).name]);
    impactdata = cdfread(['./data/impact/' impactfiles(1).name],'Variables',{'Epoch','MAGBField'},'ConvertEpochToDatenum', true);%,'Epoch_MAG'},'ConvertEpochToDatenum', true);
    plasticinfo = cdfinfo(['./data/plastic/' plasticfiles(1).name]);
    plasticdata = cdfread(['./data/plastic/' plasticfiles(1).name],'Variables',{'Epoch1','Velocity_RTN','Density','Temperature_Inst'},'ConvertEpochToDatenum', true);
    
    impacttime = cell2mat(impactdata(1:length(impactdata),1));
    % impacttime = impactdata(1:length(impactdata),1);
    impactindex = find(impacttime>1);
    impacttime = impacttime(impactindex);
    plastictime = cell2mat(plasticdata(1:length(plasticdata),1));
    plasticindex = find(plastictime>1);
    plastictime = plastictime(plasticindex);
    % plastictime = plasticdata(1:length(plasticdata),1);
    
    % if length(impacttime) > length(plastictime)
    %     temp = ones(size(impacttime));
    %     for jj = 1:length(plastictime)
    %         temp(jj) = plastictime(jj);
    %     end
    %     plastictime = temp;
    % else
    %     temp = ones(size(plastictime));
    %     for jj = 1:length(impacttime)
    %         temp(jj) = impacttime(jj);
    %     end
    %     impacttime = temp;
    % %     impacttime = temp.*impacttime;
    % end
    
    % ii = find(impacttime == plastictime);
    ii = find(intersect(impacttime,plastictime));
    
    jd2000 = jd2000_new(year(datestr(impacttime(ii))),month(datestr(impacttime(ii))),day(datestr(impacttime(ii))),hour(datestr(impacttime(ii))) + minute(datestr(impacttime(ii)))./60);
    
    V_all = plasticdata(ii,2);
    Vall = [V_all{:}]';
    vm = sqrt(Vall(:,1).^2 + Vall(:,2).^2 + Vall(:,3).^2);
    
    Nm = plasticdata(ii,3);
    Tm = plasticdata(ii,4);
    
    % B_all = impactdata(1:length(impactdata),2);
    B_all = impactdata(ii,2);
    Ball = [B_all{:}]';
    Bxm = Ball(:,1);
    Bym = Ball(:,2);
    Bzm = Ball(:,3);
    
    % imvar = impactinfo.Variables;plvar = plasticinfo.Variables;
    [HEEQyear,HEEQdoy,HEEQsod,HEEQflag,HEEQxkm,HEEQykm,HEEQzkm] = textread(sprintf('./pos/position_ahead_%s_HEEQ.txt',yyyy));
    [HEEyear,HEEdoy,HEEsod,HEEflag,HEExkm,HEEykm,HEEzkm] = textread(sprintf('./pos/position_ahead_%s_HEE.txt',yyyy));
    
    HEEQindex = find(HEEQdoy == doy);HEEindex = find(HEEdoy == doy);
    
    rm = sqrt((HEEQxkm(HEEQindex(1))*1000)^2 + (HEEQykm(HEEQindex(1))*1000)^2 + (HEEQzkm(HEEQindex(1))*1000)^2);
    
    HEEQlatm = rad2deg(atan((HEEQzkm(HEEQindex(1))*1000)/(sqrt((HEEQxkm(HEEQindex(1))*1000)^2 + (HEEQykm(HEEQindex(1))*1000)^2))));
    HEEQlonm = rad2deg(atan2((HEEQykm(HEEQindex(1))*1000),(HEEQxkm(HEEQindex(1))*1000)));
    
    HEElatm = rad2deg(atan((HEEzkm(HEEindex(1))*1000)/(sqrt((HEExkm(HEEindex(1))*1000)^2 + (HEEykm(HEEindex(1))*1000)^2))));
    HEElonm = rad2deg(atan2((HEEykm(HEEindex(1))*1000),(HEExkm(HEEindex(1))*1000)));
    
    save(sprintf('./data/daily-mat/STEABeacon_%s%s%s.mat',yyyy,mm,dd),'jd2000','vm','Nm','Tm','Bxm','Bym','Bzm','rm','HEEQlonm','HEEQlatm','HEElonm','HEElatm');
end

% Save all daily mat files into yearly file
dailymatfolder = dir('./data/daily-mat/*.mat');
x=[];
for jj = 1:length(dailymatfolder)
    x = [x;load(['./data/daily-mat/' dailymatfolder(jj).name])];   % read/concatenate into x
end
fieldNames = fieldnames(x);
for pp = 1:length(fieldNames)
    combineddata.(fieldNames{pp}) = vertcat(x.(fieldNames{pp}));
end
jds = combineddata.jd2000;
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

save(sprintf('./data/StereoA%s.mat',yyyy),'jds','vm','Nm','Tm','Bxm','Bym','Bzm','rm','HEEQlonm','HEEQlatm','HEElonm','HEElatm');