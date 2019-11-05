// Package factorial allows for users to calculate the factorial of any int64 in the form of a big.Int.
// The calculations can be done sequentially or concurrently.
package main

import (
	"runtime"
)
import big "github.com/ncw/gmp"

func main() {
	ParallelFactorial(3000000)
}

// ParallelFactorial calculates the factorial of n.
// The calculation is done concurrently.
// A go routine is created for each proc.
// If n < 0, -1 is returned.
func ParallelFactorial(n int64) *big.Int {
	if n == 0 {
		return big.NewInt(1)
	}
	if n < 0 {
		return big.NewInt(-1)
	}
	procs := previousPowerOfTwo(int64(runtime.GOMAXPROCS(0)))
	if n < procs {
		return Factorial(n)
	}

	outRange := make(chan *big.Int, procs)

	for i := int64(0); i < procs; i++ {
		go mulRange(i*n/procs+1, (i+1)*n/procs, outRange)
	}

	in := outRange
	for procs > 1 {
		out := make(chan *big.Int, procs/2+1)
		odd := false
		if procs%2 == 1 {
			odd = true
		}
		procs /= 2
		for i := int64(0); i < procs; i++ {
			go reduceMul(in, out)
		}
		if odd {
			out <- <-in
			procs++
		}
		in = out
	}
	return <-in
}

func reduceMul(in <-chan *big.Int, out chan<- *big.Int) {
	total := <-in
	n := <-in
	total.Mul(total, n)
	out <- total
}

func previousPowerOfTwo(x int64) int64 {
	for i := uint(1); i < 64; i *= 2 {
		x = x | (x >> i)
	}
	return x - (x >> 1)
}

func mulRange(x int64, y int64, out chan<- *big.Int) {
	total := big.NewInt(0)
	total.MulRange(x, y)
	out <- total
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
