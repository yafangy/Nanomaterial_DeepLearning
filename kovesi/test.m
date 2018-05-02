image=imread(fullfile(Path,fileList{118}));
image = imresize(image,0.1);



imlab = rgb2lab(image);

norm_factor = [1/median(median(imlab(:,:,1)))*50, -median(median(imlab(:,:,2))), -median(median(imlab(:,:,3)))];

imlab_norm = imlab;
imlab_norm(:,:,1) = imlab_norm(:,:,1)*norm_factor(1);
imlab_norm(:,:,2) = imlab_norm(:,:,2)+norm_factor(2);
imlab_norm(:,:,3) = imlab_norm(:,:,3)+norm_factor(3);


im_norm = lab2rgb(imlab_norm);

figure(1); 

imshow(im_norm);

figure(2);
[l, Am, C] = slic(im_norm, 1000,2,1,'median');
imshow(drawregionboundaries(l, im_norm,[255,255,255]));
figure(3);
lc = spdbscan(l, C, Am, 1.5);
% lc = spdbscan(lc, C, Am, 0.8);
% lc = spdbscan(lc, C, Am, 0.8);
imshow(drawregionboundaries(lc, im_norm,[255,255,255]));


%%

scan_E = linspace(0.1,20,100);
num_cluster = zeros(size(scan_E));

for iter = 1:length(scan_E)
    E = scan_E(iter);
    lc = spdbscan(l, C, Am, E);
    num_cluster(iter) = max(lc(:));
end

figure(4);
semilogy(scan_E, num_cluster,'o-');
xlabel('E');
ylabel('# of clusters');