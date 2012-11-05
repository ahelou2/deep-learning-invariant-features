function M = myLoadclip_3dm(file, spatial_size, fast, smooth)

    readerobj = mmread(file, [], [], false, true);

    vidFrames = readerobj.frames;
    l = length(vidFrames);
    
    first_frame = fix_frame(vidFrames(1).cdata, spatial_size);
    
    gaussFilter = fspecial('gaussian', [3 3], 0.5) ;

    if fast
        M = zeros(size(first_frame, 1), size(first_frame,2), floor(l/2), 'single');        
    else        
        M = zeros(size(first_frame, 1), size(first_frame,2), l, 'single');
    end
    
    if fast
        for i = 1:2:floor(l/2)*2-1
            fixed_frame = fix_frame(vidFrames(i).cdata, spatial_size);
            if smooth
                fixed_frame = smooth_frame(fixed_frame, gaussFilter);
            end
            M(:, :, i) = fixed_frame;
        end
    else
        for i = 1:l
            fixed_frame = fix_frame(vidFrames(i).cdata, spatial_size);

            if smooth
                fixed_frame = smooth_frame(fixed_frame, gaussFilter);                
            end

            M(:, :, i) = fixed_frame;
        end
    end

end

function smoothedFrame = smooth_frame(frame, filter)

smoothedFrame = imfilter(frame, filter) ;

end
