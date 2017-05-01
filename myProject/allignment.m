clear all;
close all;
im = imread('object2.png');
imt = imread('object2t.png');

bwim = im>0;
bwim1 = imt>0;

padsize = 100;
s = padarray(bwim, [padsize padsize]);
st = padarray(bwim1, [padsize padsize]);
H = size(st,1);
[D, L] = bwdist(st); 

Lx = floor((L-1)/H)+1;
Ly = mod((L-1), H)+1;

[Ys,Xs]=find(s);

Ys_org = Ys;
Xs_org =Xs;

[Yst,Xst]=find(st);
cXdiff = mean(Xst) - mean(Xs); cYdiff = mean(Yst) - mean(Ys);
oldA = [1 0 0; 0 1 0; cXdiff cYdiff 1];

N = 50;
stopEPS = 10;

for i=1:N
    newXY = [Xs_org Ys_org ones(size(Xs))]*oldA ;
    if i~=1
      if sum(sum(abs(newXY-oldXY)))<stopEPS
        break;
      end
    end
    oldXY = newXY;
    Xs = round(newXY(:,1));
    Ys = round(newXY(:,2));
    
    b = zeros(size(Xs,1),1);
    a = zeros( size(Xs, 1), 6);
    for j=1:size(Xs,1)
      a( [j*2-1,j*2],:) = [Xs(j) Ys(j) 1 0 0 0; 0 0 0 Xs(j) Ys(j) 1];
      b( [j*2-1,j*2] ) = [Lx(Ys(j),Xs(j)) Ly(Ys(j),Xs(j))];
    end
    A = pinv(a)*b;
    oldA = oldA*[A(1) A(4) 0; A(2) A(5) 0; A(3) A(6) 1];
end


 aligned = imtransform(s, maketform('projective', double(oldA)), 'XData',[1 size(s,2)],'YData',[1 size(s,1)]);
 aligned = aligned((padsize+1):(end-padsize), (padsize+1):(end-padsize));
 
 figure(1);
 c = double(repmat(im, [1 1 3]));
 c(:,:,2) = imt; c(:,:,3) = aligned;
 imshow(c); 
 oldA
% figure;
% image(Lx,'CDataMapping','scaled');
% colorbar;
% 
% figure;
% image(Ly,'CDataMapping','scaled');
% colorbar;
% 
% figure;
% image(L,'CDataMapping','scaled');
% colorbar;
