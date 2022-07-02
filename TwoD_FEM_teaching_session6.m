function TwoD_FEM_teaching_session6()
% MATLAB solver for geotechnical/structural/earthquake engineering
% Teaching Code, session 6: geotechnical engineering application 101
% Examples cover: 
%           (1) Soil-tunnel interaction
%           (2) Soil-pile interaction
%           (3) Soil-quay wall
%           (4) pulling of embedded plate (anchor system)
%           (5) embedded pipeline
%           (6) seepage around sheet piles 
%           (6) Rigid/flexible foundation 
% Date: 05-12-2020
% Last Update: 10-05-2021
% Licence: MIT
% Developer: Dr Masoud Shadlou

clear all;
clc;
close all

% retaining_wall();
% pulling_embedded_plate();
% Seepage_retaining_wall();
% pile_tunnel_2D();
% Surface_foundation();

end
%%
function retaining_wall()
    % Create a PEDE Model
    pdem = StructuralModel('PlaneStrain');

    w1 = 15;                                            % left side soil width
    w2 = 10;                                            % right side soil width
    H1 = 20;                                            % maximum soil depth
    H2 = 10;                                            % minimum soil depth
    
    L1 = 15;                                            % maximum length of quay wall
    L2 = 5;                                             % minimum length of quay wall 
    wc = 0.25;                                          % quay wall thickness
    
    xs = [0 w1 0 wc 0 w2 0 -(w1+w2+wc)];
    ys = [0 0 -L1 0 L2 0 -H2 0];
    
    xp = [w1 0 wc 0 0];
    yp = [0 -L1 0 L2 (L1-L2)];
    
    nodeP = [];% quay wall
    nodeS = [];% soil
    
    for j = 1:length(xp)
        nodeP = [nodeP; sum(xp(1,1:j)) sum(yp(1,1:j))];
    end
    for j = 1:length(xs)
        nodeS = [nodeS; sum(xs(1,1:j)) sum(ys(1,1:j))];
    end
    polygP = [2 length(nodeP(:,1)) nodeP(:,1)' nodeP(:,2)']';
    polygS = [2 length(nodeS(:,1)) nodeS(:,1)' nodeS(:,2)']';
    r = max([length(polygP) length(polygS)]);

    if r == length(polygP)
        polygS = [polygS;zeros(r-length(polygS),1)];
    else
        polygP = [polygP;zeros(r-length(polygP),1)];
    end
    gdm = [polygP polygS];

    g = decsg(gdm);                                         % Decompose constructive solid 2-D geometry into minimal reg
    geometryFromEdges(pdem,g);
    
    F1 = figure(1);
        hold on; 
        pp = pdegplot(pdem);set(pp,'LineWidth',3,'Color',[0 0 0]); 
