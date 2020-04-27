#!/bin/bash
total_test_cases=100
max_nums=200
max_value=4500
RANDOM=$$
TEST_FILE=testSample.dat
RESULT_FILE=outcomes.dat
>$TEST_FILE
>$RESULT_FILE
echo $RANDOM
for loop in `seq $total_test_cases`
do
	nums=$((RANDOM%$max_nums))
	for i in `seq $nums`
	do
		arr[$i]=$((RANDOM%$max_value))
		#echo $((RANDOM%$max_value))
	done
	echo ${#arr[@]} >> $TEST_FILE 
	printf '%s\n' "${arr[@]}"  >> $TEST_FILE 
	printf '\n' >> $TEST_FILE
	printf '%s\n' "${arr[@]}" | sort -n | tr "\n" " " >> $RESULT_FILE
	printf '\n' >> $RESULT_FILE
	unset arr

done	
