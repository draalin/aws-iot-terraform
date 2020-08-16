data "aws_iot_endpoint" "iot" {}

data "template_file" "iot" {
  template = file("install.sh")
  vars = {
    REACT_APP_IDENTITY_POOL_ID        = aws_cognito_identity_pool.iot.id
    REACT_APP_REGION                  = var.aws_region
    REACT_APP_USER_POOL_ID            = aws_cognito_user_pool.iot.id
    REACT_APP_USER_POOL_WEB_CLIENT_ID = aws_cognito_user_pool_client.iot.id
    REACT_APP_MQTT_ID                 = data.aws_iot_endpoint.iot.endpoint_address
  }
}