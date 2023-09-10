# PLR Modeling
<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/overviewPLR.gif" />
</p>

Previous research indicates that the pupillary light reflex (PLR) is effective at assessing central nervous system function. Currently, there is no established solution for quickly determining the level of impairment in a non-invasive manner. This paper proposes the use of the PLR to gauge the level of alcohol intoxication based on changes in pupil constriction dynamics. The approach consisted of combining the Fitzhugh-Nagumo (FN) neuron model with the Kelvin-Voigt muscle model for pupil dynamics. In order to combine the two models, a convolution between dirac delta impulses derived from the membrane voltage-time data outputted by the FN model and a single muscle twitch was computed to generate muscle force which was later passed into the Kelvin-Voigt model. Modelling the neuron activation with the FN model elucidates the impact of alcohol on the central nervous system as well as the accompanying delay in neuron activation. The convolution of the FN action potentials with the muscle twitch dynamics produces force-time functions that appear more representative physiologically than the step function used in the base Kelvin-Voigt model. Our findings suggest that consuming alcohol causes a delay in pupil response as well as a decreased magnitude of sphincter pupillae force output. The validity of this model is confirmed by comparing pupil radius outputs to literature, yielding a delay factor (𝜏) of 35 which performed with a 1.95% error for quarter dilation time.  A positive correlation of latency with 𝜏 was also observed, further verifying the validity of the model. Overall, these results prove the efficacy of this approach and is a promising next step in reducing the frequency of motor vehicle accidents caused by alcohol intoxication.

## Motivation
Drivers under the influence of alcohol cause on average 32 deaths each day in the United States [1]. Roadside driver assessment tools are key in determining whether a driver is intoxicated or otherwise under the influence when stopped by law enforcement. Noninvasive techniques can determine an individual's fitness to operate a motor vehicle without having to draw blood or process the sample in a lab. The breathalyzer is a common example of a roadside assessment device that has been used since the 1960s to determine alcohol intoxication level [15]. Breathalyzers are able to accurately measure blood alcohol content without requiring an invasive sample due to the volatile nature of ethanol [17]. Ethanol is able to passively diffuse from the blood into the alveoli in the lungs where it is then exhaled as vapor in the breath [17]. Outside of alcohol screening, there is a roadside saliva testing that can detect THC, cocaine, and methamphetamine [18]. The test is strictly for detection and does not provide information on drug concentration within the driver’s blood, a key metric for determining driver fitness. Furthermore, the test is only capable of detecting THC, cocaine, and methamphetamine; attempts to create saliva tests for other drugs have proven unsuccessful due to poor reliability [18]. These shortcomings are a key reason why saliva tests are not as commonly used during roadside stops and have even led to saliva tests not being legally binding in certain jurisdictions throughout the US [18]. Due to these issues, there are continued efforts to find a noninvasive roadside screening device that is more accurate in determining the blood concentrations of various drugs. The idea of using pupillometry as a means to gauge driver impairment is not novel, existing studies explored the feasibility of this approach and ultimately conclude that it is viable [19, 20]. Pupillometry may offer benefits over saliva testing, particularly by providing a measurement of function and impairment rather than drug metabolites, overlooking the need to determine drug-blood concentrations through the use of real-time handheld pupillometers [7].

## Goal
Our goal is to develop an accurate method of determining intoxication levels by analyzing the pupillary light reflex (PLR) through modeling the biomechanical response of the musculoskeletal system when exposed to various wavelengths and intensities of light. In doing so, the project will encompass relating the physical responses of the musculoskeletal system with the physiological responses of the autonomic nervous system (ANS). 

## Approach
<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/systemDiagram.png" />
</p>
<p align="center">
Figure 1. Model overview
</p>

Our approach consists of integrating multiple models. A light stimulus is fed into the FN model along with impairment (𝜏). This outputs neuron action potentials over time (V(t)) which are subsequently converted to unit impulses. These Dirac delta functions are convolved with a muscle twitch to produce the profile of normalised muscle force. This profile is then delayed and scaled appropriately and used as the tension developed by the constrictor and dilator muscles in the pupil model (Fp(t) and Fs(t), respectively). The final output of the system is pupil radius over time.

