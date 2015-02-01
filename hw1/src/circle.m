% Helper function to draw a circle
function circle(x,y,r,c)
  ang=0:0.01:2*pi;
  xp=r*cos(ang);
  yp=r*sin(ang);
  plot(x+xp,y+yp, 'Color', c);
end
