# EMG_analysis
This repository contains the code required for EMG analysis and muscle synergy analysis

# how to analyze
# to read the alpha omega recordings
#preliminary preparations:
Please place the measurement data file directly under the monkey name folder
(ex.) data -> Yachimun -> F170516-0002.mat &F170516-0003.mat & F170516-0004.mat

#1.run 'SaveFileinfo.m'
  this code location: data -> monkeyname -> here!!
  function: save data for merging measurement data. Saved as ~standard.mat in monkey_name -> easyData folder
#2.run 'runnningEasyfunc.m'
  this code location: data -> here!!
  function: 3 function
            # merge data & generate timing_data
            # evaluate cross-talk
            # filtering & Time Normalization of Tasks
  file is Saved in monkey_name -> easyData folder -> ~_standard folder or monkey_name -> easyData folder -> P-DATA folder
#3.run 'plotTarget.m'
  this code location: data -> here!!
  function: plot EMG data
  picture is saved in monkey_name -> easyData -> P-DATA -> ~to~_num (ex.)F170516toF170516_1 folder

Change the parameters of each .m file as needed
