
bc_dir = 1;
bc_neu = 2;

% need string input_file
fid = fopen(input_file);

% problem title
tline = fgetl(fid);
prob_title = tline;
disp(prob_title);

% number
tline = fgetl(fid);
cc = textscan(tline, '%d %d');
n = cc{1};
nfield = cc{2};

% allocate
% elements
u = zeros(n,1);
x = zeros(2,n);
y = zeros(2,n);
node = zeros(2,n);
bc = zeros(2,n);
dlen = zeros(n,1);
dnorm = zeros(2,n);
% fields
xfield = zeros(2,nfield);

%
% load elements
%

% skip section header
tline = fgetl(fid);
% element end point
for i = 1:n
    tline = fgetl(fid);
    cc = textscan(tline, '%d %f %f');
    y(1,i) = cc{2};
    y(2,i) = cc{3};
end

% skip section header
tline = fgetl(fid);
% element connectivity and BC
for i = 1:n
    tline = fgetl(fid);
    cc = textscan(tline, '%d %d %d %d %f');
    node(1,i) = cc{2};
    node(2,i) = cc{3};
    bc(1,i) = cc{4};
    bc(2,i) = cc{5};
end

if nfield > 0
% skip section header
tline = fgetl(fid);
% field points
for i = 1:nfield
    tline = fgetl(fid);
    cc = textscan(tline, '%d %f %f');
    xfield(1,i) = cc{2};
    xfield(2,i) = cc{3};
end
end

% compute midpoints and normals for elements
for i = 1:n
    j1 = node(1,i);
    j2 = node(2,i);
    x(1,i) = 0.5 * (y(1,j1) + y(1,j2));
    x(2,i) = 0.5 * (y(2,j1) + y(2,j2));
    
    h1 = y(2,j2) - y(2,j1);
    h2 = -y(1,j2) + y(1,j1);
    el = sqrt(h1^2 + h2^2);
    dnorm(1,i) = h1/el;
    dnorm(2,i) = h2/el;
    dlen(i) = el;
end

% compute bounding domain
xmin = min(x(1,:));
xmax = max(x(1,:));
ymin = min(x(2,:));
ymax = max(x(2,:));
% slightly expand the box
scale = 1.05;
xyd = max(xmax-xmin,ymax-ymin)*0.5*scale;
xcen = (xmin+xmax)/2;
ycen = (ymin+ymax)/2;
xmin = xcen - xyd;
xmax = xcen + xyd;
ymin = ycen - xyd;
ymax = ycen + xyd;
xlen = xmax - xmin;
ylen = ymax - ymin;


fclose(fid);
clear fid tline cc;


