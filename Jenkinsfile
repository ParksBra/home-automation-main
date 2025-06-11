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
        string(
            name: 'SSH_KEY',
            defaultValue: 'ansible-ssh-key',
            description: 'Name of stored SSH key secret file for accessing the target servers'
        )
        string(
            name: 'ANSIBLE_TARGET',
            defaultValue: 'all',
            description: 'Ansible target hosts using ansible -l syntax'
        )
        booleanParam(
            name: 'FORCE_CONTAINER_RECREATE',
            defaultValue: false,
            description: 'Force recreation of Docker containers'
        )
    }
    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('setup-environment') {
            steps {
                echo 'Preparing environment...'
                script {
                    sh 'python3 -m venv .venv'
                    sh '.venv/bin/pip install --upgrade pip && .venv/bin/pip install -r requirements.txt'
                }
            }
        }
        stage('make-server') {
            steps {
                withCredentials([file(credentialsId: params.SSH_KEY, variable: 'ssh_key_file')]) {
                    echo 'Running make_server Ansible playbook...'
                    script {
                        sh ".venv/bin/ansible-playbook 'ansible/playbooks/make_server.yml' -l '${params.ANSIBLE_TARGET}' --private-key '${ssh_key_file}'"
                    }
                }
            }
        }
        stage('apply-docker-compose') {
            steps {
                withCredentials([file(credentialsId: params.SSH_KEY, variable: 'ssh_key_file')]) {
                    echo 'Running apply_docker Ansible playbook...'
                    script {
                        sh ".venv/bin/ansible-playbook 'ansible/playbooks/apply_docker.yml' -l '${params.ANSIBLE_TARGET}' --private-key '${ssh_key_file}' --extra-vars 'force_container_recreate=${params.FORCE_CONTAINER_RECREATE}'"
                    }
                }
            }
        }
        stage('apply-configurations') {
            steps {
                withCredentials([file(credentialsId: params.SSH_KEY, variable: 'ssh_key_file')]) {
                    echo 'Running apply_configurations Ansible playbook...'
                    script {
                        sh ".venv/bin/ansible-playbook 'ansible/playbooks/apply_configurations.yml' -l '${params.ANSIBLE_TARGET}' --private-key '${ssh_key_file}'"
                    }
                }
            }
        }
    }
    // Post work actions
    post {
        success {
            echo "${params.STACK_NAME} ${BUILD_TAG} Completed Successfully"
        }
        always {
            sh(script: "rm -rf ${env.TF_DIR}/")
        }
    }
}
