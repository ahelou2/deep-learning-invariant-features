%function [phase,freq,orient] = tuningCurve(W, V)
function tuningInfo = tuningCurve(W, V, patchsize, freqno, orno, phaseno)

%patchsize=12;    
    
%computing tuning curves and optimal parameters
%freqno=25; %how many frequencies
%orno=40; %how many orientations
%phaseno=25; %how many phases
%compute the used values for the orientation angles and frequencies
orvalues=[0:orno-1]/orno*pi;
freqvalues=[0:freqno-1]/freqno*patchsize/2;
phasevalues=[0:phaseno-1]/phaseno*2*pi;
tuningInfo.orvalues = orvalues ;
tuningInfo.freqvalues = freqvalues ;
tuningInfo.phasevalues = phasevalues ;

%initialize optimal values
ica_optfreq=0;
ica_optor=0;
ica_optphase=0;


    %find optimal parameters for the i-th linear feature estimated by ICA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %FIRST, FIND OPTIMAL PARAMETERS FOR CELL OF INDEX i
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %initialize the maximum response of cell i found so far
    maxresponsesofar=-inf;
    
    %start loop through all parameter values fro frequency and orientation
    for freqindex=1:freqno
        for orindex=1:orno
            %we take sum over responses for different phases to simulate drifting grating
            %initialize the variable which holds the sum for cell i
            response=0;
            
            for phaseindex=1:phaseno
                %create a grating with desired freqs and orientations and phases
                grating=creategratings(patchsize,freqvalues(freqindex),orvalues(orindex),phasevalues(phaseindex));
                %compute linear responses of RF's underlying feature subspace
                linearresponses= W*grating;
                %add their energy to energy found for this cell with other phases
                response=response+sqrt(V*(linearresponses.^2));
            end %of for phaseindex

            %check if this is max response so far and store values
            if response>maxresponsesofar
                maxresponsesofar=response;
                isa_optfreq=freqvalues(freqindex);
                isa_optor=orvalues(orindex);
            end
        end %of for freqindex
    end %of for orindex
    
    %%%%%%%%%
    
    
    %compute ISA responses when phase is changed
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %display('Phase curve');
    phaseresponse=zeros(1,length(phasevalues));
    linearresponses=zeros(size(W,1), length(phasevalues));
    for phaseindex=1:length(phasevalues)
        %create new grating with many phases
        grating=creategratings(patchsize,isa_optfreq,isa_optor,phasevalues(phaseindex));
        
        %compute response
        linearresponses(:,phaseindex)=W*grating;
        phaseresponse(phaseindex)=sqrt(V*linearresponses(:,phaseindex).^2);
    end %for phaseindex
    %normalize to simplify visualization of invariance
    phaseresponse=phaseresponse/max(phaseresponse);

    %compute ISA responses when freq is changed
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %display('Freq curve');
    freqresponse=zeros(1,freqno);
    phasenosubs = length(phasevalues);
    for freqindex=1:freqno
        for phaseindex=1:phasenosubs
            %create new grating with different freq
            grating=creategratings(patchsize,freqvalues(freqindex),isa_optor,phasevalues(phaseindex));
            %Compute response of complex cell
            linearresponses=W*grating;
            %take sum of responses over different phases
            freqresponse(freqindex)=freqresponse(freqindex)+sqrt(V*(linearresponses.^2));
        end %for phaseindex
    end %for freqindex
    
    %compute ISA responses when orientation is changed
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %display('Orientation curve');
    orresponse=zeros(1,orno);
    for orindex=1:orno
        for phaseindex=1:phasenosubs
            %create new grating with different orientation and phase
            grating=creategratings(patchsize,isa_optfreq,orvalues(orindex),phasevalues(phaseindex));
            %compute response of complex cell
            linearresponses=W*grating;
            %take sum of responses over different phases
            orresponse(orindex)=orresponse(orindex)+sqrt(V*(linearresponses.^2));
        end %for phaseindex
    end %for orindex
    
    tuningInfo.orresponse = orresponse ;
    tuningInfo.freqresponse = freqresponse ;
    tuningInfo.phaseresponse = phaseresponse ;
%     
%     %plot phase tuning curve
%     figure(1); plot(phasevalues,phaseresponse); title('Phase'); 
%     axis([min(phasevalues),max(phasevalues),-1,1]);
%     
%     %plot freq tuning curve
%     figure(2); plot(freqvalues,freqresponse); title('Freq'); 
%     
%     %plot orientation tuning curve
%     figure(3); plot(orvalues,orresponse); title('Orientation'); 
    
%     %plot phase tuning curve
%     h = figure(1) ;
%     subplot(2,2,1); plot(phasevalues,phaseresponse); title('Phase'); 
%     axis([min(phasevalues),max(phasevalues),-1,1]);
%     
%     %plot freq tuning curve
%     subplot(2,2,2); plot(freqvalues,freqresponse); title('Freq'); 
%     
%     %plot orientation tuning curve
%     subplot(2,2,3); plot(orvalues,orresponse); title('Orientation');
%     
%     %subplot(2,2,4); imshow(zeros(5,5)); title('zeros') ;
%     
%     subplot(2,2,4);
%     % Visualize RF
%     rf_matrix4disp = W(V==1,:) ;
%     show_centroids(rf_matrix4disp, sqrt(size(W,2))) ;
%     numQuadPairs = compNumQuadPairs(V) ;
%     title(['RF visual. numQuadPairs = ' num2str(numQuadPairs)]);
%     
%     % compute 2 performance indicators: hartiganDipTest and localMaximaTest
%     hartiganDipTest = 0 ;
%     localMaximaTest = 0 ;
%     if min(phaseresponse >= 0.6)
%       [dipOr, pOr] = HartigansDipSignifTest(orresponse, 100); 
%       [dipFreq, pFreq] = HartigansDipSignifTest(freqresponse, 100);
%       if dipOr < 0.04 && dipFreq < 0.04
%         hartiganDipTest = 1 ;
%       end
%       [zmaxOr,imax,zmin,imin]= extrema(orresponse);
%       [zmaxFreq,imax,zmin,imin]= extrema(freqresponse);
%       if length(zmaxOr) == 1 && length(zmaxFreq) == 1
%         localMaximaTest = 1 ;
%       end
%     end
%     
