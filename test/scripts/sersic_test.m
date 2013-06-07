% Script to test sersic profile on example
% and used in the sersic spec file to check the data

width = 401;
height = 401;


%Matlab is one indexed therefore these values
%match the actual fits center. Javascript is zero indexed
%so we have to subtract one in the javascript version
centerX = 189.614;
centerY = 186.2151;

effRadius = 51.145266;
intensity = 20;
angle = 0.469462;
axisRatio = 0.6419221;
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
%savejson('',ordered_output,'FileName', 'sersic','FloatFormat','%.15e')


transform = fft2(output);
tmp = transform.*transform;
conv = ifft2(tmp);

norm = 1/(401*401);

conv = conv.*norm;
subplot(2,2,1)
image(conv)
shifted_conv = fftshift(conv);

subplot(2,2,2)
image(shifted_conv)
colormap(gray)

subplot(2,2,3)

image(conv_fft2(output,output,'same')*norm);

realconv = conv2(output,output,'same');
realconv = realconv.*norm;
subplot(2,2,4)
image(realconv)
