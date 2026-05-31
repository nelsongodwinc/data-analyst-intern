Steps performed :



Step 1: Normalize Column Headers: Trimmed outer whitespaces from all column names.



Transformed all text to lowercase characters.



Substituted spaces and special characters with underscores (\_) to enforce a uniform naming convention (e.g., Year Birth -> year\_birth).



Step 2: Address Missing Data: Identified null entries within the income column utilizing .isnull().



Filled these empty fields with the statistical median of the column to preserve the dataset's volume.



Step 3: Eliminate Duplicates: Purged all exact overlapping records from the dataset using the .drop\_duplicates() method.



Step 4: Normalize Categorical Variables: Rectified the marital status column by mapping unstructured and slang inputs (such as "Alone", "YOLO", and "Absurd") to a standardized "Single" category.



Step 5: Correct Data Types: Enforced strict integer (int) typing for the income column.



Translated the customer enrollment date strings into native Pandas datetime objects.



Step 6: Uniform Date Formatting: Adjusted the newly parsed datetime objects to display consistently as DD-MM-YYYY strings.

