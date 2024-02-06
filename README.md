# Setup

## SSL

Make ssl script executable
```
chmod +x ssl.sh
```

Run it
```
./ssl.sh
```

## Kafka

Start the docker-compose

```
docker-compose up -d
```

Or if you're using a newer version of docker with plugins

```
docker compose up -d
```

## Create the test topic

- Access [0.0.0.0:9021](http://0.0.0.0:9021)
- Click on the big `controlcenter.cluster` card
- Click on Topics in the left navigation bar
- Press `Add Topic` and create a topic with 1 partition named `test_topic`

## Publish a message to the `test_topic`

- Click on the `test_topic` you've just created
- Go to the `Messages` tab
- Click `Produce a new message to this topic`
- The message defaults should be fine, but you can do whatever changes you wish
- Press `Produce`

## Start the consumer

```
go run .
```

You should now see the message you created being printed to the stdout
