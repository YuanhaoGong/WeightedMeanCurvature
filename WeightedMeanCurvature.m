function Hw=WeightedMeanCurvature(u)
%compute weighted mean curvature
k1=[1,1,0;  2, -6,0;  1,1,0]/6;
k2=[2,4,1;  4,-12,0;  1,0,0]/12;
dist = zeros([size(u),8],'single');
dist(:,:,1) = conv2(u,k1,'same');
dist(:,:,2) = conv2(u,fliplr(k1),'same');
dist(:,:,3) = conv2(u,k1','same');
dist(:,:,4) = conv2(u,flipud(k1'),'same');
dist(:,:,5) = conv2(u,k2,'same');
dist(:,:,6) = conv2(u,fliplr(k2),'same');
dist(:,:,7) = conv2(u,flipud(k2),'same');
dist(:,:,8) = conv2(u,rot90(k2,2),'same');
%% find minimum signed distance
[~,ind] = min(abs(dist),[],3);
%turn sub to index (sub2ind but faster)
N=size(u,1)*size(u,2); 
offset=int32(reshape(-(N-1):0,size(u,1),size(u,2)));
index=offset+int32(ind*N);
Hw = dist(index); 