% MATLAB solver for geotechnical/structural/earthquake engineering
% DisplyThermal Function is used to show the result of PDEs for thermal flux and seepage which are used in geotechnical engineering 
% Date: 05-12-2020
% Last Update: 15-02-2021
% Licence: MIT, 
% Developer: Dr Masoud Shadlou

function DisplyThermal(R,pdem,factor,Name)
    [qx,qy] = evaluateHeatFlux(R);
    
    F4 = figure(4);
        pdeplot(pdem,'XYData',R.Temperature,'Contour','on','FlowData',[qx qy],'ColorMap','jet');
        axis image off;
        title('Water flow direction and hydraulic gradient')
        print(F4,'-djpeg','-opengl','-r500',strcat(Name, ' - hydraulic gradient'));

end