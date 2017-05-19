function [iy, im, id, ut] = jd2date(jd2000)
% [iy, im, id, ut] = jd2date(jd2000)
% Input: Julian Day 2000 jd2000(:)
% Output:  Year iy(:) [yyyy]
%         Month im(:) [1-12]
%           Day id(:) [1-31]
%               ut(:) [hours, 0-24] 

[iy, im,id, ih, min, sec] = datevec(jd2000+730486);
ut = ih+min/60+sec/3600;

