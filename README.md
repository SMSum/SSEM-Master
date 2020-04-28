# Summers Simulated Engine Mod

SSEM is a current WIP Simulated Engine Add-on for Garrys Mod Sandbox, currently being used on MBS. 

## Usage

The engines are modified by using the following client convars (console commands) and are read at creation and update

SSEM_Engine_Bore - The Bore of the engine   
Ex: 81


SSEM_Engine_Stroke - The Stroke of the engine     
Ex: 77

SSEM_Engine_Cylinders - The number of cylinders of the engine   
Ex: 4

SSEM_Engine_Airflow - Number used to tweak final displacement and power to better match the engine of reference   
Ex: 90

SSEM_Engine_Idle - The idle RPM of the engine  
Ex: 850

SSEM_Engine_Redline - The redline RPM of the engine   
Ex: 7600

SSEM_Engine_FlywheelMass - The mass of the flywheel (KG)  
Ex: 8

SSEM_Engine_Gearbox_FinalDrive - The Final Drive of the transmission  
Ex: -4.300

SSEM_Engine_Gearbox_Ratios - The Transmission ratios, number of gears is infinite, final ratio is reverse    
Ex: 0.861,1.000,1.384,2.022,3.587,-0.85   
(DO NOT PUT SPACES, USE COMMAS TO SEPERATE EVERYTHING)


To adjust an engine, modify a value in the console and either respawn or right click on the engine with the SSEM Menu tool equipped.

Linking is straight forward, WHEELS is wired to an entity marker containing all the wheels. Make sure the engine is parallel to the wheels and weleded to the chassis. If the car is going backwards, either turn around the engine physically or flip the final drive positive or negative.


## Contributing
Closed currently

## License
[GPL v3.0](https://choosealicense.com/licenses/gpl-3.0/)
