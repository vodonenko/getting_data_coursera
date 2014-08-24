The script downloads data from the web and  extracts the zip content to a working directory. 

Union operations (merging vertically) are used to combine train and test sets.
Colnames are replaced with complete names.
Two columns indicating subject and activity are added to the main set.

Names are converted to the format operatable by R.

Columns not indicating mean or st.dev are removed.

Loop structures and apply() functions are used to calculate the average of the remaining variables for each activity and subject.
