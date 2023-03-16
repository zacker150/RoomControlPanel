
Functional Requrements
P0: 
 * Add slider to control ceiling lights
     * Change brightness off to full brightness
     * All the way to the left - off 
     * All the way to the right - full brightness
 * Update desk lamp integration to use HA API
    
P1:

 * Update the slider value when light is changed from other source.

Technical Requirements: 

 * Low latency (<100 ms)

Approach: 
* Have the control panel communicate with HA server through HA API
  * CP -> HA -> Lights
* Use timer interupt to update the status.