### Neuron
Simulating the effects of impairment on the human PLR required a mathematical model of neural activity. The literature review concluded that the optimal model for this task is the FN model due to its relative simplicity and use in previous literature surrounding the effects of alcohol on neuron dynamics [3]. The FN model is a simplification of the Hodgkin-Huxley (HH) model which is a system of four state-space equations, three that represent the sodium activation, potassium, and sodium inactivation gates open at a given time, and a fourth that represents the rate of change of a neuron's voltage during an action potential [8]. The FN model simplifies the HH model by combining the 3 equations related to ion gate activity into a single equation representing a neuron's ability to regain its resting potential [3, 8]. This reduces the number of equations and variables, while maintaining the essential features of neuronal dynamics related to the generation of action potentials and the refractory period. The two coupled differential equations of the FN model are seen below:

```math
dv/dt = v-v^3/3 -\omega + I   (1)
```

```math
d\omega/dt = \epsilon(v + a - \omega)   (2)
```
\
Where v is the membrane potential,  is the recovery variable, I is the initial stimulus, and a, ,  are parameters whose values are determined from literature [3]. Franca et al. altered these equations to incorporate the effects of alcohol by adding a time delay to  in the x1 state space equation [3]. This alteration results in a longer repolarization, extending the absolute refractory period, and effectively stopping the neuron from firing in fast succession. Following these simplifications, the FN model equations can be transformed into the following form:

```math
dv/dt = v(t)(a-v(t))(v(t)-1) - \omega(t-τ)+ I (3)
```
```math
d\omega/dt =  \epsilon(v(t) - \Upsilon\omega(t)) (4)
```

<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/neuronRepolarization.png" />
</p>
<p align="center">
Figure 2. Comparison of neural activity with and without the addition of a time delay
</p>

There are 21 topologically unique regions in the FN model, however, only three are relevant due to the presence of a limit cycle, a necessary feature for generating action potentials [3]. Parameters a, , and  determine which region the model is in and were obtained from Franca et al. [3]. The phase portraits for these regions were simulated as further validation which can be seen in appendix 12, and upon further work, region two was selected as the optimal limit cycle for this implementation.
The work of Franca et al. was an important resource for validation since their work focuses directly on modelling the impacts of alcohol with the FN model [3]. Values for parameters were obtained directly from this paper with the exception of 𝜏, as the given value for 𝜏 was not reasonable. Appropriately time delaying the state variable was determined through a sweep of 𝜏 values in the results section, however, this is not optimal and should be explored in future work.

### Integration 
When a neuronal action potential reaches a motor unit a muscle twitch occurs [9]. This muscle twitch must be modelled in order to convolve it with the action potential and determine the overall amount of force generated within the muscle when it contracts. Initially, a simplified triangular muscle twitch was developed as a proof of concept since it enabled quick testing of the feasibility of deriving muscle force by convolving the action potentials generated from the FN neuron model with the muscle twitch. The simplified muscle twitch was created by developing linear equations that approximated the latent, contraction and relaxation periods of a muscle twitch and graphing this data for a time span of 0 to 100 milliseconds as suggested by literature [9]. The convolution with the simplified muscle twitches produced a muscle force graph that was similar to literature (yet slightly more jagged) and hence validated the approach [10]. After this, a new iteration of the muscle twitch function was developed based on the Fuglevand et al. model [11]. It is important to note that a limitation of basing the muscle twitch off of the Fuglevand paper is the fact that the Fuglevand model assumes a skeletal muscle contraction whereas the pupillary muscles are smooth muscle.  This simplification had to be made since a specific model of pupillary smooth muscle could not be found in literature. Smooth muscle twitches differ from skeletal muscle twitches and are highly variable [12]. The Fuglevand model uses an exponential function and contraction period in order to generate the muscle twitch graph resulting in the equation PtTe1-(tT) where P is the peak twitch force. T represents the contraction period and t is the corresponding time point in milliseconds. The function was normalized in order to allow for easy convolution with the action potentials and timeshifting was used in order to represent the latent period.  This implementation was also validated against literature [11].
<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/muscleTwitchTextbook.png" width="32%" /> <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/muscleP.png" width="32%"/> <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/singleTwitch.png" width="32%" />
</p>
<p align="center">
  Figure 3. Example of muscle twitch tension output (left) and comparison of Fuglevand muscle twitch (middle) with our implementation where P [Peak Force] = 1 (right) [13, 11].
</p>

