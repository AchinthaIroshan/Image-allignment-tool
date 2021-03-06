clear all;
close all;
VLFEATROOT = '../vlfeat-0.9.20';
run(strcat(VLFEATROOT, '/toolbox/vl_setup'))

image1 = imread('1.jpg');
imshow(image1);
image2 = imread('2.jpg');
figure;
imshow(image2);
image1 = imread('ThGtB10.jpg');
imshow(image1);
image2 = imread('ThGtC10.jpg');
figure;
imshow(image2);

image1s = single(rgb2gray(image1));

image2s = single(rgb2gray(image2));

[fimage1, dimage1] = vl_sift(image1s);
[fimage2, dimage2] = vl_sift(image2s);

[matches, scores] = vl_ubcmatch(dimage1, dimage2);
matched(:, 1) = fimage1(1, matches(1,:));
matched(:, 2) = fimage1(2, matches(1,:)); 


matched(:, 3) = fimage2(1, matches(2,:));
matched(:, 4) = fimage2(2, matches(2,:)); 

matched(:, 5) = scores;

len = size(matched, 1);
ITER_MAX = size(matched, 1);

xshift_best = 0;
yshift_best = 0;
count_best = 0;
eps = 1;

matches = randperm(len, ITER_MAX);

for k = 1 : length(matches)
    sample = matches(k);    
    dx = matched(sample, 3) - matched(sample, 1);
    dy = matched(sample, 4) - matched(sample, 2);
    count_cur = 0;

    for i = 1:size(matched, 1)
       xi = matched(i, 1) + dx;
       yi = matched(i, 2) + dy;

       ssd = sqrt((matched(i, 3) - xi)^2 + (matched(i, 4) - yi)^2);
       if ssd < eps
           count_cur = count_cur + 1;
       end
    end
    if count_cur > count_best
       xshift_best = -dx;
       yshift_best = -dy;
       count_best = count_cur;
    end
end

xshift_best = ceil(xshift_best);
yshift_best = ceil(yshift_best);

yshift_cur = 0;
yshift_all = 0;

xshift = xshift_best;
yshift = yshift_best; 


yshift_all = yshift_all + yshift;
xshift_cur = xshift;
yshift_cur = -yshift_cur + yshift;


%blended = blendTwo(image1, image2, xshift_cur, yshift_cur);


%imshow(blended);
imageA=image1;
imageB=image2;
xshift=xshift_cur;
yshift= yshift_cur;


if xshift < 0
   xshift = -xshift;
   yshift = -yshift;

        % swap
   temp = imageB;
   imageB = imageA;
   imageA = temp;
end

[h1, w1, dummy] = size(imageA);
[h2, w2, dummy] = size(imageB);

rxdim = max(w1, xshift + w2);
rydim = max(h2, h1) + 2 * abs(yshift);
ybase = int32(abs(ceil(yshift)));
xbase = 0;

result = double(zeros(ybase+int32(rydim), xbase+int32(rxdim), 3));

%getting the 1st image 
result(1+ybase:h1+ybase, 1+xbase:w1+xbase, :) = double(imageA(1:h1, 1:w1, :));

xboundary = xbase + w1;
w = 0.5;

% blending in the second image

overlapWidth = xboundary - xshift;

for y = 1 : h2
   for x = 1 : w2
      i = int32(x + xshift + xbase);
      j = int32(y + yshift + ybase);
           
      if i < xboundary
          w = 1 - double(i - xshift) / double(overlapWidth);
          result(j, i, :) = w * result(j, i, :)+ (1 - w) * double(imageB(y, x, :));
      else
      result(j, i, :) = double(imageB(y, x, :));
      end
   end
end
result = uint8(result);
    
imshow(result);
