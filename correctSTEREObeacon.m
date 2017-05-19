clear all;clc

% which example.cdf -all;
% cdfinfo('example.cdf');
% data=cdfread('example.cdf')
%
[yyyy,mm,dd] = ymd(datetime('now','TimeZone','UTC'));
doy = day(datetime('now','TimeZone','UTC'),'dayofyear');
[h,m,s]=hms(datetime('now','TimeZone','UTC'));
utct = h + m/60;
jdnow = jd2000_new(yyyy,mm,dd,utct);
% NN = 2;
% jdthen = jdnow - NN/24;

d = 1;

impactfiles=dir([sprintf('./data/impact/*%s%02d%02d',num2str(yyyy),mm,dd-d) '*.cdf']);
plasticfiles=dir([sprintf('./data/plastic/*%s%02d%02d',num2str(yyyy),mm,dd-d) '*.cdf']);

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
[HEEQyear,HEEQdoy,HEEQsod,HEEQflag,HEEQxkm,HEEQykm,HEEQzkm] = textread('./pos/position_ahead_2017_HEEQ.txt');
[HEEyear,HEEdoy,HEEsod,HEEflag,HEExkm,HEEykm,HEEzkm] = textread('./pos/position_ahead_2017_HEE.txt');

HEEQindex = find(HEEQdoy == doy);HEEindex = find(HEEdoy == doy);

rm = sqrt((HEEQxkm(HEEQindex(1))*1000)^2 + (HEEQykm(HEEQindex(1))*1000)^2 + (HEEQzkm(HEEQindex(1))*1000)^2);

HEEQlatm = atan((HEEQzkm(HEEQindex(1))*1000)/(sqrt((HEEQxkm(HEEQindex(1))*1000)^2 + (HEEQykm(HEEQindex(1))*1000)^2)));
HEEQlonm = atan2((HEEQykm(HEEQindex(1))*1000),(HEEQxkm(HEEQindex(1))*1000));

HEElatm = atan((HEEzkm(HEEindex(1))*1000)/(sqrt((HEExkm(HEEindex(1))*1000)^2 + (HEEykm(HEEindex(1))*1000)^2)));
HEElonm = atan2((HEEykm(HEEindex(1))*1000),(HEExkm(HEEindex(1))*1000));

save(sprintf('./data/STEABeacon_%s%02d%02d.mat',num2str(yyyy),mm,dd-d),'jd2000','vm','Nm','Tm','Bxm','Bym','Bzm','rm','HEEQlonm','HEEQlatm','HEElonm','HEElatm');
% [jds,vm,Nm,Tm,Bxm,Bym,Bzm,rm,HEEQlonm,HEEQlatm,HEElonm,HEElatm] = getSTEREOlastN(jd0,NN,sat)

% epoch, Vm = plastic sqrt(Velocity_RTN^2), nm = plastic Density, Bxyz =
% impact

%Get the last NN hourls  of omni minute data
%   jds0 end time of requested Nhour interval
%   jds NN values of beginning of the last NN hours