The action potentials generated by the FN model are simplified by the conversion to Dirac delta impulses for easier convolution with the muscle twitch. This was accomplished by placing an impulse at the rising edge of every action potential. This simplification is appropriate since the action potential is an all-or-nothing response. Consultation with literature indicates this is an acceptable technique for modelling action potentials providing further validation [14]. Since action potential duration is short, ~1ms, the area underneath the graph is quite small and as such it is relatively negligible when considering its impact on the convolution [15]. Using the Dirac delta functions impulses instead of action potentials still elucidates the impacts of alcohol intoxication since the location of the Dirac delta impulse will still be delayed relative to a non-intoxicated individual which means the effect of alcohol on muscle force is still captured in the convolution.
To achieve an overall muscle response of the pupillary muscles that can be inputted into the physical model of the PLR, convolution of the neuronal action potentials with the aforementioned muscle twitch function was performed. This method has been validated in literature which used convolution to model isometric contractions based on motor unit activation [14]. A simplification was made by time scaling the FN model to achieve a realistic physiological time span for the neuron action potentials. The implementation of the model from Franca et al. is unitless, requiring a conversion factor of 50000 units to achieve a period of about 1 ms per action potential in an undelayed state, which aligns with literature [16]. Convolving the time-scaled neuron function with the muscle twitch function was performed using MATLAB’s conv function at each action potential spike. This yielded the overall muscle response through the temporal summation of the muscle response at each action potential. The resulting graph of muscle activation can be supported by literature in which muscle activation was simulated using the same muscle twitch function [10]. 

<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/literatureTetanus.png" width="48%" /> <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/muscleResponse.png" width="48%" />
</p>
<p align="center">
  Figure 4. Comparison of muscle activation from literature (L, Raikova et al.) with delayed and non-delayed muscle response achieved through convolution (R) [10].
</p>

As can be seen in Figure 4, the simulated muscle response was comparable to muscle responses from literature in overall shape. Additionally, it can be seen that increasing the alcohol factor, 𝜏, results in lower muscle force as well as a slight delay in activation, which aligns with the assumptions made in the implemented FN model. The resulting response was used in the physical model in Fp(t) and Fs(t). This is done by multiplying the normalised muscle force from the convolution with the implemented step functions in the implementation of the physical model. 

### Physical Model
In this work the modelling approach taken for the PLR was based on the model used by Fan & Yao [7]. This involved representing the pupil dilator and constrictor muscles both as a combination of a spring, damper, and contractile element (force-generating component). 
The sphincter contractile element force is denoted by Fp(t) because it is stimulated by the parasympathetic nervous system and the dilator Fs(t) because it is controlled by the sympathetic system. Simplified versions of the equations for the state-space model taken from Fan & Yao’s work are shown: 

```math
x_1 = r        (5)
```
```math
x_2 =dr/dt      (6)
```
```math
dx_1/dt=x_2      (7)
```
```math
dx_2/dt = d^2r/dt^2 = F_{elastic} - F_{damping} + F_p(t)+F_s(t)          (8)
```
Where ‘r’ represents pupil radius, Felastic is the force attributed to the elastic components, Fdamping is the force attributed to the dampers. The geometry and mass of the pupil is also taken into account in the calculations of these force values. Full equations with all parameters can be seen in the appendix.
The input to the model is a 100ms light flash at time 1 second. For this reason, it is not passed to the function but hard-coded into the simulation code that model muscle response. Fp(t) and Fs(t) are the force functions as a result from a 100ms light flash occurring at time = 1 second. Fan & Yao represent this as step functions with fitted amplitude and delays.


<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/delayVisualization.png" width="48%" /> <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/muscleComparison.png" width="48%" />
</p>
<p align="center">
  Figure 5. Fp(t)  and Fs(t) as step functions with fitted delays (𝜏p, 𝜏s)  and amplitudes (Fp, Fs) as in Fan & Yao’s work (Left, top right) and convolved muscle twitch force profile    (bottom right).
</p>

The MATLAB implementation of the physical model uses ODE45 to solve the linear system. This was validated by comparing the output with the results from Fan & Yao at three different light intensities.

<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/pupil_validation.png" />
</p>
<p align="center">
  Figure 6. Literature model results (L) and our MATLAB implementation results (R).
</p>

