package main

import (
	"context"
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"log"
	"os"

	"github.com/segmentio/kafka-go"
)

func main() {

	caCert, err := os.ReadFile(".client/ca-cert")

	if err != nil {
		log.Fatal(err)
	}

	caCertPool := x509.NewCertPool()
	caCertPool.AppendCertsFromPEM(caCert)

	tlsConfig := &tls.Config{
		RootCAs: caCertPool,
	}

	reader := kafka.NewReader(kafka.ReaderConfig{
		Brokers: []string{"localhost:9094"},
		Topic:   "test_topic",
		Dialer: &kafka.Dialer{
			TLS: tlsConfig,
		},
	})

	for {
		msg, err := reader.FetchMessage(context.Background())

		if err != nil {
			log.Fatal(err)
		}

		fmt.Printf("message: %s\n", msg.Value)
	}
}
