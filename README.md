# Keystrokes

Records keystrokes and timestamps in a .csv file in the same folder as the file you are typing in.

### Installation and Usage

#### Using Atom Package Manager in the command line

`apm install keystrokes` 

#### In Atom Text Editor

Command Palette (shift-cmd-p) -> Settings View -> Install Packages and Themes -> Keystrokes

#### Recording Keystrokes

Make sure to save the file before starting to record keystrokes in order to ensure the keystrokes will be recorded into the .csv file, which will be titled "keystrokes.csv" -- if there is already a "keystrokes.csv" in the folder directory, it will be appended to the current file. If not, it will create the file automatically.

To start recording, go to Packages -> Keystrokes -> Toggle or use the shortcut, ctrl-alt-o.

### Version History

1.0.1: Added comment detection and feedback

1.0.3: Added point count to bottom right

1.0.4: Added cmd-i (script) detection and feedback

1.0.5: Added more accurate metrics

1.0.6: Added code for print statements