###Parameter Sweep
To determine the value of 𝜏 to best represent intoxication, a range of values were used to simulate the PLR. The output could then be compared with experimental PLR data. Ideally, raw PLR data would be compared to the output of our model. However, this data was not available so other derived statistics needed to be used. Typical statistics calculated include latency, acceleration, contraction velocity, quarter-dilation velocity, and half-dilation time of the pupil radius [17]. Refer to appendix Table 1 for further elaboration of the different variables. Code was written to effectively calculate these values from the raw pupil radius data. Latency was calculated by the time difference (in seconds) between the light stimulus and the onset of contraction (initial inflection point). The initial inflection point was identified as the first drastic drop of the radius. Appendix Figure 13 shows the pupil radius profile over time, and the acceleration of change of pupil radius over time. The radius graph shows that before the first inflection point, there is a steady drop. This is verified in the acceleration graph as acceleration is close to zero, until it hits the specific time value where the first drop occurs. With this knowledge, signal processing was conducted, and the inflection point was calculated. With the calculated points, the latency value was found. 
Acceleration was calculated as the time to reach max acceleration during contraction; the units are therefore seconds rather than mm/s2. Contraction velocity describes the mean velocity (mm/s) during contraction. This was calculated by the rate of change from the minimum radius point, and the initial inflection point with its respective time values. Quarter dilation velocity is the velocity of the pupil dilation reaching its quarter dilation point from the minimum radius. Lastly, the half-dilation time was calculated as the time it took to reach its half-dilation point. The visual aid of each variable can be shown in Figure 7.

<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/evaluation_metrics.png" />
</p>
<p align="center">
  Figure 7. Radius profile with its respective variables calculated and plotted
</p>

Appendix Figure 14 shows the radius profile with its calculated variables from literature [17]. When comparing Figure 7 to Appendix Figure 14, in most situations, the calculated points show similarity. After validating that the steps taken led to similar results, the simulation was run for 𝜏 ranging from 0-50. The 𝜏 value of 0.001 was the ‘baseline’ to represent zero intoxication because the DDE23 requires a non-zero delay. Statistical analysis was then conducted with the calculated metrics for each respective 𝜏 value.

### Statistical Analysis
A two-step empirical approach for validation was performed. Statistics derived from time-series radius data were used to determine accuracy of the model compared to literature data  from Kaifie et al’s work on assessing the PLR as a marker for the ability to drive, shown in the appendix Table 2 [17]. The metrics verified included contraction velocity, half-dilation time, quarter-dilation velocity, and time to maximum acceleration. Latency was not used because the data from Kaifie et al suggests alcohol was acting as a stimulant (lower latency with alcohol consumption), whereas we modelled the BAC region where it acts as a depressant. Initially, actual values derived from the simulation were compared with the hope of matching 𝜏 to literature values. However, differences in our model assumptions and the experimental procedure led to this not being a feasible option. The second approach taken sought to fit 𝜏 based on percent difference in parameters from baseline (𝜏 = 0) and with intoxication (𝜏 > 0). This approach took into account the starting conditions of each model rather than mapping the generated model values to those of literature directly. Error in the percent difference was then calculated from data with literature data as the ground truth [17]. 

## Results
Sample radius-time data from our PLR model can be seen in Figure 8.

<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/Final_Model_demo.png" />
</p>
<p align="center">
  Figure 8. PLR of Fan & Yao model plotted along with our model using a range of 𝜏. 
</p>

## Conclusion
A partially successful model of the effect of alcohol on the PLR was created. Combining the FN model with the Fan & Yao model elegantly captures the effect of alcohol on the nervous system and subsequently, the impact on the pupillary muscles. Convolution of the muscle twitch with Dirac delta impulses that represent action potentials proved to be reasonable. Validation was limited by the availability of raw PLR data.

## References

[1] “Impaired driving: Get the facts,” Centers for Disease Control and Prevention, 28-Dec-2022. [Online]. Available: https://www.cdc.gov/transportationsafety/impaired_driving/impaired-drv_factsheet.html. [Accessed: 05-Feb-2023]. 

[2] California State Polytechnic University, Pomona and Loyola Marymount ... (n.d.). Retrieved March 10, 2023, from https://www.public.asu.edu/~etcamach/AMSSI/reports/neuron.pdf 

[3] R. S. Franca, I. E. Prendergast, E.-S. Sanchez, M. A. Sanchez, and F. Berezovsky, “The Role of Time Delay in the Fitzhugh-Nagumo Equations: The Impact of Alcohol on Neuron Firing,” Cornell University, Dept. of Biometrics Technical Report BU-1577-M, Aug. 2001.

[4] Stanford Medicine 25, “Pupillary responses,” Stanford Medicine 25. [Online]. Available: https://stanfordmedicine25.stanford.edu/the25/pupillary.html. [Accessed: 03-Feb-2023].

[5] J. V. Forrester, A. D. Dick, P. G. McMenamin, F. Roberts, and E. Pearlman, “Chapter 1: Anatomy of the eye and orbit,” in The eye: Basic sciences in practice, Amsterdam: Elsevier, 2021, pp. 1–102.

[6] C. Hall and R. Chilcott, “Eyeing up the future of the pupillary light reflex in neurodiagnostics,” Diagnostics, vol. 8, no. 1, p. 19, 2018.

