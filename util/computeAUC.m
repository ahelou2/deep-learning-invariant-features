function AUC = computeAUC(scores, labels)

  numDataPts = size(scores, 1) ;
  numFilters = size(scores, 2) ;

  AUC = zeros(numFilters, 2) ;
  for i=1:1:numFilters
    [prec, tpr, fpr, thresh] = prec_rec(scores(:,i), labels) ;
    AUC(i,:) = [extractAUC(fpr, tpr) extractAUC(tpr, prec)]; % [ROCAUC PRAUC]
  end
end

function AUC = extractAUC(X, Y)

  X_lowerLimit = [0 ; X(1:end-1)] ;
  AUC = sum(Y.*(X-X_lowerLimit)) ;

end