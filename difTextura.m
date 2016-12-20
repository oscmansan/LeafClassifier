function textura = difTextura(Igray, bw, sbl, dsk)
% Igray -> imatge en escala de grisos
% bw -> imatge binaritzada
% sbl -> fspecial('sobel')
% dsk -> strel('disk',15)
    bw = imerode(bw,dsk);
    Isobel = sqrt(double(imfilter(Igray,sbl)).^2+double(imfilter(Igray,sbl')).^2);
    Isobel = Isobel.*double(bw);
    textura = sum(sum(bw))/sum(sum(Isobel));
end
