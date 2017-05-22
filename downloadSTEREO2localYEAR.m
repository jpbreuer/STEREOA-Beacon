clear all;clc

% [yyyy,mm,dd] = ymd(datetime('now','TimeZone','UTC'));%add UT+0
% [h,m,s] = hms(datetime('now'));

d1 = datenum('2017-01-01','yyyy-mm-dd');
d2 = datenum(datetime('today','TimeZone','UTC'));
d = d1:d2;

nasaserv = ftp('stereoftp.nascom.nasa.gov:21');
for kk = 1:numel(d)
    
    date = datestr(d(kk),'yyyymmdd');
    yyyy = date(1:4);mm = date(5:6);dd = date(7:8);

    impactpath = sprintf('/pub/beacon/ahead/impact/%s/%s/',yyyy,mm);     % impactpath = sprintf('https://stereo-ssc.nascom.nasa.gov/data/beacon/ahead/impact/%s/%02d/',num2str(yyyy),mm);
    impactfile = sprintf('STA_LB_IMPACT_%s%s%s_V02.cdf',yyyy,mm,dd);   % impactfile = sprintf('STA_LB_IMPACT_%s%02d%02d_V02.cdf',num2str(yyyy),mm,dd);
    plasticpath = sprintf('/pub/beacon/ahead/plastic/%s/%s/',yyyy,mm);   % plasticpath = sprintf('https://stereo-ssc.nascom.nasa.gov/data/beacon/ahead/plastic/%s/%02d/',num2str(yyyy),mm);
    plasticfile = sprintf('STA_LB_PLASTIC_%s%s%s_V11.cdf',yyyy,mm,dd); % plasticfile = sprintf('STA_LB_PLASTIC_%s%02d%02d_V11.cdf',num2str(yyyy),mm,dd);

    paths = {impactpath,plasticpath};
    files = {impactfile,plasticfile};
    links = {[impactpath impactfile],[plasticpath plasticfile]};

    cd(nasaserv, paths{1});
    mget(nasaserv,files{1},'./data/impact');
    cd(nasaserv, paths{2});
    mget(nasaserv,files{2},'./data/plastic');
end
close(nasaserv);

pospath = '/pub/stereo/Position/ahead/';
posfiles = {sprintf('position_ahead_%s_HEEQ.txt',num2str(yyyy)),sprintf('position_ahead_%s_HEE.txt',num2str(yyyy))};

% if exist(['./pos/' posfiles{1}], 'file') == 0
caltechserv = ftp('mussel.srl.caltech.edu:21');
cd(caltechserv, pospath);
mget(caltechserv,posfiles{1},'./pos');
close(caltechserv);

caltechserv = ftp('mussel.srl.caltech.edu:21');
cd(caltechserv, pospath);
mget(caltechserv,posfiles{2},'./pos');
close(caltechserv);
% end