pipeline {
    agent any

    tools {
        jdk 'JDK17'
        maven 'Maven'
    }
    environment {
        SCANNER_HOME = tool 'Sonar-Scanner'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Pranay-OS18/Java-CICD-Project.git'
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Scan') {
            steps {
                sh 'trivy fs --format table -o scan-report.html .'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('Sonar-Server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=JVM-App -Dsonar.projectKey=JVM-App \
                            -Dsonar.java.binaries=. '''
                }
            }
        }
        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialId: 'Sonar-Token'
                }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Artifact to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'Global-Settings', jdk: 'JDK17', maven: 'Maven', mavenSettingsConfig: '', traceability: true) {
                    sh 'mvn deploy'
                }
            }
        }
        stage('Build & Tag Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'Docker-Cred')  {
                        sh 'docker build -t pranay18cr/jvm-image:latest .'
                    }
                }
            }
        }
        stage('Image Scan') {
            steps {
                sh 'trivy image --format table -o scan-image-report.html pranay18cr/jvm-image:latest'
            }
        }
        stage('Push Image To Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: 'Docker-Cred', toolName: 'Docker')  {
                        sh 'docker push pranay18cr/jvm-image:latest'
                }
            }
        }
    }
}    