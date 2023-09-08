# PLR_Modeling
## Abstract
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
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/approach.svg" />
</p>
<p align="center">
Figure 2. Comparison of neural activity with and without the addition of a time delay
</p>

There are 21 topologically unique regions in the FN model, however, only three are relevant due to the presence of a limit cycle, a necessary feature for generating action potentials [3]. Parameters a, , and  determine which region the model is in and were obtained from Franca et al. [3]. The phase portraits for these regions were simulated as further validation which can be seen in appendix 12, and upon further work, region two was selected as the optimal limit cycle for this implementation.
The work of Franca et al. was an important resource for validation since their work focuses directly on modelling the impacts of alcohol with the FN model [3]. Values for parameters were obtained directly from this paper with the exception of 𝜏, as the given value for 𝜏 was not reasonable. Appropriately time delaying the state variable was determined through a sweep of 𝜏 values in the results section, however, this is not optimal and should be explored in future work.

### Integration 
When a neuronal action potential reaches a motor unit a muscle twitch occurs [9]. This muscle twitch must be modelled in order to convolve it with the action potential and determine the overall amount of force generated within the muscle when it contracts. Initially, a simplified triangular muscle twitch was developed as a proof of concept since it enabled quick testing of the feasibility of deriving muscle force by convolving the action potentials generated from the FN neuron model with the muscle twitch. The simplified muscle twitch was created by developing linear equations that approximated the latent, contraction and relaxation periods of a muscle twitch and graphing this data for a time span of 0 to 100 milliseconds as suggested by literature [9]. The convolution with the simplified muscle twitches produced a muscle force graph that was similar to literature (yet slightly more jagged) and hence validated the approach [10]. After this, a new iteration of the muscle twitch function was developed based on the Fuglevand et al. model [11]. It is important to note that a limitation of basing the muscle twitch off of the Fuglevand paper is the fact that the Fuglevand model assumes a skeletal muscle contraction whereas the pupillary muscles are smooth muscle.  This simplification had to be made since a specific model of pupillary smooth muscle could not be found in literature. Smooth muscle twitches differ from skeletal muscle twitches and are highly variable [12]. The Fuglevand model uses an exponential function and contraction period in order to generate the muscle twitch graph resulting in the equation PtTe1-(tT) where P is the peak twitch force. T represents the contraction period and t is the corresponding time point in milliseconds. The function was normalized in order to allow for easy convolution with the action potentials and timeshifting was used in order to represent the latent period.  This implementation was also validated against literature [11].
<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/approach.svg" />
</p>
<p align="center">
  Figure 3. Example of muscle twitch tension output (left) and comparison of Fuglevand muscle twitch (middle) with our implementation where P [Peak Force] = 1 (right) [13, 11].
</p>

The action potentials generated by the FN model are simplified by the conversion to Dirac delta impulses for easier convolution with the muscle twitch. This was accomplished by placing an impulse at the rising edge of every action potential. This simplification is appropriate since the action potential is an all-or-nothing response. Consultation with literature indicates this is an acceptable technique for modelling action potentials providing further validation [14]. Since action potential duration is short, ~1ms, the area underneath the graph is quite small and as such it is relatively negligible when considering its impact on the convolution [15]. Using the Dirac delta functions impulses instead of action potentials still elucidates the impacts of alcohol intoxication since the location of the Dirac delta impulse will still be delayed relative to a non-intoxicated individual which means the effect of alcohol on muscle force is still captured in the convolution.
To achieve an overall muscle response of the pupillary muscles that can be inputted into the physical model of the PLR, convolution of the neuronal action potentials with the aforementioned muscle twitch function was performed. This method has been validated in literature which used convolution to model isometric contractions based on motor unit activation [14]. A simplification was made by time scaling the FN model to achieve a realistic physiological time span for the neuron action potentials. The implementation of the model from Franca et al. is unitless, requiring a conversion factor of 50000 units to achieve a period of about 1 ms per action potential in an undelayed state, which aligns with literature [16]. Convolving the time-scaled neuron function with the muscle twitch function was performed using MATLAB’s conv function at each action potential spike. This yielded the overall muscle response through the temporal summation of the muscle response at each action potential. The resulting graph of muscle activation can be supported by literature in which muscle activation was simulated using the same muscle twitch function [10]. 

