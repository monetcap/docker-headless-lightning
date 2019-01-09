pipeline {
  agent any
  environment {
    DEPLOY_USER = 'runner'
    DEPLOY_HOST = 'ragnarok.monetcap.com'

    STAGING_DIR = '/docker/staging-backend.monetcap.com'
    PROD_DIR = '/docker/prod-backend.monetcap.com'
    FILES_DIR = 'webroot/docroot/sites/default/files'
  }
  stages {
    stage('Deploy Staging') {
      when { branch 'development' }
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: "89b383bf-8c04-4269-9df1-8a5ab97c579f", keyFileVariable: "keyfile")]) {
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "docker-compose stop"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "sudo rm -rf $STAGING_DIR/$FILES_DIR"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "sudo cp -r $PROD_DIR/$FILES_DIR $STAGING_DIR/$FILES_DIR"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "sudo chown -R www-data:www-data $STAGING_DIR/$FILES_DIR"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && git stash"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && git pull"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && git stash pop"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "docker-compose start"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && ./scripts/main.sh --import-config"'
        }
      }
    }
  }
}
