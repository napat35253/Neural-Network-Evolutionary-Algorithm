% definition of slopes for training, validation and testing

function alpha = GetSlopeAngle(x, iSlope, iDataSet)

if (iDataSet == 1)                                % Training
 if (iSlope == 1) 
   alpha = 4 + sin(x/100) + cos(sqrt(2)*x/50);    % You may modify this!
 elseif ( iSlope ==2)
     alpha = 4 + sin(x/100) - cos(sqrt(2)*x/50);
 elseif (iSlope == 3)
     alpha = 4 + sin(x/100) - cos(sqrt(2)*x/40);
 elseif (iSlope == 4)
     alpha = 4 + sin(x/90) - cos(sqrt(2)*x/50);
 elseif (iSlope == 5)
     alpha = 4 + sin(x/30) - cos(sqrt(3)*x/50);
 elseif (iSlope == 6)
     alpha = 3 + sin(x/40) + cos(sqrt(4)*x/50);
 elseif (iSlope == 7) 
     alpha = 3 + sin(x/40) - cos(sqrt(2)*x/40);
 elseif (iSlope == 8) 
     alpha = 3 + sin(x/30) + cos(sqrt(3)*x/50);
 elseif (iSlope == 9) 
     alpha = 3 + sin(x/40) - cos(sqrt(4)*x/40);
 elseif (iSlope== 10)
     alpha = 4 + sin(x/20) - cos(sqrt(2)*x/40);
 end 
 
elseif (iDataSet == 2)                            % Validation
 if (iSlope == 1) 
    alpha = 4 + sin(x/100) - cos(sqrt(3)*x/40);
 elseif (iSlope == 2) 
   alpha = 4 + sin(x/100) + cos(sqrt(3)*x/40);
 elseif (iSlope == 3) 
   alpha = 4 + sin(x/90) + cos(sqrt(2)*x/20);
 elseif (iSlope == 4) 
   alpha = 5 + sin(x/100) + cos(sqrt(3)*x/40);
 elseif (iSlope == 5) 
   alpha = 4 + sin(x/80) - cos(sqrt(3)*x/40);
 end
 
elseif (iDataSet == 3)                           % Test
 if (iSlope == 1) 
   alpha = 6 - sin(x/100) - cos(sqrt(7)*x/50);
 elseif (iSlope == 2)
   alpha = 5 - sin(x/140) + cos(sqrt(4)*x/30);
 elseif (iSlope == 3)
   alpha = 4 + (x/800) + sin(x/70) + cos(sqrt(7)*x/100);
 elseif (iSlope == 4)
   alpha = 2 - sin(x/100) + cos(sqrt(3)*x/60);
 elseif (iSlope == 5)
   alpha = 4 + (x/1000) + sin(x/70) + cos(sqrt(7)*x/100);
 end
end
