1. Project Overview
This project involves designing a VHDL-based LED pattern controller for the DE10-Nano, The goal was to create a system that displays different LED patterns based on the user input provided via switches. it also implements a finite state machine (FSM) to control the transitions between various LED patterns.

(a) Functional Requirements
Switch Input: The DE10-Nano board has two input switches (SW[1:0]) that determine the LED patterns.
LED Output: Eight on-board LEDs (LED[7:0]) display various patterns as specified by the switch inputs.
Pattern Control: The system cycles through four distinct LED patterns, each selected via the switch combination.
Pattern 1 (SW = "00"): Alternating LEDs (e.g., 10101010).
Pattern 2 (SW = "01"): Blocks of two (11001100).
Pattern 3 (SW = "10"): Upper half on (11110000).
Pattern 4 (SW = "11"): Counter-based dynamic pattern.
Reset: The system includes a reset signal that clears the LED output and resets the pattern state.
2. System Architecture
The system is structured in a hierarchical VHDL design, with two primary modules:

Top-level module (de10nano_top.vhd): Integrates the clock, reset, switch inputs, and LED outputs.
LED Pattern Controller (led_patterns.vhd): Implements the FSM to manage the LED pattern changes based on switch inputs.
Block Diagram Overview:
The top-level module interfaces with the onboard clock (CLOCK_50), the two switches (SW), and the eight LEDs (LED). It instantiates the led_patterns module, which handles the pattern logic.
The led_patterns module manages the core functionality, receiving the clock and switch inputs, and generating the corresponding LED outputs through state transitions.
3. Implementation Details
(a) User LED Pattern
The LED pattern system uses a state machine to transition between different patterns based on the switch input. The states are defined as:

IDLE: The system is in this state when no valid switch combination is detected, keeping all LEDs off.
PATTERN1: Selected when SW = "00", the pattern alternates the LEDs in a 10101010 configuration.
PATTERN2: Selected when SW = "01", the pattern lights up blocks of two LEDs, 11001100.
PATTERN3: Selected when SW = "10", the upper half of the LEDs are turned on, 11110000.
PATTERN4: Selected when SW = "11", the LEDs follow a dynamic pattern controlled by a counter that increments with each clock cycle.
VHDL Code Logic:

Pattern Selection: A case statement inside the FSM selects the appropriate pattern based on the switch input.
Counter-based Pattern: For PATTERN4, the most significant byte of a 32-bit counter is displayed on the LEDs, creating a dynamic effect that shifts over time.
Clock and Reset Handling: The clock input is used to synchronize the pattern transitions, and the reset signal is used to clear the system state, ensuring all LEDs are off on reset.
Design Considerations:
Inferred Latches: Ensuring that all signals were properly assigned in every clock cycle avoided latch inference.
Constant Drivers: Signal conflicts were resolved by managing signal assignments within the state machine and ensuring that multiple drivers were not assigning to the same signal simultaneously.