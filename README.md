# slcsp-challenge
My implementation of the Ad Hoc SLCSP Challenge- determine the second lowest cost silver plan (SLCSP) for a group of ZIP codes.

# Setup Instructions:
- In order to keep the setup for this solution simple, I did not include a Gemfile or dependency management
- The default ruby version for MacOS Sonomma can be used to run this code (2.6-2.7)
- Any Ruby versions > 2.7 can also be used

# Running the project:
1. First, navigate to the root directory "slcsp-challenge" in Terminal
2. Next, run the command "ruby calculate_slcsp.rb"
   - The results will be added to slcsp.csv and output to the console (in Terminal)
3. For subsequent runs/tests, I added slcsp_backup.csv to make it easier to reset the previous state of slcsp.csv
