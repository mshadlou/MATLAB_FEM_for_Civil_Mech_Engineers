% MATLAB solver for geotechnical/structural/earthquake engineering
% Display Function is used to show the result of PDEs, i.e disp, strain, stress, etc 
% Date: 05-12-2020
% Last Update: 15-02-2021
% Licence: MIT, 
% Developer: Dr Masoud Shadlou

function Disply(R,pdem,factor,Name)
    Disp.ux = R.Displacement.x(:,1);
    Disp.uy = R.Displacement.y(:,1);
    F3 = figure(3);
        subplot(2,1,1);pdeplot(pdem,'XYData', R.Displacement.x(:,1),'ColorMap','jet');title('x disp.');
        axis image off; 
        subplot(2,1,2);pdeplot(pdem,'XYData', R.Displacement.y(:,1),'ColorMap','jet');title('y disp');
        axis image off;

    F4 = figure(4);
        pdeplot(pdem,'XYData', R.Displacement.Magnitude(:,1), 'Deformation',Disp,'ColorMap','jet','DeformationScaleFactor',factor);
        title('Disp magnitude');axis image off;
        
    F5 = figure(5);
        pdeplot(pdem,'XYData', R.VonMisesStress(:,1), 'Deformation',Disp,'ColorMap','jet','DeformationScaleFactor',factor); 
        title('Von Mises stress');axis image off;%caxis([0 1e4]);
        
    F6 = figure(6);
        pdeplot(pdem,'XYData', R.Stress.xy(:,1), 'Deformation',Disp,'ColorMap','jet','DeformationScaleFactor',factor);
        title('\tau_x_y');axis image off;
        
    F7 = figure(7);
        pdeplot(pdem,'XYData', R.Strain.xy(:,1), 'Deformation',Disp,'ColorMap','jet','DeformationScaleFactor',factor); 
        title('\gamma_x_y');axis image off;%caxis([-1e-4 1e-4]);
        print(F7,'-djpeg','-opengl','-r500',strcat(Name, ' - strain xy'));
        
    F8 = figure(8);
        pdeplot(pdem,'XYData', R.Strain.yy(:,1), 'Deformation',Disp,'ColorMap','jet','DeformationScaleFactor',factor); 
        title('\epsilon_y_y');axis image off;
        print(F8,'-djpeg','-opengl','-r500',strcat(Name, ' - strain yy'));
        
    F9 = figure(9);
        pdeplot(pdem,'XYData', R.Strain.xx(:,1), 'Deformation',Disp,'ColorMap','jet','DeformationScaleFactor',factor); 
        title('\epsilon_x_x');axis image off;
        print(F9,'-djpeg','-opengl','-r500',strcat(Name, ' - strain xx'));
end