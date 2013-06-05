% Script to test sersic profile on example
% and used in the sersic spec file to check the data

width = 4;
height = 4;


%Matlab is one indexed therefore these values
%match the actual fits center. Javascript is zero indexed
%so we have to subtract one in the javascript version
centerX = 2;
centerY = 2;

effRadius = 2;
intensity = 1;

angle = pi/2;
axisRatio = 1.25;

n = 4;
norm = 7.669;

output = zeros(height,width);

for x = 1:width
  for y = 1:height
    r_x = (x - centerX)*cos(angle) + (y - centerY)*sin(angle);
    r_y = ((y - centerY)*cos(angle) - (x - centerX)*sin(angle))/axisRatio;
    r = sqrt(r_x^2 + r_y^2);
    output(y,x) = intensity*exp(-norm*((r/effRadius)^(1/n) - 1));
  end
end

%Row-major order output
ordered_output = zeros(1,width*height);


for x = 1:width
  for y = 1:height
   ordered_output(x + (y - 1)*width) = output(y,x);  
  end
end

%Save data to json file
savejson('',ordered_output,'FileName', 'sersic','FloatFormat','%.15e')