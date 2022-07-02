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

<img width=400 height=400 src="/Figures/Retaining wall - model.jpg" type="image/tiff" negative=yes>

To run this example, uncomment the following line of code<br>
```MATLAB
retaining_wall();
```
some of the results are as follow:
Solarized dark             |  Solarized Ocean
:-------------------------:|:-------------------------:
![](Figures/Retaining wall - strain xx.jpg)  |  ![](Figures/Retaining wall - strain xy.jpg)
<div class="row">
  <div class="column">
    <img src="/Figures/Retaining wall - strain xx.jpg" alt="strain xx" style="width:30%">
  </div>
  <div class="column">
    <img src="/Figures/Retaining wall - strain xy.jpg" alt="strain xy" style="width:30%">
  </div>
  <div class="column">
    <img src="/Figures/Retaining wall - strain yy.jpg" alt="strain yy" style="width:30%">
  </div>
</div>


