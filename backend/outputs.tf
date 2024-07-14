output "rest_api_id" {
  description = "the api id that goes at the beginning of the invoke url that will go in the script file so your resume can access the backend"
  value = aws_api_gateway_rest_api.rest_api.id
}