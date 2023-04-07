#!/usr/bin/env groovy
pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    stages {
        stage('increment version of adservice') {
            steps {
                script {
                    echo 'incrementing app version...'
                    
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit -f Java-Maven-App/pom.xml'
                    def matcher = readFile('Java-Maven-App/pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_TAG = "$version-$BUILD_NUMBER"
                }
            }
        }

        stage('test, build app') {
            
            steps {
                script {
                    echo "building the application..."
                    sh 'mvn clean package -f Java-Maven-App/pom.xml'
                }
            }
        }

        stage('build, and Push image ') {
            
            steps {
                script {
                    echo "building the docker image..."

                     withDockerRegistry([ credentialsId: "ContainerRegistery", url: "" ]) {
                        
                        sh " docker build -t microservicesb.azurecr.io/emailservice:${IMAGE_TAG} ./src/emailservice/  "
                        sh " docker build -t microservicesb.azurecr.io/cartservice:${IMAGE_TAG} ./src/cartservice/src "
                        sh " docker build -t microservicesb.azurecr.io/currencyservice:${IMAGE_TAG} ./src/currencyservice/ "
                        sh " docker build -t microservicesb.azurecr.io/paymentservice:${IMAGE_TAG} ./src/paymentservice/ "
                        sh " docker build -t microservicesb.azurecr.io/recommendationservice:${IMAGE_TAG} ./src/recommendationservice/ "
                        sh " docker build -t microservicesb.azurecr.io/productcatalogservice:${IMAGE_TAG} ./src/productcatalogservice/ "
                        sh " docker build -t microservicesb.azurecr.io/adservice:${IMAGE_TAG} ./src/adservice/ "
                        sh " docker build -t microservicesb.azurecr.io/checkoutservice:${IMAGE_TAG} ./src/checkoutservice/  "
                        sh " docker build -t microservicesb.azurecr.io/shippingservice:${IMAGE_TAG} ./src/shippingservice/ "
                        sh " docker build -t microservicesb.azurecr.io/frontend:${IMAGE_TAG} ./src/frontend/ "

                        

                        sh " docker push  microservicesb.azurecr.io/emailservice:${IMAGE_TAG}  "
                        sh " docker push  microservicesb.azurecr.io/cartservice:${IMAGE_TAG} "
                        sh " docker push  microservicesb.azurecr.io/currencyservice:${IMAGE_TAG} "
                        sh " docker push microservicesb.azurecr.io/paymentservice:${IMAGE_TAG} "
                        sh " docker push  microservicesb.azurecr.io/recommendationservice:${IMAGE_TAG} "
                        sh " docker push  microservicesb.azurecr.io/productcatalogservice:${IMAGE_TAG} "
                        sh " docker push  microservicesb.azurecr.io/adservice:${IMAGE_TAG} "
                        sh " docker push  microservicesb.azurecr.io/checkoutservice:${IMAGE_TAG} "
                        sh " docker push  microservicesb.azurecr.io/shippingservice:${IMAGE_TAG} "
                        sh " docker push  microservicesb.azurecr.io/frontend:${IMAGE_TAG}  "
                        
                        
        
                    }
                }
            }
        }
        
        stage('deploy') {

                steps {
                    script {
                        echo 'deploying docker image...'
                       
                        sh " helm  upgrade --install rediscart  -f charts/values/redis.yaml ./charts/redis "
                        sh " helm  upgrade --install --set image.tag=$IMAGE_TAG emailservice  -f charts/values/emailservice.yaml ./charts/microservices "
                        sh " helm  upgrade --install --set image.tag=$IMAGE_TAG cartservice  -f charts/values/cartservice.yaml ./charts/microservices "
                        sh " helm  upgrade --install --set image.tag=$IMAGE_TAG currencyservice  -f charts/values/currencyservice.yaml ./charts/microservices "
                        sh " helm  upgrade --install --set image.tag=$IMAGE_TAG paymentservice  -f charts/values/paymentservice.yaml ./charts/microservices "
                        sh " helm  upgrade --install --set image.tag=$IMAGE_TAG recommendationservice  -f charts/values/recommendationservice.yaml ./charts/microservices "
                        sh " helm  upgrade --install --set image.tag=$IMAGE_TAG productcatalogservice  -f charts/values/productcatalogservice.yaml ./charts/microservices "
                        sh " helm  upgrade --install --set image.tag=$IMAGE_TAG shippingservice  -f charts/values/shippingservice.yaml ./charts/microservices "
                        sh " helm  upgrade --install --set image.tag=$IMAGE_TAG adservice  -f charts/values/adservice.yaml ./charts/microservices "
                        sh " helm  upgrade --install --set image.tag=$IMAGE_TAG checkoutservice  -f charts/values/checkoutservice.yaml ./charts/microservices "
                        sh " helm  upgrade --install --set image.tag=$IMAGE_TAG frontendservice  -f charts/values/frontend.yaml ./charts/microservices "

                    }
                }
            }
        // # make sure to add ignore plugin to jenkins to overide jenkins commit trriger the pipeline 
        stage('commit version update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                       
                        // git config here for the first time run
                        sh 'git config --global user.email "jenkins@jenkins.com"'
                        sh 'git config --global user.name "jenkins"'

                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/bendraabdelali/Deploy-a-Java-Application-to-a-Kubernetes-cluster-on-Azure-Using-Jenkins"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:main'

                    }
                }
            }
        }
    }
}