%         pdegplot(pdem,'VertexLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'EdgeLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'FaceLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'FaceAlpha',1);
        % Add a camera light, and tone down the specular highlighting
        camlight('headlight');
        material('dull');
        axis image off;
        annotation(F1,'arrow',[0.564285714285714 0.564285714285713],[0.992857142857148 0.928571428571438],'Color',[1 0 0],'LineWidth',2);
        annotation(F1,'arrow',[0.498214285714283 0.498214285714282],[0.990476190476197 0.926190476190487],'Color',[1 0 0],'LineWidth',2);
        annotation(F1,'arrow',[0.435714285714285 0.435714285714284],[0.990476190476197 0.926190476190488],'Color',[1 0 0],'LineWidth',2);
        annotation(F1,'arrow',[0.364285714285713 0.364285714285712],[0.990476190476197 0.926190476190487],'Color',[1 0 0],'LineWidth',2);
        annotation(F1,'arrow',[0.292857142857142 0.292857142857141],[0.988095238095244 0.923809523809534],'Color',[1 0 0],'LineWidth',2);
        annotation(F1,'arrow',[0.217857142857142 0.217857142857142],[0.992857142857149 0.928571428571439],'Color',[1 0 0],'LineWidth',2);
        annotation(F1,'arrow',[0.144642857142856 0.144642857142855],[0.990476190476196 0.926190476190486],'Color',[1 0 0],'LineWidth',2);  
        
        print(F1,'-djpeg','-opengl','-r500','Retaining wall - model');

    % Material properties
        structuralProperties(pdem,'Face',1,'YoungsModulus',1000,'PoissonsRatio',0.25,'MassDensity',1.5);% soil
        structuralProperties(pdem,'Face',2,'YoungsModulus',41e6,'PoissonsRatio',0.25,'MassDensity',2.5);% quay wall            
    
    % BC
        structuralBC(pdem,'Edge',[2 4],'XDisplacement',0);
        structuralBC(pdem,'Edge',3,'YDisplacement',0);
    
    % LOADING Conditions
        % CASE 1: Lateral disp of quay wall, point load (disp control)
%         structuralBC(pdem,'Vertex',[9],'XDisplacement',0.1);
        % CASE 2: Lateral disp of quay wall, point load (force control)
%         structuralBoundaryLoad(pdem,'Vertex',9,'Force',[0 10]);% [Fx Fy] kN
        % CASE 3: Vertical surface load is applied on upper part of the quay wall
        structuralBoundaryLoad(pdem,'Edge',5,'SurfaceTraction',[0;-1]);% [Px Py] kN/m
    
    structuralBodyLoad(pdem,'GravitationalAcceleration',[0 -9.81].*1e-3);% graviational load - self-weight
    % generate mesh
        mesh_size_max = 0.15;
        mesh_size_min = 0.07;
        generateMesh(pdem,'Hmax',mesh_size_max,'Hmin',mesh_size_min);
        F2 = figure(2);pdemesh(pdem);axis image off;
%             title('Mesh configuration');
%             print(F2,'-djpeg','-opengl','-r500','2D Mesh'); 

    % solve
    R = solve(pdem);
    assignin('base','R',R);

    % display 
    factor = 50;
    Disply(R,pdem,factor,'Retaining wall');
end
%%
function pulling_embedded_plate()
    % Create a PEDE Model
    pdem = StructuralModel('PlaneStrain');

    % model creation
    w = 20;                                             % soil width
    h = 20;                                             % soil depth
    
    L = 3;                                              % plate length
    wc = 0.25;                                          % plate thickness
    a = 45;                                             % angle of plate in respect to horizontal axis (degree)
    
    xs = [0 w 0 -w];
    ys = [0 0 -h 0];
    
    sx = 0.5*w-0.5*L*cosd(a)-0.5*wc*sind(a);
    sy = -0.5*h+0.5*L*sind(a)-0.5*wc*cosd(a);
    xp = [sx L*cosd(a) wc*sind(a) -0.5*L*cosd(a) -0.5*L*cosd(a)];
    yp = [sy -L*sind(a) wc*cosd(a) 0.5*L*sind(a) 0.5*L*sind(a)];
   
    nodeP = [];                                         % Plate
    nodeS = [];                                         % soil
    
    for j = 1:length(xp)
        nodeP = [nodeP; sum(xp(1,1:j)) sum(yp(1,1:j))];
    end
    for j = 1:length(xs)
        nodeS = [nodeS; sum(xs(1,1:j)) sum(ys(1,1:j))];
    end
    polygP = [2 length(nodeP(:,1)) nodeP(:,1)' nodeP(:,2)']';
    polygS = [2 length(nodeS(:,1)) nodeS(:,1)' nodeS(:,2)']';
    r = max([length(polygP) length(polygS)]);

    if r == length(polygP)
        polygS = [polygS;zeros(r-length(polygS),1)];
    else
        polygP = [polygP;zeros(r-length(polygP),1)];
    end
    gdm = [polygP polygS];

    g = decsg(gdm);                                         % Decompose constructive solid 2-D geometry into minimal reg
    geometryFromEdges(pdem,g);
    
    F1 = figure(1);
        hold on; 
        pp = pdegplot(pdem);set(pp,'LineWidth',3,'Color',[0 0 0]);       
%         pdegplot(pdem,'VertexLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'EdgeLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'FaceLabels','on','FaceAlpha',1);
        % Add a camera light, and tone down the specular highlighting
        camlight('headlight');
        material('dull');
        axis image off;
        % Create arrow
        annotation(F1,'arrow',[0.519642857142857 0.573214285714286],...
            [0.523809523809524 0.588095238095238],'Color',[1 0 0],'LineWidth',2);
        
        print(F1,'-djpeg','-opengl','-r500','Pulling embedded plate - model');
        
    % Material properties
        structuralProperties(pdem,'Face',1,'YoungsModulus',1000,'PoissonsRatio',0.25,'MassDensity',2.9);% soil
        structuralProperties(pdem,'Face',2,'YoungsModulus',10e6,'PoissonsRatio',0.25,'MassDensity',2.5);% quay wall            
    
    % BC
        structuralBC(pdem,'Edge',[4 8],'XDisplacement',0);
        structuralBC(pdem,'Edge',5,'YDisplacement',0);
    
    % LOADING Conditions
        % CASE 1: Lateral disp of quay wall, point load (disp control)
        structuralBC(pdem,'Vertex',6,'XDisplacement',0.1*sind(a),'YDisplacement',0.1*cosd(a));
        % CASE 2: Lateral disp of quay wall, point load (force control)
%         structuralBoundaryLoad(pdem,'Vertex',6,'Force',[10 10]);% [Fx Fy] kN
        % CASE 3: Vertical surface load is applied on upper part of the soil
        structuralBoundaryLoad(pdem,'Edge',7,'SurfaceTraction',[0;-0.001]);% [Px Py] kN/m
        
    % generate mesh
        mesh_size_max = 0.2;
        mesh_size_min = 0.1;
        generateMesh(pdem,'Hmax',mesh_size_max,'Hmin',mesh_size_min);
        F2 = figure(2);pdemesh(pdem);axis image off;
%             title('Mesh configuration');
%             print(F2,'-djpeg','-opengl','-r500','2D Mesh'); 

    % solve
    R = solve(pdem);
    assignin('base','R',R);

    % display 
    factor = 20;
    Disply(R,pdem,factor,'Pulling embedded plate');
end
%%
function pile_tunnel_2D()
pdem = StructuralModel('PlaneStrain');
gm = importGeometry(pdem,'2Dpilesection.stl');
gm = addFace(gm,5);

    F1 = figure(1);
%         hold on; 
        pp = pdegplot(pdem);set(pp,'LineWidth',3,'Color',[0 0 0]); 
%         pdegplot(pdem,'VertexLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'EdgeLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'FaceLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'FaceAlpha',1);
        % Add a camera light, and tone down the specular highlighting
        camlight('headlight');
        material('dull');
        % Fix the axes scaling, and set a nice view angle
        axis image off;
        % Create arrow
        annotation(F1,'arrow',[0.517857142857143 0.517857142857143],...
            [0.513285714285714 0.633333333333334],'Color',[1 0 0],'LineWidth',2);  
        
        print(F1,'-djpeg','-opengl','-r500','PipelinePileTunnel - model');
       
    % material properties
        structuralProperties(pdem,'Face',1,'YoungsModulus',1000,'PoissonsRatio',0.25,'MassDensity',2.0);% soil
        structuralProperties(pdem,'Face',2,'YoungsModulus',10e6,'PoissonsRatio',0.25,'MassDensity',2.0);% pile or tunnel
        
    % boundary condition    
        structuralBC(pdem,'Edge',[1 4],'XDisplacement',0.0);% soil boundary
        structuralBC(pdem,'Edge',2,'YDisplacement',0.0);% soil boundary
        structuralBC(pdem,'Edge',5,'YDisplacement',0.1);% pile displacement
    % surface traction load:
        structuralBoundaryLoad(pdem,'Edge',3,'SurfaceTraction',[0;-0.0001]);% [Px Py] kN/m
        
    % mesh generation
    mesh_size_max = 0.2;
    mesh_size_min = 0.01;
    generateMesh(pdem,'Hmax',mesh_size_max,'Hmin',mesh_size_min);
    F2 = figure(2);pdemesh(pdem);axis image off;
    title('Mesh configuration');
    
    % solve
    R = solve(pdem);
    assignin('base','R',R);

    % display    
    factor = 20;
    Disply(R,pdem,factor,'PipelinePileTunnel');        
end
%%
function Surface_foundation()
    % Create a PEDE Model
    pdem = StructuralModel('PlaneStrain');

    w = 20;                                             % soil width
    h = 20;                                             % soil depth
    
    L = 5;                                              % foundation length
    wc = 0.5;                                           % foundation thickness (depth)
    a = 0;                                              % angle of bottom of foundation (degree) min 0
    
    if a < 0
        error('Error: Angle of bottom of foundation can not be negative.');
    end
    xs = [0 w 0 -w];
    ys = [0 0 -h 0];
    
    sx = 0;
    sy = 0;
    xp = [sx L 0 -L];
    yp = [sy 0 -wc -L*tand(a)];
   
    nodeP = [];                                         % foundation
    nodeS = [];                                         % soil
    
    for j = 1:length(xp)
        nodeP = [nodeP; sum(xp(1,1:j)) sum(yp(1,1:j))];
    end
    for j = 1:length(xs)
        nodeS = [nodeS; sum(xs(1,1:j)) sum(ys(1,1:j))];
    end
    polygP = [2 length(nodeP(:,1)) nodeP(:,1)' nodeP(:,2)']';
    polygS = [2 length(nodeS(:,1)) nodeS(:,1)' nodeS(:,2)']';
    r = max([length(polygP) length(polygS)]);

    if r == length(polygP)
        polygS = [polygS;zeros(r-length(polygS),1)];
    else
        polygP = [polygP;zeros(r-length(polygP),1)];
    end
    gdm = [polygP polygS];

    g = decsg(gdm); % Decompose constructive solid 2-D geometry into minimal reg
    geometryFromEdges(pdem,g);
    
    F1 = figure(1);
        hold on; 
        pp = pdegplot(pdem);set(pp,'LineWidth',3,'Color',[0 0 0]);       
%         pdegplot(pdem,'VertexLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'EdgeLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'FaceLabels','on','FaceAlpha',1);
        % Add a camera light, and tone down the specular highlighting
        camlight('headlight');
        material('dull');
        axis image off;
        
        % Create arrow
        annotation(F1,'arrow',[0.212499999999999 0.2125],[0.98333333333334 0.90714285714286],'Color',[1 0 0],'LineWidth',2);
        
        print(F1,'-djpeg','-opengl','-r500','Surface foundation - model');
        
    % Material properties
        if wc > 0
            structuralProperties(pdem,'Face',2,'YoungsModulus',1000,'PoissonsRatio',0.25,'MassDensity',1.5);% soil
            structuralProperties(pdem,'Face',1,'YoungsModulus',6e6,'PoissonsRatio',0.25,'MassDensity',2.5);% foundation          
        else
            structuralProperties(pdem,'Face',1,'YoungsModulus',1000,'PoissonsRatio',0.25,'MassDensity',1.5);% soil
            structuralProperties(pdem,'Face',2,'YoungsModulus',40e6,'PoissonsRatio',0.25,'MassDensity',2.5);% foundation             
        end
    % BC
        structuralBC(pdem,'Edge',[3 7 8],'XDisplacement',0);
        structuralBC(pdem,'Edge',4,'YDisplacement',0);
    
    % LOADING Conditions
        % CASE 1: Lateral disp of quay wall, point load (disp control)
%         structuralBC(pdem,'Edge',[1 2 5 8],'YDisplacement',-0.1);% for rigid foudation
%         structuralBC(pdem,'Vertex',5,'YDisplacement',-0.1); % for flrxible foundation
        % CASE 2: Lateral disp of quay wall, point load (force control)
%         structuralBoundaryLoad(pdem,'Vertex',5,'Force',[0 -10]);% [Fx Fy] kN
        structuralBoundaryLoad(pdem,'Edge',5,'SurfaceTraction',[0;-5]);% [Fx Fy] kN/0
        % CASE 3: Vertical surface load is applied on upper part of the soil
%         structuralBoundaryLoad(pdem,'Edge',6,'SurfaceTraction',[0;-0.001]);% [Px Py] kN/m
        
%         structuralBodyLoad(pdem,'GravitationalAcceleration',[0 -9.81].*1e-3);% graviational load - self-weight
    % generate mesh
        mesh_size_max = 0.2;
        mesh_size_min = 0.1;
        generateMesh(pdem,'Hmax',mesh_size_max,'Hmin',mesh_size_min);
        F2 = figure(2);pdemesh(pdem);axis image off;
%             title('Mesh configuration');
%             print(F2,'-djpeg','-opengl','-r500','2D Mesh'); 

    % solve
    R = solve(pdem);
    assignin('base','R',R);

    % display 
    factor = 20;
    Disply(R,pdem,factor,'Surface foundation');
end
%%
function Seepage_retaining_wall()
    % Create a PEDE Model for steady state flow
    pdem = createpde ('thermal','steadystate-axisymmetric');

    w1 = 15;                                            % left side soil width
    w2 = 15;                                            % right side soil width
    H1 = 20;                                            % maximum soil depth
    H2 = 10;                                            % minimum soil depth
    
    L1 = 15;                                            % maximum length of quay wall
    L2 = 5;                                             % minimum length of quay wall 
    wc = 1;                                             % quay wall thickness
    
    xs = [0 w1 0 wc 0 w2 0 -(w1+w2+wc)];
    ys = [0 0 -L1 0 L2 0 -H2 0];
    
    nodeS = [];% soil

    for j = 1:length(xs)
        nodeS = [nodeS; sum(xs(1,1:j)) sum(ys(1,1:j))];
    end
    polygS = [2 length(nodeS(:,1)) nodeS(:,1)' nodeS(:,2)']';


    gdm = [polygS];

    g = decsg(gdm);                                     % Decompose constructive solid 2-D geometry into minimal reg
    geometryFromEdges(pdem,g);
    
    F1 = figure(1);
        hold on; 
        pp = pdegplot(pdem);set(pp,'LineWidth',3,'Color',[0 0 0]); 
%         pdegplot(pdem,'VertexLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'EdgeLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'FaceLabels','on','FaceAlpha',1);
%         pdegplot(pdem,'FaceAlpha',1);
        % Add a camera light, and tone down the specular highlighting
        camlight('headlight');
        material('dull');
        axis image off;
        annotation(F1,'arrow',[0.307142857142854 0.307142857142852],[0.900000000000014 0.859523809523836],'Color',[1 0 0],'LineWidth',2,'HeadStyle','plain');
        annotation(F1,'arrow',[0.778571428571427 0.778571428571425],[0.566666666666676 0.526190476190498],'Color',[1 0 0],'LineWidth',2,'HeadStyle','plain');       
        print(F1,'-djpeg','-opengl','-r500','Seepgage of retaining wall - model');

    % Material properties
        thermalProperties(pdem,'Face',1,'ThermalConductivity',0.01);% soil
        
    % BC  
        thermalBC(pdem,'Edge',[2 3 4 7],'HeatFlux',0);        
        thermalBC(pdem,'Edge',5,'Temperature',10);
        thermalBC(pdem,'Edge',1,'ConvectionCoefficient',1,'AmbientTemperature',100);
        
    % generate mesh
        mesh_size_max = 0.3;
        mesh_size_min = 0.1;
        generateMesh(pdem,'Hmax',mesh_size_max,'Hmin',mesh_size_min);
        F2 = figure(2);pdemesh(pdem);axis image off;
%             title('Mesh configuration');
%             print(F2,'-djpeg','-opengl','-r500','2D Mesh'); 

    % solve
    R = solve(pdem);
    assignin('base','R',R);

    % display 
    factor = 50;
    DisplyThermal(R,pdem,factor,'Seepgage of retaining wall');
end
%%
function pdem = StructuralModel(MOD)
    if MOD == 'PlaneStrain';
        pdem = createpde ('structural','static-planestrain');
    end
    return
end