## Hardware based array sorting

This parallel sorting algorithm is based on:

https://hackaday.com/2016/01/20/a-linear-time-sorting-algorithm-for-fpgas/

https://github.com/Poofjunior/fpga_fast_serial_sort

Time complexity for implemented algorithm is `O(n)`.

----

All cells are empty once the sorting starts. We start by inserting a new element, this new element will be the smallest we’ve seen so far, so it will be inserted into the first sorting cell.

<img src="images/linsort1.png" alt="drawing" width="500"/>

<img src="images/linsort2.png" alt="drawing" width="500"/>

<img src="images/linsort3.png" alt="drawing" width="500"/>

• If a cell is empty, it will claim the incoming element if the above cell is occupied.

• If a cell is occupied, it will claim the incoming element if the incoming element is less than the stored element AND the occupied cell above this cell is not kicking out its element.

• If the cell above the current cell kicks out it’s stored element, then the current cell MUST claim the above cell’s element, regardless of whether or not the current cell is empty or occupied.

• If a cell is occupied and accepts a new element (either from the above cell or from the incoming data), it must kick out its current element.

#### Schematic

<img src="images/SCH1.PNG" alt="drawing" width="850"/>

<img src="images/SCH2.PNG" alt="drawing" width="850"/>

<img src="images/SCH3.PNG" alt="drawing" width="850"/>

We read the unsigned 8-bit numbers from a ROM.

First cell: pre_data doesn't exist (since this is the first cell)

For the last cell we connect `nxt_data` to the `sorted_data` output.


#### Testbench
<img src="images/TB1.PNG" alt="drawing" width="850"/>

<img src="images/TB2.PNG" alt="drawing" width="850"/>

<img src="images/TB3.PNG" alt="drawing" width="850"/>

<img src="images/TB4.PNG" alt="drawing" width="850"/>


#### Synthesis report
<img src="images/SUMMARY.PNG" alt="drawing" width="550"/>

<img src="images/POWER.PNG" alt="drawing" width="550"/>
