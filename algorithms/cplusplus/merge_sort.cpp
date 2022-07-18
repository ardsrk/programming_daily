/* 
 Merge sort algorithm

 Runtime Analysis:
   For a input of length n integers, merge sort requires O(n*log2(n)) operations
   to sort the array:
     
     1. Recursive calls to mergeSort produce a binary tree having log2(n) levels.
     2. The merge call takes O(n) operations are at every level giving a total
        runtime of O(n*log2(n)).

 Input:
   Array of integers

 Output:
   Input array sorted in ascending order

 Compiling:
   g++ -Wall merge.cpp -o merge.o

 Running:
   ./merge_sort.o
 
 Debugging:
   DEBUG=on ./merge_sort.o
 
 References:
   merge_sort.rb
   https://www.geeksforgeeks.org/merge-sort/

*/

#include <random>
#include <cstring>
#include <cstdio>

using namespace std;

const int input_array_size = 10;

bool debugOn()
{
  char * val = getenv( "DEBUG" );
  return (val != NULL) ? string(val) == "on" : false;
}

bool printDebugInfo = debugOn();

void print(int *arr, const int array_size, const int beginIdx=0)
{
  printf("[");
  for(int i=beginIdx; i < array_size; i++)
  {
    printf("%2d", arr[i]);
    if(i != array_size-1)
      printf(" ");
    else
      printf("]\n");
  }
}

void merge(int* array, int const left, int const mid, int const right)
{
  int leftArraySize = mid - left + 1;
  int rightArraySize = right - mid;


  int* leftArray = new int[leftArraySize];
  int* rightArray = new int[rightArraySize];

  memcpy(leftArray, array+left, leftArraySize * sizeof(int));
  memcpy(rightArray, array+mid+1, rightArraySize * sizeof(int));


  int l=0, r=0, m=left;
  while(l < leftArraySize && r < rightArraySize)
  {
    if(leftArray[l] < rightArray[r]){
      array[m++] = leftArray[l++];
    }
    else
    {
      array[m++] = rightArray[r++];
    }
  }
  if(l < leftArraySize)
  {
    memcpy(array+m, leftArray+l, (leftArraySize-l) * sizeof(int));
  }

  if(r < rightArraySize)
  {
    memcpy(array+m, rightArray+r, (rightArraySize-r) * sizeof(int));
  }

  if(printDebugInfo)
  {
    printf("l: ");
    print(leftArray, leftArraySize);
    printf("r: ");
    print(rightArray, rightArraySize);
    printf("m: ");
    print(array, m+1, left);
  }

  delete[] leftArray;
  delete[] rightArray;
}

void mergeSort(int* array, int const begin, int const end)
{
  if(begin >= end){
    return;
  }
  int mid = begin + (end - begin) / 2;
  mergeSort(array, begin, mid);
  mergeSort(array, mid+1, end);
  merge(array, begin, mid, end);
}

int main()
{
  int input_array[input_array_size];

  default_random_engine generator;
  uniform_int_distribution<int> distribution(1,100);
  for(int i=0; i < input_array_size; i++)
  {
    input_array[i] = distribution(generator);
  }

  printf("Input  = ");
  print(input_array, input_array_size);

  mergeSort(input_array, 0, input_array_size-1);

  printf("Output = ");
  print(input_array, input_array_size);

  return 0;
}
