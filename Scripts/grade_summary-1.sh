#!/bin/bash

## Sebastian Main

###################################################################################
# Step 1: Data Preparation
# create a indexed array of students
students=(Alice Bob Charlie David Eva)

###################################################################################
# Create 3 Associative arrays for scores. math_scores, science_scores, 
# and literature_scores. The keys will be the name of the students and 
# add the values form the homework for each student in each class for math, 
# science, and literature
# A DICTIONARY!!!
declare -A math_scores
math_scores["Alice"]="95"
math_scores["Bob"]="82"
math_scores["Charlie"]="78"
math_scores["David"]="88"
math_scores["Eva"]="91"

declare -A science_scores
science_scores["Alice"]="90"
science_scores["Bob"]="85"
science_scores["Charlie"]="80"
science_scores["David"]="92"
science_scores["Eva"]="89"

declare -A literature_scores
literature_scores["Alice"]="93"
literature_scores["Bob"]="86"
literature_scores["Charlie"]="75"
literature_scores["David"]="90"
literature_scores["Eva"]="94"



###################################################################################
# Step 2: Calculations
# Create two Associative array. One for  average_scores and one for grades
# Do not initialize the arrays or the keys

# Arrays
declare -A average_scores

declare -A grades



###################################################################################
# make a for each loop to go through the student array
# inside the loop you will create a variable called sum
# assign sum the value of all of the three  
# arrays for each class with the keys of the students array
# Create a variable nambed average and assign it the value of 
# sum/3. 
# with the associative array assign the key value as the student for the array
# and then assign the value from the varable average to the average_scores 
# associative array
# lastly in the for each loop you will create either a condition statement 
# with a 5 elseif or a case statement tht will check the average value
# and depending on the value in avarage assign a grade into the grades associative
# array with the key as the students array and the character value "A","B","C","D", or "F"

for student in "${students[@]}"; do
    # Initialize the scores
    math=${math_scores[$student]}
    science=${science_scores[$student]}
    literature=${literature_scores[$student]}

    # Average grades
    sum=$(($math + $science + $literature))
    average=$(($sum / 3))

    # Add to average_scores
    average_scores["$student"]=$average

    # Else if Statements for grade
    if((average >= 90)); then
        grades["$student"]="A"
    elif((average >= 80 && average <= 89)); then
        grades["$student"]="B"
    elif((average >= 70 && average <= 79)); then
        grades["$student"]="C"
    elif((average >= 60 && average <= 69)); then
        grades["$student"]="D"
    elif((average > 60)); then
        grades["$student"]="F"
    fi
done
###################################################################################
# Step 3: Summary Report
# Associative array for grade_distribution and give it the key value
# of the "A", "B", "C", "D", "F" and assign the value 0. 
# this associative array will be used in the following for each loop

declare -A grade_distribution
grade_distribution["A"]="0"
grade_distribution["B"]="0"
grade_distribution["C"]="0"
grade_distribution["D"]="0"
grade_distribution["F"]="0"

###################################################################################
# nothing to be done in this block

# Calculate grade distribution by creating a for each loop
for grade in "${grades[@]}"; do
    ((grade_distribution[$grade]++))
done

# Print report
echo "Student Grade Summary:"
echo "----------------------"
###################################################################################
# use a for each loop that will go through the students
# and print out with echo the average score and grade Hint: use the 
# associative arrays with the student as the key value
# this output should be similar to the output given on the homework doc

for student in "${students[@]}"; do
    echo "$student: Average score = ${average_scores[$student]}, Grade = ${grades[$student]}"
done


###################################################################################
# nothing to be done in this block

echo ""
echo "Grade Distribution:"
echo "------------------"
###################################################################################
# create a for each loop that will go through and print out with echo 
# grade distribution like the output shows in the homework doc.

for grade in "${!grade_distribution[@]}"; do
    echo "Grade $grade: ${grade_distribution[$grade]}"
done | tac


###################################################################################