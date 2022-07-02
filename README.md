# MATLAB_FEM_for_Civil_Mech_Engineers

I share all the codes that I have developed for UG and PG students in the last 4 years. It follows my teaching notes and I'm trying to update them there one by one and gradually. <br>

Abstract: FEM or Finite Element Method is a method for solving complex problems in civil/mechanical/aerospace engineering etc in which a source of energy influences the system and we aim to find the response of the system, for example, finding the settlement of foundation under different loading condition. In FEM, we deal with small or infinitesimal strain and this is the biggest challenge however there are loads of methods which we can employ to eliminate this limitation.<br>
You will learn to solve some of the basic problems in civil engineering (covering structural, geotechnical and earthquake engineering and geology) and mechanical engineering in this repository. I endeavour to update them here and give more examples as I do in courses. <br>

In this repository, you will use FEM by understanding 5 important steps as follows:<br>
<ul>
  <li>Create model and set geometery</li>
  <li>Set boundary conditions</li>
  <li>Set loading consitions</li>
  <li>Solution</li>
  <li>Visualisation and our interpretation of results</li>
</ul>

<h3>Dependencies:</h3><br>
 - MATLAB <br>
 - Partial Differential Equation Toolbox<br>


# Course 6: Geotechnical Engineering Applications 101

<h3>Example 1: Loading on a retaining wall and calculating stress/strain/displacement etc</h3>
We are going to make the following model and aplly the loading and boundary condition, then solve it and visualise the results.<br>

<img width=400 src="/Figures/Retaining wall - model.jpg" type="image/tiff" negative=yes>

To run this example, uncomment the following line of code<br>
```MATLAB
retaining_wall();
```
some of the results are as follow:
Strain xx             |  Strain xy             |  Strain xy
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/mshadlou/MATLAB_FEM_for_Civil_Mech_Engineers/blob/main/Figures/Retaining%20wall%20-%20strain%20xx.jpg)  |  ![](https://github.com/mshadlou/MATLAB_FEM_for_Civil_Mech_Engineers/blob/main/Figures/Retaining%20wall%20-%20strain%20xy.jpg)  |  ![](https://github.com/mshadlou/MATLAB_FEM_for_Civil_Mech_Engineers/blob/main/Figures/Retaining%20wall%20-%20strain%20yy.jpg)

#
<h3>Example 2: Pulling_embedded_plate and calculating stress/strain/displacement etc</h3>
Imagine we are going to simulate the response of an anchore in soil under the pulling chain forces. This example will help us to understand this problem.
We are going to make the following model and aplly the loading and boundary condition, then solve it and visualise the results.<br>

<img width=400 src="/Figures/Pulling embedded plate - model.jpg" type="image/tiff" negative=yes>

To run this example, uncomment the following line of code<br>
```MATLAB
pulling_embedded_plate();
```
some of the results are as follow:
Strain xx             |  Strain xy             |  Strain xy
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/mshadlou/MATLAB_FEM_for_Civil_Mech_Engineers/blob/main/Figures/Pulling%20embedded%20plate%20-%20strain%20xx.jpg)  |  ![](https://github.com/mshadlou/MATLAB_FEM_for_Civil_Mech_Engineers/blob/main/Figures/Pulling%20embedded%20plate%20-%20strain%20xy.jpg)  |  ![](https://github.com/mshadlou/MATLAB_FEM_for_Civil_Mech_Engineers/blob/main/Figures/Pulling%20embedded%20plate%20-%20strain%20yy.jpg)

#
<h3>Example 3: Loading on Surface/embedded Foundation and calculating stress/strain/displacement etc</h3>
Surface/embedded foundations are the foundations we build our structures or superstructures on top. This can be a building foundation or bridge foundation or even spudcan in offshore oil/gas platforms. Try this examples and play with input parameters, such as
```MATLAB
    L = 5;                                              % foundation length
    wc = 0.5;                                           % foundation thickness (depth)
    a = 0;                                              % angle of bottom of foundation (degree) min 0
```
and compare the results.
We are going to make the following model and aplly the loading and boundary condition, then solve it and visualise the results.<br>

<img width=400 src="/Figures/Surface foundation - model.jpg" type="image/tiff" negative=yes>

To run this example, uncomment the following line of code<br>
```MATLAB
pulling_embedded_plate();
```
some of the results are as follow:
Strain xx             |  Strain xy             |  Strain xy
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/mshadlou/MATLAB_FEM_for_Civil_Mech_Engineers/blob/main/Figures/Surface%20foundation%20-%20strain%20xx.jpg)  |  ![](https://github.com/mshadlou/MATLAB_FEM_for_Civil_Mech_Engineers/blob/main/Figures/Surface%20foundation%20-%20strain%20xy.jpg)  |  ![](https://github.com/mshadlou/MATLAB_FEM_for_Civil_Mech_Engineers/blob/main/Figures/Surface%20foundation%20-%20strain%20yy.jpg)




