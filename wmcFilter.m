function result = wmcFilter(im,iteration)
%weighted mean curvature filter, implemented by Yuanhao Gong
u = single(im);
N = size(u,1)*size(u,2); 
C = size(u,3);
offset=int32(reshape(-(N-1):0,size(u,1),size(u,2)));
for ch=1:C %discrete weighted mean curvature filter on each color channel
    for i=1:iteration
        tmp = wmc(u(:,:,ch),offset);
        u(:,:,ch) = u(:,:,ch) + tmp;
    end
end
result = uint8(u);
%% compute discrete weighted mean curvature
function dm=wmc(u,offset)
k=[1,1,0;2,-6,0;1,1,0]/6;
k2=[2,4,1;4,-12,0;1,0,0]/12;
dist = zeros([size(u),8],'single');
dist(:,:,1) = conv2(u,k,'same');
dist(:,:,2) = conv2(u,fliplr(k),'same');
dist(:,:,3) = conv2(u,k','same');
dist(:,:,4) = conv2(u,flipud(k'),'same');
dist(:,:,5) = conv2(u,k2,'same');
dist(:,:,6) = conv2(u,fliplr(k2),'same');
dist(:,:,7) = conv2(u,flipud(k2),'same');
dist(:,:,8) = conv2(u,rot90(k2,2),'same');
tmp = abs(dist); %to find the signed minimum absolute distance
[~,ind] = min(tmp,[],3); %turn sub to index, but faster than sub2ind
index = int32(ind)*int32(size(dist,1)*size(dist,2))+offset;
dm = dist(index); 
%{ 
@article{GONG2019,
title = "Weighted mean curvature",
journal = "Signal Processing",
volume = "164",
pages = "329 - 339",
year = "2019",
issn = "0165-1684",
doi = "https://doi.org/10.1016/j.sigpro.2019.06.020",
url = "http://www.sciencedirect.com/science/article/pii/S0165168419302282",
author = "Yuanhao Gong and Orcun Goksel",}
%}
