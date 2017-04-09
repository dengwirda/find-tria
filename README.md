# `FINDTRIA: Point-In-Simplex Queries in R^d`

`FINDTRIA` provides efficient d-dimensional `point-in-simplex` queries in <a href="http://www.mathworks.com">`MATLAB`</a> / <a href="https://www.gnu.org/software/octave">`OCTAVE`</a>.

`FINDTRIA` computes spatial queries for collections of simplexes (triangles, tetrahedrons, etc) in d-dimensional space. Unlike `MATLAB`'s existing point-location facilities, `FINDTRIA` supports general collections of simplexes, including non-Delaunay, non-convex, and even overlapping configurations, and can compute multiple intersections per query point. 

`FINDTRIA` is based on an efficient d-dimensional `AABB-tree`, which is used to speed-up the computation of spatial queries. 

<p align="center">
  <img src = "../master/test-data/find-tria-small.jpg">
</p>

`FINDTRIA` is relatively efficient. It's typically many orders of magnitude faster than brute-force searches, and is often faster than `MATLAB`'s inbuilt routine `TSEARCHN`, especially when the number of query points is large. `MATLAB`'s inbuilt `POINTLOCATION` routine is usually faster than `FINDTRIA` when the underlying triangulation is Delaunay, but is often slower -- sometimes by a large factor -- for non-Delaunay triangulations. It is also restricted to two- and three-dimensional problems.

`FINDTRIA` was not specifically designed to outperform `MATLAB`'s existing point-location routines (though it sometimes does a good job), it's main purpose is to facilitate efficient queries on non-Delaunay triangulations in arbitrary dimensions -- capabilities that are currently unsupported by existing inbuilt routines.

# `Starting Out`

After downloading and unzipping the current <a href="https://github.com/dengwirda/find-tria/archive/master.zip">repository</a>, navigate to the installation directory within <a href="http://www.mathworks.com">`MATLAB`</a> / <a href="https://www.gnu.org/software/octave">`OCTAVE`</a> and run the set of examples contained in `triademo.m`:
````
triademo(1); % point-location for a 2-dimensional non-Delaunay triangulation.
triademo(2); % point-location for a 3-dimensional non-Delaunay triangulation.
triademo(3); % compare FINDTRIA and TSEARCHN for higher-dimensional problems.
````
# `Attribution!`

`FINDTRIA` makes use of the <a href="https://github.com/dengwirda/aabb-tree">`AABBTREE`</a> package. The underlying `AABB-tree` construction and search methods are described in further detail here: 

`[1]` - Darren Engwirda, <a href="http://hdl.handle.net/2123/13148">Locally-optimal Delaunay-refinement and optimisation-based mesh generation</a>, Ph.D. Thesis, School of Mathematics and Statistics, The University of Sydney, September 2014.
