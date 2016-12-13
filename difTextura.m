function textura = Untitled2(Igray, bw, sbl, dsk)
% Igray -> imatge en escala de grisos
% bw -> imatge binaritzada
% sbl -> fspecial('sobel')
% dsk -> strel('disk',15)
    bw = imerode(bw,d);
    Isobel = imfilter(I,h).*uint8(bw);
    textura = sum(sum(bw))/sum(sum(Isobel));
end

