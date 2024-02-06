#!/bin/bash

rm -rf .ssl/secrets/*
# Generate CA Key and Certificate
openssl genrsa -out .ssl/secrets/ca-key.pem 2048
openssl req -new -x509 -key .ssl/secrets/ca-key.pem -out .ssl/secrets/ca-cert -days 365 -subj '/CN=Kafka CA'

# Create Keystore for Kafka Broker
keytool -keystore .ssl/secrets/kafka.server.keystore.jks -alias localhost -validity 365 -genkey -keyalg RSA -storepass keypassword -keypass keypassword -dname "CN=localhost"
keytool -keystore .ssl/secrets/kafka.server.keystore.jks -alias localhost -certreq -file .ssl/secrets/cert-file -storepass keypassword

# Sign the Kafka Broker Certificate with the CA
openssl x509 -req -CA .ssl/secrets/ca-cert -CAkey .ssl/secrets/ca-key.pem -in .ssl/secrets/cert-file -out .ssl/secrets/cert-signed -days 365 -CAcreateserial -extfile .ssl/san.cnf -extensions req_ext

# Import CA Certificate and Signed Certificate into the Kafka Keystore
keytool -keystore .ssl/secrets/kafka.server.keystore.jks -alias CARoot -import -noprompt -file .ssl/secrets/ca-cert -storepass keypassword
keytool -keystore .ssl/secrets/kafka.server.keystore.jks -alias localhost -import -file .ssl/secrets/cert-signed -storepass keypassword

# Create Truststore for Kafka Broker and Import CA Certificate
keytool -keystore .ssl/secrets/kafka.server.truststore.jks -alias CARoot -import -noprompt -file .ssl/secrets/ca-cert -storepass truststorepassword


cp .ssl/secrets/ca-cert .client/ca-cert

cp .ssl/key_creds .ssl/secrets/key_creds
cp .ssl/keystore_creds .ssl/secrets/keystore_creds
cp .ssl/truststore_creds .ssl/secrets/truststore_creds