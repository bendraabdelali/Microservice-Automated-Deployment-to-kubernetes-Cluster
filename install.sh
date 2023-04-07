helm upgrade --install rediscart  -f charts/values/redis.yaml .\charts\redis
helm upgrade --install --set image.tag=$IMAGE_TAG emailservice  -f charts/values/emailservice.yaml .\charts\microservices
helm upgrade --install --set image.tag=$IMAGE_TAG cartservice  -f charts/values/cartservice.yaml .\charts\microservices
helm upgrade --install --set image.tag=$IMAGE_TAG currencyservice  -f charts/values/currencyservice.yaml .\charts\microservices
helm upgrade --install --set image.tag=$IMAGE_TAG paymentservice  -f charts/values/paymentservice.yaml .\charts\microservices
helm upgrade --install --set image.tag=$IMAGE_TAG recommendationservice  -f charts/values/recommendationservice.yaml .\charts\microservices
helm upgrade --install --set image.tag=$IMAGE_TAG productcatalogservice  -f charts/values/productcatalogservice.yaml .\charts\microservices
helm upgrade --install --set image.tag=$IMAGE_TAG shippingservice  -f charts/values/shippingservice.yaml .\charts\microservices
helm upgrade --install --set image.tag=$IMAGE_TAG adservice  -f charts/values/adservice.yaml .\charts\microservices
helm upgrade --install --set image.tag=$IMAGE_TAG checkoutservice  -f charts/values/checkoutservice.yaml .\charts\microservices
helm upgrade --install --set image.tag=$IMAGE_TAG frontendservice  -f charts/values/frontend.yaml .\charts\microservices
