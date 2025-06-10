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
        stage('setup-environment') {
            steps {
                echo 'Preparing environment...'
                script {
                    sh 'python3 -m venv .venv'
                    sh 'source .venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt'
                }
            }
        }
        stage('ansible-playbook') {
            steps {
                echo 'Running Ansible playbook...'
                script {
                    sh 'source .venv/bin/activate && cd ansible && ansible-playbook playbooks/test.yml'
                }
            }
        }
    }
}
