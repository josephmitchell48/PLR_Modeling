# PLR_Modeling
## Motivation
Drivers under the influence of alcohol cause on average 32 deaths each day in the United States [1]. Roadside driver assessment tools are key in determining whether a driver is intoxicated or otherwise under the influence when stopped by law enforcement. Noninvasive techniques can determine an individual's fitness to operate a motor vehicle without having to draw blood or process the sample in a lab. The breathalyzer is a common example of a roadside assessment device that has been used since the 1960s to determine alcohol intoxication level [15]. Breathalyzers are able to accurately measure blood alcohol content without requiring an invasive sample due to the volatile nature of ethanol [17]. Ethanol is able to passively diffuse from the blood into the alveoli in the lungs where it is then exhaled as vapor in the breath [17]. Outside of alcohol screening, there is a roadside saliva testing that can detect THC, cocaine, and methamphetamine [18]. The test is strictly for detection and does not provide information on drug concentration within the driver’s blood, a key metric for determining driver fitness. Furthermore, the test is only capable of detecting THC, cocaine, and methamphetamine; attempts to create saliva tests for other drugs have proven unsuccessful due to poor reliability [18]. These shortcomings are a key reason why saliva tests are not as commonly used during roadside stops and have even led to saliva tests not being legally binding in certain jurisdictions throughout the US [18]. Due to these issues, there are continued efforts to find a noninvasive roadside screening device that is more accurate in determining the blood concentrations of various drugs. The idea of using pupillometry as a means to gauge driver impairment is not novel, existing studies explored the feasibility of this approach and ultimately conclude that it is viable [19, 20]. Pupillometry may offer benefits over saliva testing, particularly by providing a measurement of function and impairment rather than drug metabolites, overlooking the need to determine drug-blood concentrations through the use of real-time handheld pupillometers [7].

## Goal
Our goal is to develop an accurate method of determining intoxication levels by analyzing the pupillary light reflex (PLR) through modeling the biomechanical response of the musculoskeletal system when exposed to various wavelengths and intensities of light. In doing so, the project will encompass relating the physical responses of the musculoskeletal system with the physiological responses of the autonomic nervous system (ANS). 

## Approach
At a high level, our approach consists of two components, the physical pupil and the neural stimulation pathway. The effect of alcohol is modelled within the Fitzhugh-Nagumo neuron model, and contributes to a time delay to the recovery variable within the model. The output of the neuron muscle then determines activation of the smooth muscle Kelvin-Voight model. This will then produce the final output of the model, which is the diameter of the pupil as a function of time and alcohol concentration. A more in depth explanation of each of the two stages of modelling will be described below, complete with equation and parameter explanations.

![alt text](https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/approach.svg)
![alt text](https://github.com/josephmitchell48/PLR_Modeling/blob/main/media/approach_legend.svg)



