function X = extractVideoBlksVanH(path, prefix, sp_size, tp_size, ...
  num_perclip, lag, vidClipsIdxs, savepath, smooth, saveIdx, cutH)

% path = '/afs/cs.stanford.edu/u/wzou/scratch/phase/data/vanH_videos/'
% prefix = 'vanH*'


% extract video blocks for unsupervised training
% reason: loading videos and doing this on-line is time-consuming, so 
% extract and store all training samples in RAM

% path: where training videos are stored
% prefix: e.g. actioncliptrain*
% sp_size: square spatial size 
% tp_size: temporal size
% block size = sp_size x sp_size x tp_size (e.g. 20x20x20)
% num_perclip: number of patches to extract per video clip
% lag: number of frames to jump between extracted frames in a block. 
% vidClipsIdxs: video clips indices or their position in the dirlist struct
% array. example: [ 1 4 5 10] uses video clips 1,4,5, and 10 to extract
% video blocks.
% saveIdx: index which will be appended at the end of the save filtename as
% filename_ID(saveIdx).mat
% cutH: Number of top height picels to crop. This is needed because the
% VanH videos have a black band on top each frame.

% NOTES:
% - Videos are 128by128by64. In theory, if I'm extracting 12by12by4
% blocks then from each video I can extract at least
%  (128-12+1)^2*(64-4) = 821340. Let's 100 000 for now.

% requires myLoadclip_3dm.m
% addpath /afs/cs/u/wzou/mf/
% addpath /afs/cs/u/wzou/mf/s3isa/
% addpath /afs/cs/u/wzou/mf/s3isa/mmread/

% use margin
margin = 5; %pixels

% list the clip filenames
path = [path '/'] ;
dirlist = dir([path '/' prefix]);
num_clips = length(vidClipsIdxs);
for i = 1 : num_clips
    filenames{i} = dirlist(vidClipsIdxs(i)).name;
end

%sp_x_size = sp_size-cutH ;
X = zeros(sp_size*sp_size*tp_size, num_perclip*num_clips);

counter = 1;

for i = 1 : num_clips
    fprintf('loading clip: %s\n', filenames{i});
    %M = myLoadclip_3dm([path, filenames{i}], sp_size, 0, smooth);
    load([path, filenames{i}]) ;
    M = F(cutH+1:end,:,:) ;
    [dimx, dimy, dimt] = size(M);

    for j = 1 : num_perclip        
        x_pos = randi([1+margin, dimx-margin-sp_size+1]);
        y_pos = randi([1+margin, dimy-margin-sp_size+1]);
        t_pos = randi([1+margin, dimt-margin-tp_size*lag+1]);

        blk = M(x_pos: x_pos+sp_size-1, y_pos: y_pos+sp_size-1, t_pos:lag:t_pos+tp_size*lag-1);
        X(:, counter) = reshape(blk, sp_size*sp_size*tp_size, []);

        counter = counter + 1;
    end
end

filename = sprintf('blktrain_%dx%dx%d_lag%d_np%d_s%d_ID%d.mat', sp_size, ...
  sp_size, tp_size, lag, num_perclip, smooth, saveIdx);

if exist('savepath', 'var')
  save([savepath '/' filename], 'X', '-v7.3');
end

X = makeSlaveRef(X) ;

end
