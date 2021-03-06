%% Will colour coat the spatial footprints based on preferred firing distance or angle.
% INPUT: 
%       - distanceMat: Matrix of preferred firing distances
%       - angleMat: Matrix of preferred firing angles
%       - ms.SFPs: Miniscope structure, must containt "SFPs" field
%       containing the SpatialFootPrints. 
% OUTPUT:
%       Produces colourcoated figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�mmanuel Wilson

distance = true;                                                          % Change to true if you wish to produce distance based figure
totaldist = 35;
goodcells = msA23.SFPs(:,:,fullpassA23);
mouse = 'A2JH3';
con = 'B';
if distance
    pref = distanceMatA23;
    sname = 'Distance';
else
    pref = angleMat84;
    sname = 'Angle';
end
% % % goodcells(:,:,noPassed) = [];
mask = zeros(size(goodcells(:,:,:)));
for i = 1 : length(goodcells(1,1,:))
    mtemp = goodcells(:,:,i);
    maskThresh = prctile(mtemp(find(mtemp)),90);
    mind = find(mtemp>=maskThresh);    
    mtemp(mind) = pref(i);
    mtemp(find(mtemp~=pref(i))) = 0;
    mask(:,:,i) = mtemp;
end

mask = sum(mask,3);
mask(find(mask == 0)) = NaN;
figure
imagesc(mask,'AlphaData',~isnan(mask))
if distance
    colormap(jet)
    caxis([0 totaldist])
else
    colormap(hsv(8))
    caxis([0 360])
end
colorbar
set(gca,'color',0*[1 1 1]); 
title([mouse 'Context' con ' Preferred Firing ' sname],'FontSize',26)

saveas(gcf,['Pref', sname,'TopologyContext', con,'_', mouse, '.fig'])
saveas(gcf,['Pref', sname,'TopologyContext ', con, '_', mouse, '.eps'])