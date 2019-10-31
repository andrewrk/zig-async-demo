package main

import (
	"errors"
	"math/rand"
	"sync"
	"time"
)

type req struct {
	respChan chan<- resp
	cancel   <-chan struct{}
}

type resp struct {
	id    int
	piece []byte
	err   error
}

func host(id int, reqChan chan req) {
	req, ok := <-reqChan
	if !ok {
		return
	}

	piece, err := fetchPiece(req.cancel)
	r := resp{
		id:    id,
		piece: piece,
		err:   err,
	}

	select {
	case req.respChan <- r:
	case <-req.cancel:
	}
}

func fetchPiece(cancel <-chan struct{}) ([]byte, error) {
	select {
	// simulated work: takes 1s, with 50% chance of failure
	case <-time.After(time.Second):
		if rand.Intn(2) == 0 {
			return []byte("valid piece"), nil
		} else {
			return nil, errors.New("failed")
		}
	case <-cancel:
		return nil, errors.New("canceled")
	}
}

func main() {
	rand.Seed(0) // Go playground has deterministic concurrency; modify seed for different outcomes

	// spawn 10 host goroutines
	reqChan := make(chan req)
	var wg sync.WaitGroup
	for i := 0; i < 10; i++ {
		wg.Add(1)
		go func(i int) {
			host(i, reqChan)
			wg.Done()
		}(i)
	}

	// request pieces from 7 hosts
	respChan := make(chan resp)
	cancel := make(chan struct{})
	for i := 0; i < 7; i++ {
		reqChan <- req{
			respChan: respChan,
			cancel:   cancel,
		}
	}
	tried := 7

	// wait for responses, and replace each failed request with a new one
	pieces := make([][]byte, 10)
	var good, bad int
	for {
		res := <-respChan
		if res.err == nil {
			good++
			pieces[res.id] = res.piece
			if good >= 6 {
				break // got enough pieces; success
			}
		} else {
			bad++
			if bad > 4 {
				break // couldn't get enough pieces; failure
			}
			if tried < 10 {
				// try another host
				reqChan <- req{
					respChan: respChan,
					cancel:   cancel,
				}
				tried++
			}
		}
	}

	if good >= 6 {
		println("success!", good, "good,", bad, "bad")
	} else {
		println("failure!", good, "good,", bad, "bad")
	}

	// stop any remaining hosts
	close(cancel)
	close(reqChan)
	// wait for hosts to exit
	wg.Wait()
}

