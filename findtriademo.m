function findtriademo(id)
%FINDTRIADEMO run a series of demos for FINDTRIA.
%   FINDTRIADEMO(II) runs the II-th demo, where +1 <= II <= 
%   +3. Demos illustrate the functionallity of the FINDTRIA
%   routine -- performing spatial queries on collections of
%   simplexes.
%
%   See also FINDTRIA, MAKETREE

%   Darren Engwirda : 2014 --
%   Email           : engwirda@mit.edu
%   Last updated    : 18/12/2014

%------------------------------------------------- call demo
    switch (id)
        case 1, demo1;
        case 2, demo2;
        case 3, demo3;
        otherwise
    error('findtria:invalidInput','Invalid demo selection.');
    end

end

function demo1
%-----------------------------------------------------------
    fprintf(1,...
'   FINDTRIA performs spatial queries on collections of si-\n');
    fprintf(1,...
'   mplexes (i.e. triangles, tetrahedrons, and their d-dim-\n');
    fprintf(1,...
'   ensional counterparts). Queries are computed quickly by\n');
    fprintf(1,...
'   making use of an axis-aligned bounding-box tree (aabb- \n');
    fprintf(1,...
'   tree) to "localise" the comparisons. FINDTRIA can find \n') ;
    fprintf(1,...
'   the enclosing simplex(es) for a set of points. \n') ;

    pp = randn(1000,2);
    tt = delaunayn(pp);

    pi = +7*rand(1000,size(pp,2));
    pi = pi - 3.5*ones(size(pi));
 
   [tp,ti,tr] = findtria(pp,tt,pi,'pts',[]);
    tj = nan(size(tp,1),1);
    in = tp(:,1) > +0;
    tj(in) = ti(tp(in,+1));

    
    fc = [.95,.95,.55];
    ec = [.25,.25,.25];
    
    figure;
    subplot(1,2,1); hold on;
    patch('faces',tt,'vertices',pp,'facecolor',fc,...
        'edgecolor',ec,'facealpha',.3);
    plot(pi(~isnan(tj),1),pi(~isnan(tj),2),'bo');
    plot(pi( isnan(tj),1),pi( isnan(tj),2),'r.');
    set(gca,'units','normalized','position',[0.01,0.05,.48,.90]);
    axis image off;
    aa = axis;
    title('Point-location');
    
    subplot(1,2,2); hold on;
    drawtree(tr);
    set(gca,'units','normalized','position',[0.51,0.05,.48,.90]);
    axis image off;
    axis(aa);
    title('AABB-tree');
    
end

function demo2
%-----------------------------------------------------------
    fprintf(1,...
'   Point-location can also be performed in R^3. In fact,  \n');
    fprintf(1,...
'   it can theoretically be performed in R^d, although pra-\n');
    fprintf(1,...
'   ctically, for d > 6, it''s expected that such queries  \n');
    fprintf(1,...
'   may become inefficient. \n');

    pp = randn(100,3);
    tt = delaunayn(pp);

    pi = +7*rand(2000,size(pp,2));
    pi = pi - 3.5*ones(size(pi));
 
   [tp,ti,tr] = findtria(pp,tt,pi,'pts',[]);
    tj = nan(size(tp,1),1);
    in = tp(:,1) > +0;
    tj(in) = ti(tp(in,+1));

    
    fc = [.95,.95,.55];
    ec = [.25,.25,.25];
    
    figure;
    subplot(1,2,1); hold on;
    patch('faces',tt(:,[1,2,3]),'vertices',pp,'facecolor',fc,...
        'edgecolor',ec,'facealpha',.3);
    patch('faces',tt(:,[1,4,2]),'vertices',pp,'facecolor',fc,...
        'edgecolor',ec,'facealpha',.3);
    patch('faces',tt(:,[2,4,3]),'vertices',pp,'facecolor',fc,...
        'edgecolor',ec,'facealpha',.3);
    patch('faces',tt(:,[3,4,1]),'vertices',pp,'facecolor',fc,...
        'edgecolor',ec,'facealpha',.3);
    plot3(pi(~isnan(tj),1),pi(~isnan(tj),2),pi(~isnan(tj),3),'bo');
    plot3(pi( isnan(tj),1),pi( isnan(tj),2),pi( isnan(tj),3),'r.');
    set(gca,'units','normalized','position',[0.01,0.05,.48,.90]);
    axis image off;
    aa = axis;
    view(3);
    title('Point-location');
    
    subplot(1,2,2); hold on;
    drawtree(tr);
    set(gca,'units','normalized','position',[0.51,0.05,.48,.90]);
    axis image off;
    axis(aa);
    view(3);
    light; camlight;
    title('AABB-tree');
    
