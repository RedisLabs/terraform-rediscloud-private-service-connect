terraform {
  required_version = "~> 1.2"
  required_providers {
    rediscloud = {
      source  = "RedisLabs/rediscloud"
      version = "~> 2.0" # TODO Bump to 2.1
    }
  }
}
