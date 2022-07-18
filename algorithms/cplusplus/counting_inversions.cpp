/* 
 Counting Inversions

 Problem:
   Count inversions in given input array.
   Inversion in an array 'a' occurs at index 'i' and 'j' when a[i] > a[j] and i < j 
 
 Example:
   In the array [1, 3, 5, 2, 4, 6] there are three inversions:
   (3, 2), (5, 2), and (5, 4)

 Applications:
   Can be used to find divergence between preferences of two people.

 Runtime Analysis:
   For a input of length n integers, counting inversions requires O(n*log2(n)) operations
   to sort the array:
     
     1. Recursive calls to countInversions produce a binary tree having log2(n) levels.
     2. The countSplitInversions call takes O(n) operations are at every level giving a total
        runtime of O(n*log2(n)).

 Input:
   Array of integers

 Output:
   1. Number of inversions

 Compiling:
   g++ -Wall counting_inversions.cpp -o counting_inversions.o

 Running:
   ./counting_inversions.o
 
 References:
   counting_inversions.rb
   https://www.youtube.com/watch?v=7_AJfusC6UQ
   https://www.youtube.com/watch?v=I6ygiW8xN7Y
*/

#include <cstring> // memcpy
#include <cstdio>  // printf

using namespace std;

const int input_array_size = 6;

int countSplitInversions(int* array, int const left, int const mid, int const right)
{
  int leftArraySize = mid - left + 1;
  int rightArraySize = right - mid;


  int* leftArray = new int[leftArraySize];
  int* rightArray = new int[rightArraySize];

  memcpy(leftArray, array+left, leftArraySize * sizeof(int));
  memcpy(rightArray, array+mid+1, rightArraySize * sizeof(int));


  int l=0, r=0, m=left, inversions = 0;
  while(l < leftArraySize && r < rightArraySize)
  {
    if(leftArray[l] < rightArray[r]){
      array[m++] = leftArray[l++];
    }
    else
    {
      array[m++] = rightArray[r++];
      inversions = inversions + leftArraySize - l;
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


  delete[] leftArray;
  delete[] rightArray;
  return inversions;
}

int countInversions(int* array, int const begin, int const end)
{
  if(begin >= end){
    return 0;
  }
  int mid = begin + (end - begin) / 2;
  int linv, rinv, splitInv;
  linv = countInversions(array, begin, mid);
  rinv = countInversions(array, mid+1, end);
  splitInv = countSplitInversions(array, begin, mid, end);
  return linv + rinv + splitInv;
}

void print(int *arr, const int array_size, const int beginIdx=0)
{
  printf("[");
  for(int i=beginIdx; i < array_size; i++)
  {
    printf("%d", arr[i]);
    if(i != array_size-1)
      printf(" ");
    else
      printf("]\n");
  }
}

int bruteForce(int* a, int const begin, int const end)
{
  int inversions = 0;
  for(int i = 0; i <= end; i++)
  {
    for(int j = i; j <= end; j++)
    {
      if(a[i] > a[j])
        inversions++;
    }
  }
  return inversions;
}

int main()
{
  int inversions;
  int input_array[input_array_size] = {1, 3, 5, 2, 4, 6};

  printf("Input      = ");
  print(input_array, input_array_size);

  inversions = countInversions(input_array, 0, input_array_size-1);

  printf("Inversions = %d\n", inversions);

  return 0;
}
