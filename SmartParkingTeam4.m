clc, clear; 

% pin layout for lcd
RS = 'D12'; 
EN = 'D11'; 
D4 = 'D5'; 
D5 = 'D4'; 
D6 = 'D3'; 
D7 = 'D2'; 

% pin layout for servo
SERVO_PIN = 'D9'; 

% constants 
RED = 1; 
GREEN = 0; 

% pin layout for buttons
BUTTON_ENTER = 'A2'; 
BUTTON_EXIT = 'D6'; 
GATE_OPEN = 1; 
GATE_CLOSE = 0; 

% delay for operations
DELAY = 2;      %LCD time delay
global DELAY_LED 
DELAY_LED = 0.5; 
global MAX_ALLOCATED_SPACE 
MAX_ALLOCATED_SPACE = 13; 
usedSlots = 0; 

% pins for led
RED_LED_EXIT = 'A4'; 
GREEN_LED_EXIT ='A5'; 
RED_LED_ENTER = 'A0'; 
GREEN_LED_ENTER ='A1'; 
disp('initializing arduino'); 

%creating LCD object
a = arduino('/dev/cu.usbmodem1201','Uno','Libraries',{'ExampleLCD/LCDAddon','Servo'},'ForceBuildOn',true); 
disp('initializing servo'); 

%creating Servo Object 
s = servo(a,SERVO_PIN); 
disp('initializing lcd'); 
lcd = addon(a,'ExampleLCD/LCDAddon', 'RegisterSelectPin', RS,'EnablePin',EN,'DataPins',{D4,D5,D6,D7}); 

% setup
clearLCD(lcd); 
% setup
ledConfigure(a, RED_LED_ENTER, GREEN_LED_ENTER); 
ledConfigure(a, RED_LED_EXIT, GREEN_LED_EXIT); 

%displays message in the given row 
writePosition(s, GATE_CLOSE); 
initializeLCD(lcd, 'Rows', 2, 'Columns', 16); 

%brief default display for LCD in rest
printLCD(lcd, 'Smart Parking'); %prepared and prepared by
printLCD(lcd, 'By Team 4'); 
pause(DELAY); 

%shows Student ID and Student Number in Lcd Screen
printLCD(lcd, 'Parthav. S.'); 
printLCD(lcd, '110077515'); 
pause(DELAY); 
printLCD(lcd, 'Astha. T.'); 
printLCD(lcd, '110136258'); 
pause(DELAY);
printLCD(lcd, 'Pooja. K.');
printLCD(lcd, '110129028');
pause(DELAY);
clearLCD(lcd); 
printMessage(lcd, usedSlots); 

% main function containing work flow
while 1 
if readDigitalPin(a, BUTTON_ENTER) %performs all the operation required for car to enter parking
 if usedSlots < MAX_ALLOCATED_SPACE 
 usedSlots = usedSlots + 1; 
 printLCD(lcd, 'Please Enter.'); 
 writePosition(s, GATE_OPEN); 
 ledConfigure(a, GREEN_LED_ENTER, RED_LED_ENTER);
 pause(DELAY);
 writePosition(s, GATE_CLOSE); 
 ledConfigure(a, RED_LED_ENTER, GREEN_LED_ENTER); 
 pause(DELAY);
 else
 printLCD(lcd, 'No Space!'); %display message when parking is full 
 pause(DELAY); 
 end
 pause(DELAY_LED); 
 printMessage(lcd, usedSlots); 
 elseif readDigitalPin(a, BUTTON_EXIT) %performs all the operation required for car to exit parking
 if usedSlots > 0 
 usedSlots = usedSlots - 1; 
 printLCD(lcd, 'Please Exit.'); 
 writePosition(s, GATE_OPEN); 
 ledConfigure(a, GREEN_LED_EXIT, RED_LED_EXIT); 
 pause(DELAY); 
 writePosition(s, GATE_CLOSE); 
 ledConfigure(a, RED_LED_EXIT, GREEN_LED_EXIT); 
 else 
 printLCD(lcd, 'No Car Inside.'); %display message when parking is 
empty
 pause(DELAY); 
 end
 pause(DELAY_LED); 
 printMessage(lcd, usedSlots); 
end
 pause(DELAY_LED); 
end

%function to control the LED when enter or exit button is pressed
function ledConfigure (a, onLed, offLed) 
global DELAY_LED; 
 writeDigitalPin(a, offLed, 0); 
 pause(DELAY_LED); 
 writeDigitalPin(a, onLed, 1); 
end

%function to display message on the LCD when enter or exit button is pressed
function printMessage(lcd, usedSlots) 
global MAX_ALLOCATED_SPACE 
 clearLCD(lcd); 
 printLCD(lcd, strcat('Available: ', num2str(MAX_ALLOCATED_SPACE - usedSlots))); 
 if usedSlots < MAX_ALLOCATED_SPACE 
 printLCD(lcd, 'Welcome!'); 
 else 
 printLCD(lcd, 'We are full!'); 
 end
end
