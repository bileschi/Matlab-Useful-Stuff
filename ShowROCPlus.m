function ShowROCPlus(RocStructure, extrastring, Color, LineWidth)
%function ShowROC(RocStructure, extrastring, Color, LineWidth)
%
EER = RocStructure.EqualErrorRate;

if(nargin == 1)
  subplot(2,2,2);
  plot(RocStructure.normfp, RocStructure.normtp);
  axis([0,1,(1-EER),1]);
  subplot(2,2,3);
  plot(RocStructure.normfp, RocStructure.normtp);
  axis([0,EER,0,1]);
  subplot(2,2,4);
  plot(RocStructure.normfp, RocStructure.normtp);
end

if(nargin == 2)
  subplot(2,2,2);
  hold on;
  title('High true positive Region');
  plot(RocStructure.normfp, RocStructure.normtp,extrastring);
  axis([0,1,(1-EER),1]);
  subplot(2,2,3);
  hold on;
  plot(RocStructure.normfp, RocStructure.normtp,extrastring);
  axis([0,EER,0,1]);
  subplot(2,2,4);
  hold on;
  plot(RocStructure.normfp, RocStructure.normtp,extrastring);
end

if(nargin  == 3)
  subplot(2,2,2);
  plot(RocStructure.normfp, RocStructure.normtp, extrastring, 'Color', Color);
  axis([0,1,(1-EER),1]);
  subplot(2,2,3);
  plot(RocStructure.normfp, RocStructure.normtp, extrastring, 'Color', Color);
  axis([0,EER,0,1]);
  subplot(2,2,4);
  plot(RocStructure.normfp, RocStructure.normtp, extrastring, 'Color', Color);
end

if(nargin  == 4)
  subplot(2,2,2);
  plot(RocStructure.normfp, RocStructure.normtp, extrastring, 'Color', Color, 'LineWidth',LineWidth);
  axis([0,1,(1-EER),1]);
  subplot(2,2,3);
  plot(RocStructure.normfp, RocStructure.normtp, extrastring, 'Color', Color, 'LineWidth',LineWidth);
  axis([0,EER,0,1]);
  subplot(2,2,4);
  plot(RocStructure.normfp, RocStructure.normtp, extrastring, 'Color', Color, 'LineWidth',LineWidth);
end

