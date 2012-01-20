function [feat, orig] = getPatch(img_dir, D, patch_siz, num_patch, height)

global fSiz filters c1SpaceSS c1ScaleSS c1OL c1SpaceSS c1ScaleSS c1OL

%D        = dir([img_dir '/*.pgm']);
%D        = dir([img_dir '/*.jpg']);
nImg     = length(D);
m        = ceil(nImg/10);
n        = size(c1SpaceSS,2);
feat     = cell(length(patch_siz),1);
orig     = cell(length(patch_siz),1);
rand('state',sum(100*clock));     
id       = ceil(100000*rand(1));


for i = 1:nImg
    if ( rem(i, m) == 0 )
        disp([num2str(i/m*10) ' perc. images processed']);
    end

    %% get c1 activations
    name   = [img_dir '/' D(i).name];
    stim = imread(name);
    stim = double(stim);
    if max(stim(:))>1,
      stim = stim/255;
    end
    if size(stim,3)>1
      stim = rgb2gray(stim);
    end

%    stim   = double(imread(name))/255;
%    imwrite(stim, ['tmp_' num2str(id) '.pgm']);
%    stim   = double(imread(['tmp_' num2str(id) '.pgm']))/255;
     stim   = imresize(stim, height/size(stim,1), 'bicubic');
    
    c1Resp = myRespC1(stim, filters, fSiz, c1SpaceSS, c1ScaleSS, c1OL, 1);
    
    %% get patches
    [imgy, imgx] = size(stim);
    numPos       = ceil(imgy/c1SpaceSS(1))*ceil(imgx/c1SpaceSS(1))*c1OL*c1OL;
    maxX         = ceil(imgx/ceil(c1SpaceSS(1)/c1OL));
    maxY         = ceil(imgy/ceil(c1SpaceSS(1)/c1OL));

    ResImg       = [];
    for f = 1:4
        ResImg(:,:,f) = reshape(c1Resp(numPos*(f-1)+1:numPos*(f-1)+maxX*maxY), maxY, maxX);
        %subplot(2,2,f), imshow(ResImg(:,:,f)/max(ResImg(:)));colorbar
    end

    for k = 1:length(patch_siz)
        if ((maxX-patch_siz(k)) <= 0 | (maxY-patch_siz(k)) <= 0)
            disp('Skip image');
        else
            tot_pos  = (maxX-patch_siz(k))*(maxY-patch_siz(k));
            if (num_patch > tot_pos)
                disp(['Max number of patches (' num2str(tot_pos) ') exceeded']);
                nPatch = tot_pos;
            else
                nPatch = num_patch;
            end

            rand_pos = randperm(tot_pos);

            for l = 1:nPatch
                [y, x]  = ind2sub([maxY-patch_siz(k) maxX-patch_siz(k)], rand_pos(l));
                P       = ResImg(y:y+patch_siz(k)-1, x:x+patch_siz(k)-1, :);
                feat{k} = [feat{k} reshape(P, prod(size(P)),1)];
                orig{k} = strvcat(orig{k}, name);
            end

        end
    end
end
