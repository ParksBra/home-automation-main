pipeline {
    agent any
    parameters {
        gitParameter(
            type: 'BRANCH',
            name: 'BRANCH',
            description: 'Choose a branch to checkout',
            branchFilter: 'origin/(.*)',
            defaultValue: 'main',
            selectedValue: 'DEFAULT',
            sortMode: 'DESCENDING_SMART'
        )
    }

    stages {
        stage('preliminary') {
            steps {
                withCredentials('jenkins-primary') {
                    echo 'Preparing environment...'
                    script {
                        python3 '-m venv venv'
                        sh 'source venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt'
                    }
                }
            }
        }
        stage('ansible-playbook') {
            steps {
                withCredentials('jenkins-primary') {
                    echo 'Running Ansible playbook...'
                    script {
                        sh 'source venv/bin/activate && cd ansible && ansible-playbook playbooks/test.yml'
                    }
                }
            }
        }
    }
}
