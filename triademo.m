function triademo(varargin)
%TRIADEMO run a series of demos for FINDTRIA.
%   TRIADEMO(II) runs the II-th demo, where +1 <= II <= +3. 
%   Demos illustrate the functionallity of the FINDTRIA
%   routine -- performing spatial queries on collections of
%   simplexes.
%
%   See also FINDTRIA, MAKETREE

%   Darren Engwirda : 2014 --
%   Email           : de2363@columbia.edu
%   Last updated    : 09/04/2017

    if (nargin>=1) 
        id = varargin{1}; 
    else
        id =   +1;
    end

    close all ;

    switch (id)
%------------------------------------------------- call demo
        case 1, demo1 ;
        case 2, demo2 ;
        case 3, demo3 ;
        otherwise
    error('triademo:invalidInput','Invalid demo selection.') ;
    end

end

function demo1
%-----------------------------------------------------------
    fprintf(1,[ ...
'   FINDTRIA performs spatial queries on collections of si-\n',...
'   mplexes (i.e. triangles, tetrahedrons, and their d-dim-\n',...
'   ensional counterparts).\n\n',...
'   Queries are computed quickly by making use of an axis- \n',...
'   aligned bounding-box tree (an AABB-TREE) to "localise" \n',...
'   comparisons -- intersection tests are only made between\n',...
'   points and triangles that are spatially "close" to each\n',...
'   other.\n\n',... 
'   FINDTRIA does NOT require the underlying triangulation \n',...
'   be Delaunay -- arbitrary collections of simplexes are  \n',...
'   supported, including, non-Delaunay, non-convex and even\n',...
'   overlapping configurations. This is true for general d-\n',...
'   dimensional simplexes, not just triangles and tetrahed-\n',...
'   rons. These capabilities mean that FINDTRIA can be used\n',...
'   for a significantly more general set of problems than  \n',...
'   existing MATLAB and/or OCTAVE point-location routines.\n\n']);

    filename = mfilename('fullpath');
    filepath = fileparts( filename );

    addpath([filepath,'/mesh-file']);
    addpath([filepath,'/aabb-tree']);

    meshfile = ...
        [filepath,'/test-data/lakes.msh'] ;

    mesh = loadmsh(meshfile);
    
    vert = mesh.point.coord(:,1:2);
    tria = mesh.tria3.index(:,1:3);
   
    keep = unique(tria(:)) ;
   
    vmin = min(vert(keep,:),[],1);
    vmax = max(vert(keep,:),[],1);
    vdel = vmax - vmin;
    vmin = vmin - vdel * .1;
    vmax = vmax + vdel * .1;
    
    test = rand(1000,2);
    test(:,1) = ...
   (vmax(1)-vmin(1))*test(:,1)+vmin(1) ;
    test(:,2) = ...
   (vmax(2)-vmin(2))*test(:,2)+vmin(2) ;
  
   [tptr,tidx,tree] = findtria(vert,tria,test);
    
    tpos = nan(size(tptr,1),1);
    okay = tptr(:,1) > +0;
    tpos(okay) = tidx(tptr(okay,1));
 
    fclr = [.95,.95,.55];
    eclr = [.50,.30,.30];
    
    figure('color','w'); hold on;
    patch('faces',tria,'vertices',vert,'facecolor',fclr,...
        'edgecolor',eclr,'facealpha',.2);
    plot(test(~isnan(tpos),1), ...
         test(~isnan(tpos),2),'b.','markersize',16);
    plot(test( isnan(tpos),1), ...
         test( isnan(tpos),2),'r.','markersize', 8);
    set(gca,'units','normalized','position',[0.05,0.05,.90,.90]);
    axis image off;
    adat = axis;
    title('POINT-LOCATION');
    
    figure('color','w'); hold on;
    drawtree(tree);
    set(gca,'units','normalized','position',[0.05,0.05,.90,.90]);
    axis image off;
    axis(adat);
    title('AABB-INDEX');
    
    drawnow;
    
    set(figure(1),'units','normalized', ...
        'position',[.05,.50,.30,.35]) ;
    set(figure(2),'units','normalized', ...
        'position',[.35,.50,.30,.35]) ;
    
end

