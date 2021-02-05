output "alb_dns_name" {
  value = module.ecs.alb_dns_name
}

output "redis_url" {
  value = module.redis.url
}
