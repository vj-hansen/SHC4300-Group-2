https://hackaday.com/2016/01/20/a-linear-time-sorting-algorithm-for-fpgas/

1.  All cells are empty. We start by inserting a new element, but we need a place to put it. Since all cells are empty, this new element is the smallest we’ve seen so far, so let’s insert it at the top.

Every time we insert a new element, we look at each cell and ask ourselves: “Does my new data fit here?” Because we’ve agreed beforehand that the contents of our cell array will always be sorted, it turns out that every cell can answer this question independently without knowing the contents of the rest of the cells. All it needs to do is ask for a few bits of information from the cell above it.

•   If a cell is empty, it will only claim the incoming element if the above cell is occupied.
•   If a cell is occupied, it will claim the incoming element if both the incoming element is less than the stored element AND the occupied cell above this cell is not kicking out its element.
•   If the cell above the current cell kicks out it’s stored element, then the current cell MUST claim the above cell’s element, regardless of whether or not the current cell is empty or occupied.
•   If a cell is occupied and accepts a new element (either from the above cell or from the incoming data), it must kick out its current element.


        -- Regular cells ( i.e. the cells between the first and last cell):
        -- Connect `pre_` to the previous cell's `nxt_` values
        -- Connect `nxt_` to the next cell's `pre_` values.


        -- Last cell:
        -- Don't connect the `nxt_data` since we're at the last cell

        -- First cell:
        -- pre_data doesn't exist (since this is the first cell)



#### Schematic

<img src="https://github.com/vjhansen/SHC4300-Group-2/blob/master/CCW4_Array_Sorting/HW_array_sorter/images/SCH1.PNG" alt="drawing" width="450"/>

<img src="https://github.com/vjhansen/SHC4300-Group-2/blob/master/CCW4_Array_Sorting/HW_array_sorter/images/SCH2.PNG" alt="drawing" width="450"/>

<img src="https://github.com/vjhansen/SHC4300-Group-2/blob/master/CCW4_Array_Sorting/HW_array_sorter/images/SCH3.PNG" alt="drawing" width="450"/>


#### Testbench
<img src="https://github.com/vjhansen/SHC4300-Group-2/blob/master/CCW4_Array_Sorting/HW_array_sorter/images/TB1.PNG" alt="drawing" width="450"/>

<img src="https://github.com/vjhansen/SHC4300-Group-2/blob/master/CCW4_Array_Sorting/HW_array_sorter/images/TB2.PNG" alt="drawing" width="450"/>

<img src="https://github.com/vjhansen/SHC4300-Group-2/blob/master/CCW4_Array_Sorting/HW_array_sorter/images/TB3.PNG" alt="drawing" width="450"/>

<img src="https://github.com/vjhansen/SHC4300-Group-2/blob/master/CCW4_Array_Sorting/HW_array_sorter/images/TB4.PNG" alt="drawing" width="450"/>


#### utilization
<img src="https://github.com/vjhansen/SHC4300-Group-2/blob/master/CCW4_Array_Sorting/HW_array_sorter/images/SUMMARY.PNG" alt="drawing" width="450"/>


#### Power
<img src="https://github.com/vjhansen/SHC4300-Group-2/blob/master/CCW4_Array_Sorting/HW_array_sorter/images/POWER.PNG" alt="drawing" width="450"/>
