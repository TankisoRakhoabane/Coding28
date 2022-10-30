//Program by Tankiso Rakhoabane
//A program taht determines and prints the first 10 reversible prime squares

#include<stdio.h>
#include<stdbool.h>

//function that checks if a number is a prime number
bool primeNum(int num){
	int p=0;      //p=number of factors
	for(int i=1; i<=num; i++){
		if(num%i==0)
			p++;   //move to the next factor if dividing a number by a counter leaves no remainder 
	}
	if(p==2){
	 return true;   //if the number of factors is 2 numbers then return true
	 }
	 return false;    //otherwise return false
}

//function that reverses a number 
int ReverseNum(int num)
{
	int reverse=0;      //inititalize the reverse to 0
	int remainder;
	while(num!=0)       //as long as the number is not equal to 0, continue with the loop
	{
		remainder=num%10;
		reverse=reverse*10+remainder;
		num/=10;
	}
	return reverse;     //or return reverse which is 0
}

//function that checks if the number and its reverse are palindromes
bool checkPal(int num, int reversedNum)
{
	if(num==reversedNum)    //if the number and it's inverse are eqaul to each other then return true
		return true;
	else 
		return false;     //otherwise false
}

//function that checks if the reversed number is square
bool Check_Square(int reversedNum)
{
	bool check=false;   //initialize check to false whiich wil ony be true if the reversedNum is a square number  
	for(int i=1; i<=reversedNum; i++){
		if(reversedNum/i==i && reversedNum%i==0){    //if the reversedNum is equal to the square of i and the remainder of the reversedNum when divided by i is 0
			if(primeNum(i)){
				check=true;
			}
			else {
				check=false;   //return check which was firstly initialized to false if the reversedNum is not a prime number
			}
		}
}
	return check;      //return check=false if the the reversedNum is greater than i 
}

int main(){
	int Reverseprime[10];
	int num=1;
	int square;
	for(int i=1; i<=10; i++){
		while(i){
			if(primeNum(num))    //call the function primeNum to our num is a prime number
			{
				square=num*num;   //square the number the num if it is a primeNum 
				if(checkPal(square, ReverseNum(square))){  //call the fucntion reverseNum to reverse the squared num then call the function checkPal to see if the squared number and it's reversedNum are palindromes
					num++;   //then increment num to deal with the next squared number
				}
				else{
					if(Check_Square(ReverseNum(square)))  //otherwise call checksquare to see if the reversedNum is a square
					{
					  	Reverseprime[i]=square;  //put the results in an array named reverseprime
					  	num++;
					  	break;
					  }
					  else{
					  	num++;  //if the reversedNum is not a square, move to the next num in line
					  }
					
				}				
				 
			}
			else num++;   //if the num is not a prime number, check the next number
		
		}
	}
	printf("********************************************\n");
	printf("*                                          *\n");
	printf("*     THE 10 REVERSIBLE PRIME SQUARES      *\n");
	printf("*                                          *\n");
	printf("********************************************\n");
	for(int i=0; i<10; i++)
	{
		printf("(%d) %d\n",i+1, Reverseprime[i]);  
    }
    
	return 0;
}