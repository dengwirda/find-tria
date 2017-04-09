# `FINDTRIA: Point-In-Simplex Queries in R^d`

`FINDTRIA` provides efficient d-dimensional `point-in-simplex` queries in <a href="http://www.mathworks.com">`MATLAB`</a> / <a href="https://www.gnu.org/software/octave">`OCTAVE`</a>.

`FINDTRIA` computes spatial queries for collections of simplexes (triangles, tetrahedrons, etc) in d-dimensional space. Unlike MATLAB's existing point-location facilities, FINDTRIA supports general collections of simplexes, including non-Delaunay, non-convex, and even overlapping configurations, and can compute multiple intersections per query point. 

`FINDTRIA` is based on an efficient d-dimensional AABB-tree, which is used to speed-up the computation of spatial queries. 

FINDTRIA is relatively efficient. It's typically many orders of magnitude faster than brute-force searches, and is often faster than MATLAB's inbuilt routine TSEARCHN, especially when the number of query points is large. MATLAB's inbuilt POINTLOCATION routine is usually faster than FINDTRIA when the underlying triangulation is Delaunay, but is (as of R2014b) typically slower -- sometimes by a large factor -- for non-Delaunay triangulations. It is also restricted to two- and three-dimensional problems.

FINDTRIA was not specifically designed to outperform MATLAB's existing point-location routines (though it sometimes does a good job), it's main purpose is to facilitate efficient queries on non-Delaunay triangulations in arbitrary dimensions -- capabilities that are currently unsupported by existing inbuilt routines.

FINDTRIA is also expected to support additional spatial query types in the future, including line-tria intersections, amongst others.

See FINDTRIADEMO, FINDTRIA for additional details.