[7] Xiaofei Fan and Gang Yao, “Modeling transient pupillary light reflex induced by a short light flash,” IEEE Transactions on Biomedical Engineering, vol. 58, no. 1, pp. 36–42, 2011.

[8] P. Wallisch, M. E. Lusignan, M. D. Benayoun, T. I. Baker, A. S. Dickey, and N. G. Hatsopoulos, Matlab for neuroscientists: An introduction to scientific computing in Matlab, Second. Amsterdam: Elsevier, 2014.

[9] J. Byrne, “Skeletal muscle: Whole muscle physiology,” Motor Units and Muscle Twitches. [Online]. Available: https://content.byui.edu/file/a236934c-3c60-4fe9-90aa-d343b3e3a640/1/module7/readings/muscle_twitches.html. [Accessed: 10-Apr-2023]. 

[10] R. Raikova, H. Aladjov, J. Celichowski, and P. Krutki, “An approach for simulation of the muscle force modeling it by summation of motor unit contraction forces,” Computational and Mathematical Methods in Medicine, vol. 2013, pp. 1–10, 2013. ​

[11] A. J. Fuglevand, D. A. Winter, and A. E. Patla, “Models of recruitment and rate coding organization in motor-unit pools,” Journal of Neurophysiology, vol. 70, no. 6, pp. 2470–2488, 1993. ​

[12] B. Hafen and B. Burns, “Physiology, Smooth Muscle,” National Center for Biotechnology Information. [Online]. Available: https://pubmed.ncbi.nlm.nih.gov/30252381/. [Accessed: 10-Apr-2023]

[13] “Skeletal muscle: Whole muscle physiology,” Motor Units and Muscle Twitches. [Online]. Available: https://content.byui.edu/file/a236934c-3c60-4fe9-90aa-d343b3e3a640/1/module7/readings/muscle_twitches.html. [Accessed: 15-Apr-2023].

[14] C. J. De Luca, “A model for a motor unit train recorded during constant force isometric contractions,” Biological Cybernetics, vol. 19, no. 3, pp. 159–167, 1975. 

[15] J. Byrne, “Chapter 1: Resting Potentials and Action Potentials,” Department of Neurobiology and Anatomy, McGovern Medical School. [Online]. Available: https://nba.uth.tmc.edu/neuroscience/m/s1/chapter01.html. [Accessed: 10-Apr-2023]. 

[16] “Action potentials,” Image for Cardiovascular Physiology Concepts, Richard E Klabunde PhD. [Online]. Available: https://www.cvphysiology.com/Arrhythmias/A010. [Accessed: 15-Apr-2023].

[17] A. Kaifie, M. Reugels, T. Kraus, and M. Kursawe, “The pupillary light reflex (PLR) as a marker for the ability to work or drive – a feasibility study,” Journal of Occupational Medicine and Toxicology, vol. 16, no. 1, 2021​

[18] M. Gronbaek, “The positive and negative health effects of alcohol- and the Public Health Implications,” Journal of Internal Medicine, vol. 265, no. 4, pp. 407–420, 2009.

[19] R. Lozi, M.-S. Abdelouahab, and G. Chen, “Mixed-mode oscillations based on complex canard explosion in a fractional-order Fitzhugh-Nagumo model.,” Applied Mathematics and Nonlinear Sciences, vol. 5, no. 2, pp. 239–256, 2020. 

## Contributors 
Kyle Scenna     | kscenna@uwaterloo.ca	       |  [LinkedIn](https://www.linkedin.com/in/kyle-scenna-2776b3202/?originalSubdomain=ca)
\
Victor Crisan   | vcrisan@uwaterloo.ca         | [LinkedIn](https://www.linkedin.com/in/victor-crisan-013347218/)
\
Sean Rose       | s25rose@uwaterloo.ca         | [LinkedIn](https://www.linkedin.com/in/rose-sean/)
\
Michael Frew    | michael.frew@uwaterloo.ca    | [LinkedIn](https://www.linkedin.com/in/michael-frew/)
\
Joseph Mitchell | joseph.mitchell@uwaterloo.ca |  [LinkedIn](https://www.linkedin.com/in/josephmitchell48/)
\
Jaeyoung Kang   | j97kang@uwaterloo.ca	       |  [LinkedIn](https://www.linkedin.com/in/jaeyoungkang0815/)
\
<br />
Special thank you to [Dr. Richard Nuckols](https://uwaterloo.ca/systems-design-engineering/contacts/richard-nuckols) for his mentorship throughout the duration of this project.
