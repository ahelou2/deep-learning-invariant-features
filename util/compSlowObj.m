
function slowObjMat = compSlowObj(data)
  
  op.xcorr = 1 ;
  sqXCorr = sq_corr_temporal(data, op) ;
  [sqCorrT, sqCorrTplus1 varT varTplus1] = sq_corr_T_Tplus1(data, op) ;
  slowObjMat = compSlowObjHelper(sqXCorr, sqCorrT, sqCorrTplus1) ;
  % slowObjMat should, in principal range between -16 and 16
  slowObjMat = slowObjMat/16 ;
  % Normalize
%   normFac = varT'*varTplus1 ;
%   normFacNonZero = normFac(normFac > 0) ;
%   modifier = min(min(normFacNonZero))/10
%   slowObjMat = slowObjMat./sqrt(normFac + modifier) ;
end


function slowObjMat = compSlowObjHelper(sqXCorr, sqCorrT, sqCorrTplus1)
  numFeat = size(sqXCorr,1) ;
  assert(numFeat == size(sqCorrT,1)) ;
  sqXCorr = -2*sqXCorr ;
  D = diag(sqXCorr) ;
  DVert = repmat(D, [1 numFeat]) ;
  DHoriz = repmat(D', [numFeat 1]) ;
  sqXCorr = sqXCorr + sqXCorr' + DVert + DHoriz ;

  D = diag(sqCorrT) ;
  DVert = repmat(D, [1 numFeat]) ;
  DHoriz = repmat(D', [numFeat 1]) ;
  sqCorrT = 2*sqCorrT + DVert + DHoriz ;

  D = diag(sqCorrTplus1) ;
  DVert = repmat(D, [1 numFeat]) ;
  DHoriz = repmat(D', [numFeat 1]) ;
  sqCorrTplus1 = 2*sqCorrTplus1 + DVert + DHoriz ;

  slowObjMat = sqXCorr + sqCorrT + sqCorrTplus1 ;
end