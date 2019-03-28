function [ maxMinStr, distancesStr, grid, tileCentreDistance ] = gridRSSI(varTrials,obus,mapTileSize,rsuPos,rsus)
%gridRSSI Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:length(obus)
        minVehLat(i) = min(varTrials.obu.(obus{i}).TxCAM.CamLat);
        minVehLon(i) = min(varTrials.obu.(obus{i}).TxCAM.CamLon);
        maxVehLat(i) = max(varTrials.obu.(obus{i}).TxCAM.CamLat);
        maxVehLon(i) = max(varTrials.obu.(obus{i}).TxCAM.CamLon);
    end
    maxLat = max(maxVehLat);
    maxLon = max(maxVehLon);
    minLat = min(minVehLat);
    minLon = min(minVehLon);
    
    longestDistance = src.trialsProcessing.haversineMeter(minLat, minLon, maxLat, maxLon);
    height = src.trialsProcessing.haversineMeter(minLat, minLon, minLat, maxLon);
    width = src.trialsProcessing.haversineMeter(minLat, minLon, maxLat, minLon);
    
    maxMinStr.maxLat = maxLat;
    maxMinStr.maxLon = maxLon;
    maxMinStr.minLat = minLat;
    maxMinStr.minLon = minLon;
    
    distancesStr.longestDistance = longestDistance;
    distancesStr.width = width;
    distancesStr.height = height;
    
    xTiles = floor(width/mapTileSize);
    yTiles = floor(height/mapTileSize);
    
    xTileSize = (maxLat - minLat)/xTiles;
    yTileSize = (maxLon - minLon)/yTiles;
    
    
    grid.xGrid = minLat:xTileSize:maxLat;
    grid.xGrid = grid.xGrid(2:end-1);
    grid.yGrid = minLon:yTileSize:maxLon;
    grid.yGrid = grid.yGrid(2:end-1);

    [A,B] = meshgrid(grid.xGrid,grid.yGrid);
    c=cat(2,A',B');
    d=reshape(c,[],2);
    
    grid.xyGrid = d;
    grid.xTileSize = xTileSize;
    grid.yTileSize = yTileSize;
    
    fprintf('Find distance of each RSU from the tile incentres\n');
    for i = 1:length(rsuPos)
        for k = 1:length(grid.xyGrid)
            tileCentreDistance.(rsus{i}).distance(k) = ...
                src.trialsProcessing.haversineMeter(rsuPos(i,1), rsuPos(i,2), ...
                grid.xyGrid(k,1), grid.xyGrid(k,2));
        end
    end

end

