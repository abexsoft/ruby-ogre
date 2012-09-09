%{
#include <ProceduralGeometryHelpers.h>
%}

%ignore Procedural::Plane::intersect;
%ignore Procedural::Line2D::findIntersect;
%ignore Procedural::Segment2D::findIntersect;
%ignore Procedural::Segment2D::intersects;
%ignore Procedural::Line::shortestPathToPoint;
%ignore Procedural::Circle::Circle;

%include ProceduralGeometryHelpers.h

%{
%}
