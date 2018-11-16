# Perform messages queues systems testing

 1. [Goals](#goals)
 2. [Description](#description)
 3. [Requirements](#requirements)
 4. [Usage](#usage)
    * [Create environment](#create-environment)
    * [Mount Amazon EFS](#mount-amazon-efs)
    * [Install messages queue system](#install-messages-queue-system)
    * [Run the tests](#run-the-tests)
    * [Copy the results](#copy-the-results)
    * [Delete environment](#delete-environment)
    * [Special note for Amazon MQ](#special-note-for-amazon-mq)
 5. [Results](#results)
 6. [Issues](#issues)


## Goals

 Perform messages queues systems testing


## Description

 There a lot of messages queues systems in the market. In order to select a suitable one for our needs we may perform tests which may help us to make an election.

 For this task we will need:
 1. [Environment](#environment)
 2. [Messages queues system](#messages-queues-system)
 3. [Methodology](#methodology)
 4. [Testing tools](#testing-tools)
 5. [Results analysis](#results-analysis)


### Environment

 In order to perform different tests and installations we require an environment. As an easiest solution we may use cloud providers like [AWS](https://aws.amazon.com/).

 In some configuration we may need only VM instances, some configuration may require additional DB instances and in some cases, we may require shared storage like NAS.

 Provided playbooks can provision all mentioned types of resources and this is configured using variables.

 For testing purposes it should be enough to provision resources in one availability zone and without redundancy.

 Currently, we can't just add more resources by changing variables. We should re-create environment from the scratch, with the required parameters. We also may create a new environment by at least modifying `project.name` variable.


### Messages queues system

 Almost all messages queues systems can be used in stand-alone and cluster mode. In order to be able to test highly available configuration we should be able to configure clusters.

 Provided playbook may install the following Message-oriented middleware systems:

| MOM system    | Mode               | Cluster                |
| --------- | ------------------ | ---------------------- |
| [ActiveMQ](http://activemq.apache.org/)  | Standalone/Cluster | JDBC/Shared storage    |
| [Artemis](https://activemq.apache.org/artemis/)   | Standalone         | -                      |
| [RabbitMQ](https://www.rabbitmq.com/)  | Standalone         | -                      |


### Methodology

#### Scenarios

 Two main scenarios are following:
 1. Producer and then consumer - producer send messages and then consumer receive them.
 2. Producer-consumer - producer and consumer working simultaneously.
 > Note: Currently, only scenario 1 was tested.


### Actions

 During the tests the following actions will be done:
 1. Restart messages queue system service every 1 minute.

 > Note: In case of cluster, all mentioned steps should be done on the cluster master.


### Messages

 **Producer** will send messages 5 minutes in 10 threads. It will loop 5 times.  
 **Consumer** will receive all messages in the queue in 10 threads. It will loop 5 times.  
 As a result, we should see 0 remained messages in the queues.


### Testing tools

Currently, as a primary tool for tests [JmsTools suite](https://github.com/erik-wramner/JmsTools) is used. You also may find other tools listed in the [Tools](TOOLS.md).


### Results analysis

 [JmsTools suite](https://github.com/erik-wramner/JmsTools) has LogAnalyser and it should be used for tests logs analysis. Test will be considered as passed when:
  * No lost messages - excluding ones in the DLQ
  * No duplicate messages
  * No ghost messages
  * No alien messages
  * No undead messages

 For more information, please see [Results](#results).



## Requirements

 1. Linux host with [Ansible 2.7 and above installed](https://docs.ansible.com/ansible/devel/installation_guide/intro_installation.html).
 2. Python packages `boto3`, `botocore` and `MySQL-python` installed on Linux host.
 3. AWS account with programmatic access with the following permissions:
    * AmazonVPCFullAccess
    * AmazonEC2FullAccess
    * AmazonRDSFullAccess
    * [AmazonElasticFileSystemFullAccess](https://docs.aws.amazon.com/efs/latest/ug/access-control-managing-permissions.html#access-policy-examples-aws-managed)
 > Note: `MySQL-python` package only required in case of DB usage for ActiveMQ JDBC cluster.


## Usage

### Create environment

 1. Edit variables:
    ```bash
      vi group_vars/all.yml
    ```
     At least pay attention to:
    ```
    project.provision
    aws.region
    aws.ec2.instance.count/type/os
    aws.ec2.instance.vt.list

    aws.rds.instance.type           # when DB is required
    ```

 2. Authenticate on AWS:
    ```bash
    export AWS_ACCESS_KEY_ID="access key"
    export AWS_SECRET_ACCESS_KEY="secret access key"
    export AWS_REGION="region"
    ```

 3. Define variables with sensitive and related to it information, in case of need:
    ```bash
    export aws_rds_master_username="admin"
    export aws_rds_master_user_password="admin_password"
    export aws_rds_db_name="activemq"
    export aws_rds_db_username="activemq"
    export aws_rds_db_user_password="activemq_password"
    ```

 4. Run playbook `create-environment.yml` in order to create environment:
    ```bash
    ansible-playbook create-environment.yml
    ```

 5. In case you specified to create database and shared storage, you will see in the output Amazon RDS endpoint and Amazon EFS filesystem ID.

 6. In case you want to use your own local environment, you can just create an Ansible inventory file `hosts` witch should contain your hosts data:
    ```bash
    [brokers]
    broker-1    ansible_host=3.121.130.85    ansible_user=centos    ansible_ssh_private_key_file=/Users/username/.ssh/messages-brokers-testing.pem
    [tools]
    producer    ansible_host=3.121.130.86    ansible_user=centos    ansible_ssh_private_key_file=/Users/username/.ssh/messages-brokers-testing.pem
    ```
    And go to the next steps.
    > Note: When a default ssh key is used, we may not specify it in the inventory file.


### Mount Amazon EFS

 If you plan to use Amazon EFS for shared storage cluster, before such cluster configuration you should mount EFS on brokers.

 1. Define required variables:
    ```bash
    export efs_fs_id=fs-9470d9cd
    export efs_mount_point=/efs
    ```

 2. Inventory file `hosts`, created on the step above should contain all created hosts data:
    ```bash
    cat hosts
    ```

 3. Run `mount-aws-efs.yml` in order to mount Amazon EFS:
    ```bash
    ansible-playbook mount-aws-efs.yml
    ```
    > Note: By default, Ansible will use `hosts` file as an inventory source and will run play on hosts from `[brokers]` group.


### Install messages queue system

 Now we may proceed with messages queue system installation.

 1. Change variables:
    ```bash
    vi group_vars/all.yml
    ```
    At least pay attention to:
    ```
    # All
    install_folder
    mom
    components version

    # For AMQ
    amq.opts
    amq.mode

    # For Artemis
    artemis.opts
    artemis.mode
    ```

 6. In case of need, you may download and place specific archives in *files* sub-directories of the amq and artemis roles in order to use them instead of the online downloads and you also should change respectively variables in the step above.  
 This may be usefully in case of java, where only latest release may be downloaded without registration.

 7. Define variables with sensitive and related to it information in case of need:
    ```bash
    # AMQ JDBC - required in case of JDBC cluster
    export amq_cluster_jdbc_url="hostname"
    export amq_clister_jdbc_db="activemq"
    export amq_cluster_jdbc_username="activemq"
    export amq_cluster_jdbc_password="activemq_password"

    ## AMQ web console - will be applied only if defined
    export amq_admin_password="admin_password"
    export amq_user_password="user_password"

    # Artemis management console - required
    export artemis_admin_name="admin"
    export artemis_admin_password="admin_password"

    # RabbitMQ management UI - required
    export rmq_admin_name="admin"
    export rmq_admin_password="admin_password"
    ```

 8. Run `install-mom.yml` in order to install MOM system:
    ```bash
    ansible-playbook install-mom.yml
    ```

    In case you need to run playbook among different than `brokers` group from the inventory, you may specify it in the following way:
    ```bash
    ansible-playbook -i hosts install-mom.yml -e "target=tools"
    ```

### Run the tests

#### Scenario 1 - Producer and then consumer

 **Broker**

 On the broker host run the following script to restart queue systemd service every 60 seconds:
```bash
# You may use screen to start script on the host
screen -S restart-broker

# Just uncomment required service name
service=activemq
# service=artemis
# service=rabbitmq-server
interval=60
while :; do
  sudo systemctl restart $service
  sudo systemctl status $service | grep "Active:"
  sleep $interval
done
```

 **Producer and consumer**

 1. Make sure that Java runtime is installed on this host:
    ```bash
    # CentOS
    sudo yum install java
    
    # Ubuntu
    sudo apt install default-jre
    ```

 2. Copy *jmstools* folder to the producer/consumer host.

 3. Edit appropriate script:
    ```bash
    cd jmstools

    vi jmstools-amq.sh
    # vi jmstools-artemis.sh
    # vi jmstools-rmq.sh
    ```
    At least, pay attention to:
    ```bash
    TEST_NAME="Test-ActiveMQ-5.15.7-standalone"
    ITERATIONS=5
    THREADS=10
    DURATION=5
    BROKER_URL="tcp://10.0.30.28:61616"  # amq/artemis
    BROKER_URI="amqp://10.0.30.28:5672"  # rmq

    export JAVA_OPT="-Xms7G -Xmx7G"
    ```

4. Run the tests:
    ```bash
    # You may also use screen to start script on the host
    screen -S producer-consumer

    bash jmstools-amq.sh
    # bash jmstools-artemis.sh
    # bash jmstools-rmq.sh
    ```


### Copy the results

 Scripts from the step above should also create reports using LogAnalyzer. You may find them inside *Reports* sub-directory of the test folder. In case they are created you may copy them or an archived reports folder to your host.

 Sometimes, LogAnalyzer may fail with out of memory. In such case you should copy test folder with logs or an archived test folder to your host in order to analyze them locally.


### Delete environment

 After you have finished your tests and copied all required data, like test reports and logs, you may delete environment.
 1. Run playbook `delete-environment.yml` in order to cleanup environment:
    ```bash
    ansible-playbook delete-environment.yml
    ```


### Special note for Amazon MQ

 Currently, there is no Ansible native support of Amazon MQ. In case you want to test it, you should:

 1. Create producer instance using [Create environment](#create-environment).

 2. Create an Amazon MQ single-instance broker in same VPC and AZ.

 3. Edit and run `reboot-amazon-mq.sh` script on producer in order to make broker inaccessible every 60 seconds. It uses aws cli:
    ```bash
    # Install required packages
    
    # CentOS
    sudo yum install java python-pip screen

    # Ubuntu
    sudo apt update
    sudo apt install default-jre python-pip screen

    # All OS
    pip install awscli
    
    # Authenticate on Amazon
    export AWS_ACCESS_KEY_ID="access key"
    export AWS_SECRET_ACCESS_KEY="secret access key"
    export AWS_DEFAULT_REGION="eu-central-1"

    # Edit reboot script
    vi reboot-amazon-mq.sh

    # You may use screen to start script on the host
    screen -S restart-broker

    # Run reboot script
    bash reboot-amazon-mq.sh
    ```

 4. Edit and run `jmstools-amazon-mq.sh` script on producer/consumer:
    ```bash
    # Edit producer/consumer script
    vi jmstools-amazon-mq.sh

    # You may also use screen to start script on the host
    screen -S producer-consumer

    # Run the test
    bash jmstools-amazon-mq.sh
    ```


## Results

 Please see [Results](RESULTS.md).


## Issues

 The following issues were discovered/confirmed during the tests:
 1. ActiveMQ
    * [AMQ-5238 - Add JDBC Persistence for Scheduler](https://issues.apache.org/jira/browse/AMQ-5238)
    * [AMQ-7096 - ActiveMQ lose messages on broker restarts](https://issues.apache.org/jira/browse/AMQ-7096)

 2. Artemis
    * [ARTEMIS-2173 - Artemis lose messages on broker restarts](https://issues.apache.org/jira/browse/ARTEMIS-2173)

 3. Amazon MQ
    * [Amazon MQ lose messages on broker restarts](https://forums.aws.amazon.com/thread.jspa?threadID=293247&tstart=0)

 4. RabbitMQ
    * [RabbitMQ transactions issues on server restarts](#https://groups.google.com/forum/#!topic/rabbitmq-users/zPrqSY7TSR8)
