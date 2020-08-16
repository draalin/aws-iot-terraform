# AWS IoT Setup
Basic implementation of using Amazon IoT and a EC2 instance to simulate an edge device that would recieve data.

In this scenario we're using a ReactJS app on the EC2 instance. Its been provisioned to subscribe to a MQTT topic on Amazon IoT. 

Once you publish to the topic you'll see that the message has been received within your browsers console.

## Requirements
- An AWS account
- Minimum of Terraform version 12 and have setup the `provider.tf` and `variables.tf` with your preferred configuration.

## How to Run
Initialize providers
```
terraform init
```

Deploy infrastructure
```
terraform apply --auto-approve
```

Show infrastructure
```
terraform show
```

Show outputs
```
terraform output
```

Destroy infrastructure
```
terraform destroy --auto-approve
```

## How to test
- Open browser to terraform public_ip output. ex: `http://54.208.171.227:3000`
- Open up developer tools followed by the console.
- Simulate a publish to the topic `real-time-data` at `https://console.aws.amazon.com/iot/home?region=us-east-1#/test`
- Return to the browser to see the subscribed message from the topic.