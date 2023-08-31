## Overview
This repository contains the code required for EMG analysis and muscle synergy analysis

## How to analyze

- **preliminary preparations** <br>

    1. Please place all recorded data file directly under the monkey name folder.<br>
    (ex.) data -> Yachimun -> here!!<br>
    Please refer to the attached csv file for the dates to be analysed(exists at the top level of this repository)<br>

        **location of data:**
        - **As for Yachimun**<br>
        nasmodel-data/files/data/TendonTransfer/Yachimun/EMG/here!!

        - **As for SesekiL**<br>
        Comming soon...
    2. Please add 'code' and 'data' folder to PATH in MATLAB


- **EMG_analysis**

  1. **Run 'SaveFileinfo.m'**
    - **location**: data -> monkeyname -> here!!
    - **function**: save data for merging measurement data.

  2. **Run 'runnningEasyfunc.m'**
    - **location**: data -> here!!
    - **function**: 3 function
      1. merge data & generate timing_data
      2. evaluate cross-talk
      3. filtering & Time Normalization of Tasks

  3. **Run 'plotTarget.m'**
    - **location**: data -> here!!
    - **function**: Plot EMG data


- **Synergy_analysis**
  1. **Run 'SaveFileinfo.m'**


## Remarks
  The following information is written at the beginning of every code. Please refer to them and proceed with the analysis.
  - **Your operation**<br>
    This section contains instructions for executing the code

  - **Role of this code**<br>
    The role of code is briefly described in this section

  - **Caution!!**<br>
    This section contains notes for running the code & also contains troubleshooting tips

  - **Saved data location**<br>
    This section contains details of the data and where it is saved

  - **Procedure**<br>
    This section describes which code should be executed before and after the target code.
