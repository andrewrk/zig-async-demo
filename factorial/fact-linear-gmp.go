// Package factorial allows for users to calculate the factorial of any int64 in the form of a big.Int.
// The calculations can be done sequentially or concurrently.
package main

import big "github.com/ncw/gmp"

func main() {
	Factorial(3000000)
}

// Factorial calculates the factorial of n.
// The calculation is done sequentially.
// If n < 0, -1 is returned.
func Factorial(n int64) *big.Int {
	if n == 0 {
		return big.NewInt(1)
	}
	if n < 0 {
		return big.NewInt(-1)
	}
	out := big.NewInt(1)
	out.MulRange(1, n)
	return out
}