<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/approach.svg" />
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
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/approach.svg" />
</p>
<p align="center">
  Figure 5. Fp(t)  and Fs(t) as step functions with fitted delays (𝜏p, 𝜏s)  and amplitudes (Fp, Fs) as in Fan & Yao’s work (Left, top right) and convolved muscle twitch force profile    (bottom right).
</p>

The MATLAB implementation of the physical model uses ODE45 to solve the linear system. This was validated by comparing the output with the results from Fan & Yao at three different light intensities.

<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/approach.svg" />
</p>
<p align="center">
  Figure 6. Literature model results (L) and our MATLAB implementation results (R).
</p>

###Parameter Sweep
To determine the value of 𝜏 to best represent intoxication, a range of values were used to simulate the PLR. The output could then be compared with experimental PLR data. Ideally, raw PLR data would be compared to the output of our model. However, this data was not available so other derived statistics needed to be used. Typical statistics calculated include latency, acceleration, contraction velocity, quarter-dilation velocity, and half-dilation time of the pupil radius [17]. Refer to appendix Table 1 for further elaboration of the different variables. Code was written to effectively calculate these values from the raw pupil radius data. Latency was calculated by the time difference (in seconds) between the light stimulus and the onset of contraction (initial inflection point). The initial inflection point was identified as the first drastic drop of the radius. Appendix Figure 13 shows the pupil radius profile over time, and the acceleration of change of pupil radius over time. The radius graph shows that before the first inflection point, there is a steady drop. This is verified in the acceleration graph as acceleration is close to zero, until it hits the specific time value where the first drop occurs. With this knowledge, signal processing was conducted, and the inflection point was calculated. With the calculated points, the latency value was found. 
Acceleration was calculated as the time to reach max acceleration during contraction; the units are therefore seconds rather than mm/s2. Contraction velocity describes the mean velocity (mm/s) during contraction. This was calculated by the rate of change from the minimum radius point, and the initial inflection point with its respective time values. Quarter dilation velocity is the velocity of the pupil dilation reaching its quarter dilation point from the minimum radius. Lastly, the half-dilation time was calculated as the time it took to reach its half-dilation point. The visual aid of each variable can be shown in Figure 7.

<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/approach.svg" />
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
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/approach.svg" />
</p>
<p align="center">
  Figure 8. PLR of Fan & Yao model plotted along with our model using a range of 𝜏. 
</p>

Figure 9 shows error in the metrics quarter dilation velocity and contraction velocity would not be fittable using this approach since there was a difference in data obtained such that fitting an offset value would give an unreliable value for 𝜏.

<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/approach.svg" />
</p>
<p align="center">
  Figure 9. Validation Step 1: Percentage error of derived metrics between simulation and intoxicated experimental data.
</p>

As shown in Figure 10, half dilation time presents a direct, positive correlation between 𝜏 and the accuracy represented through percent error. A line of best fit yielded the ideal value of 𝜏 to equal 34.94. Although 𝜏 = 42 produced the most accurate result in terms of data models, the error with respect to the linear relationship is large and it was thus treated as an outlier. This confirms that 𝜏 = 35 produces the most accurate value that would best model the data obtained from Kaifie et al [17]. 

<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/approach.svg" />
</p>
<p align="center">
  Figure 10. Validation Step 2: Error between percent difference of half-dilation time of simulation with varying 𝜏 compared to percent difference of literature data (baseline and       intoxicated).
</p>

