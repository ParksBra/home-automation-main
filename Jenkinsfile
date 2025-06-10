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
        choice(
            name: 'ACTION',
            choices: ['apply', 'restart', 'destroy'],
            description: 'Select the action to perform'
        )
        string(
            name: 'ANSIBLE_TARGET',
            defaultValue: 'all',
            description: 'Ansible target hosts using ansible -l syntax'
        )
    }

    stages {
        stage('setup-environment') {
            steps {
                echo 'Preparing environment...'
                script {
                    sh 'apt-get update && apt-get install -y python3'
                    sh 'python3 -m venv .venv'
                    sh 'source .venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt'
                }
            }
        }
        stage('ansible-playbook') {
            steps {
                echo 'Running Ansible playbook...'
                script {
                    sh 'source .venv/bin/activate && cd ansible && ansible-playbook playbooks/test.yml -l \'${params.ANSIBLE_TARGET}\''
                }
            }
        }
        stage('cleanup') {
            steps {
                echo 'Cleaning up environment...'
                script {
                    sh 'deactivate && rm -rf .venv'
                }
            }
        }
    }
    post
    {
        success
        {
        echo "${params.STACK_NAME} ${BUILD_TAG} Completed Successfully"
        }
        always
        {
        sh(script: "rm -rf ${env.TF_DIR}/")
        }
    }
}
