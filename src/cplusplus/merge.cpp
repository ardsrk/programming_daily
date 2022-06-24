/* 
 Merge two pre-sorted arrays a1 and a2 into result

 Compiling:
   g++ merge.cpp -o merge.o

 Running:
   ./merge.o
 
 References:
   merge.rb
   https://cplusplus.com/reference/random/
   https://www.geeksforgeeks.org/return-local-array-c-function/
   https://en.cppreference.com/w/cpp/string/byte/memcpy
*/

#include <random>
#include <iostream>
#include <cstring>
#include <algorithm>

using namespace std;

const int a1_size = 5;
const int a2_size = 5;
const int total_size = a1_size + a2_size;

void print(int *arr, const int array_size)
{
  cout << "[";
  for(int i=0; i < array_size; i++)
  {
    cout << arr[i];
    if(i != array_size-1)
      cout << " ";
    else
      cout << "]";
  }
  cout << endl;
}

int* merge(int *a1, int *a2)
{
  int* result = new int[total_size];
  int i1=0, i2=0, r=0;

  while(i1 < a1_size && i2 < a2_size)
  {
    if(a1[i1] < a2[i2]){
      result[r++] = a1[i1];
      i1++;
    }
    else
    {
      result[r++] = a2[i2];
      i2++;
    }
  }
  if(i1 < a1_size)
  {
    memcpy(result+r, a1+i1, (a1_size-i1) * sizeof(int));
  }

  if(i2 < a2_size)
  {
    memcpy(result+r, a2+i2, (a2_size-i2) * sizeof(int));
  }
  return result;
}

int* arrSort(int* a1, int* a2) {
  int* result = new int[total_size];

  memcpy(result, a1, a1_size * sizeof(int));
  memcpy(result+a1_size, a2, a2_size * sizeof(int));

  sort(result, result+total_size);
  return result;
}

bool arraysEqual(int* r1, int* r2)
{
  bool result = true;
  for(int i = 0; i < total_size; i++)
  {
    if(r1[i] != r2[i])
    {
      result = false;
      break;
    }
  }
  return result;
}

int main()
{
  int a1[a1_size];
  int a2[a2_size];

  default_random_engine generator;
  uniform_int_distribution<int> distribution(1,100);
  for(int i=0; i < a1_size; i++)
  {
    a1[i] = distribution(generator);
  }
  sort(a1, a1+a1_size);
  
  for(int i=0; i < a2_size; i++)
  {
    a2[i] = distribution(generator);
  }
  sort(a2, a2+a2_size);

  int *result = merge(a1, a2);
  int *sorted_arr = arrSort(a1, a2);
  bool arraySorted = arraysEqual(result, sorted_arr);
  
  cout << "a1            = ";
  print(a1, a1_size);
  cout << "a2            = ";
  print(a2, a2_size);
  cout << "merge(a1, a2) = ";
  print(result, total_size);

  cout << "sorted        = ";
  if(arraySorted)
    cout << "true" << endl;
  else
    cout << "false" << endl;

  delete[] result;
  delete[] sorted_arr;
  return 0;
}