The results obtained for the contraction velocity and dilation velocity from the literature data both exhibited positive correlations between percent error and 𝜏, as shown in Figure 11. However, unlike the half dilation time, no intercepts were recorded for 𝜏 values greater than 0, suggesting the use of these parameters for this model involving 𝜏 is not appropriate for this validation method. This is further reinforced by the massive percent errors shown in the thousands for large 𝜏 values (greater than 10). Contrarily, the time to maximum acceleration parameter produced some results with small percent errors. However, an oscillatory trend was observed in the percent errors between these models, with absolute maximum errors also reaching over 1000%. This confirmed that the time to maximum acceleration parameter was stochastic, as it was not reliable for determining the best value of 𝜏. Thus, the half-dilation time presented the best parameter to use for validation purposes. 

<p align="center">
  <img src="https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/approach.svg" />
</p>
<p align="center">
  Figure 11. Validation Step 2: Error between percent differences of contraction velocity, quarter dilation velocity, and time to maximum acceleration
</p>

## Discussion
Overall, the radius-time data outputted from the PLR simulation shows a delay and decrease in pupil constriction as 𝜏 increased. Contraction velocity also decreased, leading to a larger minimum radius as the value of 𝜏 increased, but the initial inflection point stays the same; this results in a gradual slope compared to the steeper slope when 𝜏 is smaller. 
As 𝜏 increased, the percent error of latency, contraction velocity, quarter dilation velocity, and half dilation time increased. This shows that the model exhibited delay from alcohol consumption as intended. Finding a value of 𝜏 that accurately represents intoxication for every parameter was less successful, however, since the model relies on finding an accurate value for 𝜏 unique to each level of intoxication. 
The value of 𝜏 from statistical validation that minimises the error of half dilation time was found to be 35 from analysing Figure 10. It should be noted that our model produced a half dilation time ranging from 0.39-0.54s and the literature data value average was 0.427s. This validates the range of delays that our model is able to produce. 
When comparing the percent error of the calculated values to the literature values, there are also other similarities. For latency, our calculated values ranged from 0.201s to 0.203s. In contrast, the literature values went from 0.226s to 0.225s (baseline to intoxicated). This is a -0.71% change from the baseline to the drunk state whereas our model resulted in a 0.995% change. This can be explained by the alcohol level being low in Kaifie et al.’s data, resulting in it acting as a stimulant rather than a depressant.
The time to maximum acceleration exhibited sigogglin values, as shown in Figure 11. An explanation of this is that alcohol delays the muscle overall, but not in a linear manner. The difference could also be related to the variable timesteps of the ODE45 solver. While it shows an overall delay, there are differences in acceleration throughout the pupil radius contraction period. With varying acceleration points throughout, a pattern can not be discerned as the point of maximum acceleration would vary for every 𝜏 value.
The results relate to the clinical problem since the trends determined from the change in pupil radius can theoretically be used to deduce whether or not an individual is intoxicated. This research could hypothetically be extended to fabricate a device that is an alternative to a breathalyser. The device could shine a light pulse into an individual's eye and determine the change in pupil radius over time which can be combined with statistical analysis to determine if an individual is intoxicated based on their pupil radius. This could provide an accurate alternative to a breathalyser that would be useful as a gauge for testing if a driver is impaired. Additionally, the device could be used preventatively to reduce the likelihood of the overconsumption of alcohol, which can lead to a variety of complications such as liver disease, cardiovascular issues, and neurological problems [18]. The device could be used in locations where alcohol is served to provide a quantifiable method of determining whether or not a patron should be refused service, thus reducing the risk of overconsumption. The widespread use of such a device has the potential of reducing the irresponsible consumption of alcohol which leads to a variety of adverse effects. 
### Limitations
There are a variety of limitations that affect the strength of our results. As previously mentioned, the muscle twitch used is based skeletal muscle as opposed to smooth pupillary muscle. This limits the physiological accuracy of the functions Fp(t) and Fs(t). Further, since the parameters in Fan & Yao’s model are fitted to a specific experimental procedure, it is difficult to make small changes to the model without time-series data to refit parameters. 
Another limitation lies in the dataset of derived metrics used to validate our model.  Kaifie et al used multiple 17ms light flashes, whereas we modelled a single 100ms flash [17]. Another important point is that the study tested on low blood alcohol content. When blood alcohol content is low it can act as a stimulant whereas our approach only accounts for the depressing effect which occurs at higher BAC levels. Another limitation of this model is the simplification of modelling the neuronal component using a single neuron for the FN model. In actuality, multiple neurons control a muscle and there is a summation step that is not represented in this new model. Furthermore, these neurons may not all have the same delay rate; some neurons could be delayed more than others which will ultimately alter the results. In addition, another assumption that is made is constant stimulation means that the neuron consistently fires every millisecond. If this interval was slower then the convolution would output decreased magnitudes of sympathetic and parasympathetic forces resulting in a greater minimum pupil radius value.  
### Recommendations
Suggested improvements include revisiting various assumptions and simplifications made. Currently, it is assumed that each neuron has the same delay rate but research of how the delay will affect various neurons should be taken to verify this. Also, an equation that represents smooth pupillary muscle would also contribute to a higher accuracy compared to the current skeletal muscle. In addition, the current setup for the FN model does not incorporate multiple neurons. Finding a method of summation and representing this as the final model before the convolution step would show a finer representation of the reflex arc in the PLR. Investigating other parameters such as body temperature after consuming alcohol, or how drugs interact with alcohol would contribute to increasing the validity of the model. Additionally, incorporating variables such as changes in neurotransmitter release and receptor activity will give a finer understanding of the relationship between alcohol and delay as looking at the overall neuron pathway can potentially show a direct correlation between the two variables. As previously stated, the FN model had 3 levels of specificity: activity of a single neuron, the propagation of an action potential across a line of neurons, and the propagation of an action potential through an m x n array of neurons [3]. The m x n array is most likely to produce the most accurate result. Lastly, using alternative modelling techniques, such as machine learning and neural network models, could improve the accuracy as they are widely used for classification (can be used as a binary classification), but also regression (can be used to find a percentage of drunkenness based on parameters). 
The issues with the validation procedure based on the parameter results could be related to the use of ODE solvers in MATLAB, in addition to the step size chosen. Thus, further exploration for this procedure should be taken when comparing the model to other literature data sets to empirically optimise the value of 𝜏.
## Conclusion
A partially successful model of the effect of alcohol on the PLR was created. Combining the FN model with the Fan & Yao model elegantly captures the effect of alcohol on the nervous system and subsequently, the impact on the pupillary muscles. Convolution of the muscle twitch with Dirac delta impulses that represent action potentials proved to be reasonable. The model was validated using literature values obtained from Kaifie et al. that determined 𝜏=35 best fit the half-dilation time. Unfortunately, other derived metrics did not support this possibly because of the differences in simulation assumptions and experimental data collection procedure [17]. Other datasets will require additional empirical validation to optimise the value of 𝜏 that best represents the specifics of any simulation. Further research is needed to improve our model’s robustness.

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
Victor Crisan   | vcrisan@uwaterloo.ca         | [LinkedIn](https://www.linkedin.com/in/victor-crisan-013347218/)
Sean Rose       | s25rose@uwaterloo.ca         | [LinkedIn](https://www.linkedin.com/in/rose-sean/)
Michael Frew    | michael.frew@uwaterloo.ca    | [LinkedIn](https://www.linkedin.com/in/michael-frew/)
Joseph Mitchell | joseph.mitchell@uwaterloo.ca |  [LinkedIn](https://www.linkedin.com/in/josephmitchell48/)
Jaeyoung Kang   | j97kang@uwaterloo.ca	       |  [LinkedIn](https://www.linkedin.com/in/jaeyoungkang0815/)