function demo2
%-----------------------------------------------------------
    fprintf(1,[ ...
'   FINDTRIA is a d-dimensional algorithm, and can compute \n',...
'   point-location queries for general tetrahedral tessell-\n',...
'   ations. As per DEMO-1, FINDTRIA supports arbitrary non-\n',...
'   convex and non-Delaunay structures.\n\n'] ) ;
    
    filename = mfilename('fullpath');
    filepath = fileparts( filename );

    addpath([filepath,'/mesh-file']);
    addpath([filepath,'/aabb-tree']);

    meshfile = ...
        [filepath,'/test-data/eight.msh'] ;

    mesh = loadmsh(meshfile);
    
    vert = mesh.point.coord(:,1:3);
    tria = mesh.tria4.index(:,1:4);
   
    keep = unique(tria(:)) ;
   
    vmin = min(vert(keep,:),[],1);
    vmax = max(vert(keep,:),[],1);
    vdel = vmax - vmin;
    vmin = vmin - vdel * .1;
    vmax = vmax + vdel * .1;
    
    test = rand(1000,3);
    test(:,1) = ...
   (vmax(1)-vmin(1))*test(:,1)+vmin(1) ;
    test(:,2) = ...
   (vmax(2)-vmin(2))*test(:,2)+vmin(2) ;
    test(:,3) = ...
   (vmax(3)-vmin(3))*test(:,3)+vmin(3) ;
  
   [tptr,tidx,tree] = findtria(vert,tria,test);
    
    tpos = nan(size(tptr,1),1);
    okay = tptr(:,1) > +0;
    tpos(okay) = tidx(tptr(okay,1));
 
    fclr = [.95,.95,.55];
    eclr = [.50,.30,.30];
    
    figure('color','w'); hold on;
    patch('faces',tria(:,[1,2,3]),'vertices',vert, ...
        'facecolor',fclr,'edgecolor',eclr,'facealpha',.2);
    patch('faces',tria(:,[1,4,2]),'vertices',vert, ...
        'facecolor',fclr,'edgecolor',eclr,'facealpha',.2);
    patch('faces',tria(:,[2,4,3]),'vertices',vert, ...
        'facecolor',fclr,'edgecolor',eclr,'facealpha',.2);
    patch('faces',tria(:,[3,4,1]),'vertices',vert, ...
        'facecolor',fclr,'edgecolor',eclr,'facealpha',.2);
    plot3(test(~isnan(tpos),1), ...
          test(~isnan(tpos),2), ...
          test(~isnan(tpos),3),'b.','markersize',18);
    plot3(test( isnan(tpos),1), ...
          test( isnan(tpos),2), ...
          test( isnan(tpos),3),'r.','markersize',12);
    set(gca,'units','normalized','position',[0.05,0.05,.90,.90]);
    view(20,30);
    axis image off;
    adat = axis;
    title('POINT-LOCATION');
    
    figure('color','w'); hold on;
    drawtree(tree);
    set(gca,'units','normalized','position',[0.05,0.05,.90,.90]);
    view(20,30);
    axis image off;
    axis (adat);
    title('AABB-INDEX');
    
    drawnow;
    
    set(figure(1),'units','normalized', ...
        'position',[.05,.50,.30,.35]) ;
    set(figure(2),'units','normalized', ...
        'position',[.35,.50,.30,.35]) ;
    
end

function demo3

%-----------------------------------------------------------
    fprintf(1,[...
'   FINDTRIA can theoretically be used to perform point-   \n',...
'   location in R^d, although practically, for d >= 7, such\n',...
'   computations may become inefficient, due to exponential\n',...
'   scaling with increasing dimensionality.\n\n',...
'   FINDTRIA typically outperforms the TSEARCHN routine.\n\n']) ;

    filename = mfilename('fullpath');
    filepath = fileparts( filename );

    addpath([filepath,'/mesh-file']);
    addpath([filepath,'/aabb-tree']);

%------------------------------------- point-location in R^3
    fprintf(1,[...
'   Point-location in R^3: \n\n']) ;

    vert = randn(500,3);
    tria = delaunayn(vert);

    test = +5.*rand(1000,size(vert,2));
    test = test-2.50*ones(size(test));
 
    tic
   [tptr,tidx,tree] = findtria(vert,tria,test);
    
    fprintf(1, ...
'   FINDTRIA: %f seconds\n',toc);
    
    tpos = nan(size(tptr,1),1);
    okay = tptr(:,1) > +0;
    tpos(okay) = tidx(tptr(okay,1));
    
    tic
    T = tsearchn(vert,tria,test);
    
    fprintf(1, ...
'   TSEARCHN: %f seconds\n',toc);
    fprintf(1,'\n');
    
    
    fclr = [.95,.95,.55];
    eclr = [.50,.30,.30];
    
    figure('color','w'); hold on;
    patch('faces',tria(:,[1,2,3]),'vertices',vert, ...
        'facecolor',fclr,'edgecolor',eclr,'facealpha',.2);
    patch('faces',tria(:,[1,4,2]),'vertices',vert, ...
        'facecolor',fclr,'edgecolor',eclr,'facealpha',.2);
    patch('faces',tria(:,[2,4,3]),'vertices',vert, ...
        'facecolor',fclr,'edgecolor',eclr,'facealpha',.2);
    patch('faces',tria(:,[3,4,1]),'vertices',vert, ...
        'facecolor',fclr,'edgecolor',eclr,'facealpha',.2);
    plot3(test(~isnan(tpos),1), ...
          test(~isnan(tpos),2), ...
          test(~isnan(tpos),3),'b.','markersize',18);
    plot3(test( isnan(tpos),1), ...
          test( isnan(tpos),2), ...
          test( isnan(tpos),3),'r.','markersize',12);
    set(gca,'units','normalized','position',[0.05,0.05,.90,.90]);
    axis image off;
    adat = axis;
    view(3); light; camlight;
    title('POINT-LOCATION');
    
    figure('color','w'); hold on;
    drawtree(tree);
    set(gca,'units','normalized','position',[0.05,0.05,.90,.90]);
    axis image off;
    axis(adat);
    view(3); light; camlight;
    title('AABB-INDEX');
    
    drawnow;
    
    set(figure(1),'units','normalized', ...
        'position',[.05,.50,.30,.35]) ;
    set(figure(2),'units','normalized', ...
        'position',[.35,.50,.30,.35]) ;
    
    
%------------------------------------- point-location in R^5  
    fprintf(1,[...
'   Point-location in R^5: \n\n']) ;

    vert = randn(500,5);
    tria = delaunayn(vert);

    test = +5.*rand(5000,size(vert,2));
    test = test-2.50*ones(size(test));
 
    tic
   [tptr,tidx,tree] = findtria(vert,tria,test);
    
    fprintf(1, ...
'   FINDTRIA: %f seconds\n',toc);
    
    tpos = nan(size(tptr,1),1);
    okay = tptr(:,1) > +0;
    tpos(okay) = tidx(tptr(okay,1));
    
    tic
    T = tsearchn(vert,tria,test);
    
    fprintf(1, ...
'   TSEARCHN: %f seconds\n',toc);
    fprintf(1,'\n');
        
end



