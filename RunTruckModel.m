function [v,tempBrake] = RunTruckModel(currentV,currentTempBrake,pressurePedal,gear,alpha,deltaT)
    
    % Constant variable
    M = 20000; %kg
    g = 9.81; % m/s^2
    tempAmb = 283; % K
    tempMax = 750; %K
    tau = 30; %s
    cBrakeTemp = 40; % K/s (Ch)
    cEngineBrakeForce = 3000;% N (Cb)
    
    % Fg [Force of Gravity]
    alphaRad = alpha * pi/ 180;
    Fg = M*g*sin(alphaRad);
    
    % Fb [Force from brakes]

    deltaTb = currentTempBrake - tempAmb;
    if pressurePedal < 0.01
        deltaTbDot = -deltaTb / tau;
    else
        deltaTbDot = cBrakeTemp * pressurePedal;
    end
    deltaTb = deltaTb + deltaTbDot*deltaT;
    
    tempBrake = tempAmb + deltaTb;
    if tempBrake < tempMax - 100
        Fb = M*g/20*pressurePedal;
    else
        Fb = M*g/20*pressurePedal*exp(-(tempBrake-(tempMax-100))/100);
    end
    
    % Feb [Force from Engine Brakes]
    switch gear
        case 1
            Feb = 7.0 * cEngineBrakeForce;
        case 2
            Feb = 5.0 * cEngineBrakeForce;
        case 3
            Feb = 4.0 * cEngineBrakeForce;
        case 4
            Feb = 3.0 * cEngineBrakeForce;
        case 5
            Feb = 2.5 * cEngineBrakeForce;
        case 6
            Feb = 2.0 * cEngineBrakeForce;
        case 7 
            Feb = 1.6 * cEngineBrakeForce;
        case 8
            Feb = 1.4 * cEngineBrakeForce;
        case 9
            Feb = 1.2 * cEngineBrakeForce;
        case 10
            Feb = cEngineBrakeForce;
        otherwise
            Feb = cEngineBrakeForce;
    end
    
    a = (Fg - Fb - Feb)/M;
    v = a*deltaT + currentV;


end

