function xyz = eito_stereo(X,x,Y,y,Z,z,d)

xyz = [0 0 0];

X   = X - 0;
x   = x - 21.0;
Y   = Y - 0;
y   = y - 0;
Z   = Z - 50;
z   = z - 30;


xyz(1)  = X*cosd(d) - x - (Z+z)*sind(d);

xyz(2)  = Y - y;

xyz(3)  = - (Z+z)*cosd(d) - X*sind(d);

xyz     = round(xyz*10)/10;