end

function demo3
%-----------------------------------------------------------
    fprintf(1,...
'   FINDTRIA is NOT restricted to Delaunay triangulations. \n');
    fprintf(1,...
'   In fact, arbitrary collections of simplexes are suppor-\n');
    fprintf(1,...
'   ted, including, non-Delaunay, non-convex, and even ove-\n');
    fprintf(1,...
'   rlapping configurations. This is true for general d-si-\n');
    fprintf(1,...
'   mplexes, not just triangles and tetrahedrons. These ca-\n');
    fprintf(1,...
'   pabilities mean that FINDTRIA is applicable to a signi-\n');
    fprintf(1,...
'   ficantly more general set of problems than MATALB''s   \n');
    fprintf(1,...
'   existing spatial query routines. \n');

    ffid = fopen('hip.node_3d','r');
    data = fscanf(ffid,'%e,%e,%e,%i \r\n');
    fclose(ffid);
    
    pp = [data(1:4:end), ...
          data(2:4:end), ...
          data(3:4:end)] ;
      
    ffid = fopen('hip.tria_3d','r');
    data = fscanf(ffid,'%u,%u,%u,%u,%u \r\n');
    fclose(ffid);
    
    tt = [data(1:5:end), ...
          data(2:5:end), ...
          data(3:5:end), ...
          data(4:5:end)] ;
    tt = tt+1;
      
    pi = +175.*rand(3000,size(pp,2));
    pi = pi - 87.5.*ones(size(pi));
 
   [tp,ti,tr] = findtria(pp,tt,pi,'pts',[]);
    tj = nan(size(tp,1),1);
    in = tp(:,1) > +0;
    tj(in) = ti(tp(in,+1));
    
    
    fc = [.95,.95,.55];
    ec = [.25,.25,.25];
    
    figure;
    subplot(1,2,1); hold on;
    patch('faces',tt(:,[1,2,3]),'vertices',pp,'facecolor',fc,...
        'edgecolor',ec,'facealpha',.3);
    patch('faces',tt(:,[1,4,2]),'vertices',pp,'facecolor',fc,...
        'edgecolor',ec,'facealpha',.3);
    patch('faces',tt(:,[2,4,3]),'vertices',pp,'facecolor',fc,...
        'edgecolor',ec,'facealpha',.3);
    patch('faces',tt(:,[3,4,1]),'vertices',pp,'facecolor',fc,...
        'edgecolor',ec,'facealpha',.3);
    plot3(pi(~isnan(tj),1),pi(~isnan(tj),2),pi(~isnan(tj),3),'bo');
    plot3(pi( isnan(tj),1),pi( isnan(tj),2),pi( isnan(tj),3),'r.');
    set(gca,'units','normalized','position',[0.01,0.05,.48,.90]);
    axis image off;
    aa = axis;
    view(3);
   %light; camlight;
    title('Point-location');
    
    subplot(1,2,2); hold on;
    drawtree(tr);
    set(gca,'units','normalized','position',[0.51,0.05,.48,.90]);
    axis image off;
    axis(aa);
    view(3);
    light; camlight;
    title('AABB-tree');
    
end
