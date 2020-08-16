output "public_ip" {
  value = "http://${aws_instance.iot.public_ip}:3000"
}
output "iot_endpoint" {
  value = data.aws_iot_endpoint.iot.endpoint_address
}
output "pool_id" {
  value = aws_cognito_user_pool.iot.id
}
output "client_id" {
  value = aws_cognito_user_pool_client.iot.id
}
output "ident_id" {
  value = aws_cognito_identity_pool.iot.id
}