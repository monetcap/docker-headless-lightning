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
        withCredentials([sshUserPrivateKey(credentialsId: "47e214c3-29c0-49b5-bb72-77d143188c35	", keyFileVariable: "keyfile")]) {
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && docker-compose stop"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && sudo rm -rf $STAGING_DIR/$FILES_DIR"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && sudo cp -r $PROD_DIR/$FILES_DIR $STAGING_DIR/$FILES_DIR"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && sudo chown -R www-data:www-data $STAGING_DIR/$FILES_DIR"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && git stash"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && git pull"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && git stash pop"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && docker-compose start"'
          sh 'ssh -o StrictHostKeyChecking=No -o UserKnownHostsFile=/dev/null -i $keyfile $DEPLOY_USER@$DEPLOY_HOST "cd $STAGING_DIR && ./scripts/main.sh --import-config"'
        }
      }
    }
  }
}
