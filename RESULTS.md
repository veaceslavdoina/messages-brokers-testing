# Tests results

 1. [ActiveMQ](#activemq)
 2. [Artemis](#artemis)
 3. [RabbitMQ](#rabbitmq)
 4. [Amazon MQ](#amazon-mq)

 **Hardware**

| Type              | Instance  | Characteristics |
| ----------------- | --------- | --------------- |
| Broker            | m5.large  | 2vCPU / 8GiB    |
| Producer/Consumer | t3.large  | 2vCPU / 8GiB    |

----
 From the JmsTools report:

 This part focuses on correctness. It is only valid for tests performed with the tools and with the id option enabled. The goal is to ensure that the messaging platform delivers every message exactly once.

 A **lost message** is, well, gone. Sent but not received. It may be truly lost, it may have been moved to a dead letter queue or the id property may have been lost. Without the id property the message becomes an alien.

 A **duplicate message** has been delivered and (more importantly) committed by the consumer at least twice.

 In **doubt messages** are messages that may have been committed or rolled back or that may be stuck in prepared state. With normal transactions this state is used when the tool has tried to commit but failed. If the failure is due to a broker crash or network failure it is not clear if the problem happened before or after the message was committed on the server. For two phase transactions there are a wide range of errors that leave messages in doubt. In all cases in doubt transactions require more analysis.

 A **ghost message** has been sent, rolled back, but was delivered anyway. For explicit rollbacks (using the rollback option) that is very serious as it means that transactions are broken. There may be rollbacks caused by lost connections or other technical issues where a message has been committed but where the tool assumed it had been rolled back. Normally those messages should be listed as in doubt, but they may end up here.

 An **alien message** is a message without the properties set by the producer. In a correctness test where the consumer is used with the producer and with the id property set, there should be none. For a performance test where messages are generated without the id property they are normal.

 An **undead message** has never been sent, but yet it is not alien. Most likely a log file from another test has been imported, but it is also possible that a message got through without being logged when a producer was killed. That may be correct, or it may be problematic. If there are unexplained undead messages present, keep testing and find out why.


## ActiveMQ

 1. [Test-ActiveMQ-5.15.7-standalone-20181110-143604](#test-activemq-5157-standalone-20181110-143604)
 2. [Test-ActiveMQ-5.15.7-standalone-xa-20181114-090010](#test-activemq-5157-standalone-xa-20181114-090010)


### Test-ActiveMQ-5.15.7-standalone-20181110-143604

 **Scenario 1** - Producer and then consumer

| [Statistic](results/Test-ActiveMQ-5.15.7-standalone-20181110-143604/Reports)              | [Test 1](results/Test-ActiveMQ-5.15.7-standalone-20181110-143604/Reports/Report-20181110-143604-1.html)   | [Test 2](results/Test-ActiveMQ-5.15.7-standalone-20181110-143604/Reports/Report-20181110-143604-2.html)   | [Test 3](results/Test-ActiveMQ-5.15.7-standalone-20181110-143604/Reports/Report-20181110-143604-3.html)   | [Test 4](results/Test-ActiveMQ-5.15.7-standalone-20181110-143604/Reports/Report-20181110-143604-4.html)   | [Test 5](results/Test-ActiveMQ-5.15.7-standalone-20181110-143604/Reports/Report-20181110-143604-5.html)   |
| ----------------------------- | -------- | --------- | --------- | --------- | -------- |
| Test duration                 | 00:13:15 | 00:14:48  | 00:15:07  | 00:14:32  | 00:14:37 |
| Producing duration            | 00:05:00 | 00:05:00  | 00:05:00  | 00:05:00  | 00:05:00 |
| Produced with roll-back       | 872,373  | 1,037,117 | 1,043,444 | 1,003,151 | 992,479  |
| Consumed with roll-back       | 872,367  | 1,037,112 | 1,043,441 | 1,003,145 | 992,482  |
| Rolled-back produced          | 30       | 30        | 30        | 40        | 30       |
| Rolled-back consumed          | 20       | 30        | 30        | 20        | 30       |
| Messages produced             | 872,343  | 1,037,087 | 1,043,414 | 1,003,111 | 992,449  |
| Messages consumed             | 872,347  | 1,037,082 | 1,043,411 | 1,003,125 | 992,452  |
| Difference                    | -4       | 5         | 3         | -14       | -3       |
| Lost messages                 | 17       | 24        | 26        | 13        | 21       |
| Duplicate messages            | 0        | 0         | 0         | 0         | 0        |
| Ghost messages                | 21       | 19        | 23        | 27        | 24       |
| Alien messages                | 0        | 0         | 0         | 0         | 0        |
| Undead messages               | 0        | 0         | 0         | 0         | 0        |
| Messages remained             | 0        | 0         | 0         | 0         | 0        |
| Messages in DLQ               | 0        | 0         | 0         | 0         | 0        |
| Produced messages size        | 3,96 GB  | 4,71 GB   | 4,73 GB   | 4,56 GB   | 4,50 GB  |
| Max Produced Message Size     | 8,053 B  | 8,053 B   | 8,053 B   | 8,053 B   | 8,053 B  |
| Average Produced Message Size | 4,540 B  | 4,538 B   | 4,537 B   | 4,541 B   | 4,538 B  |
| Min Produced Message Size     | 1,024 B  | 1,024 B   | 1,024 B   | 1,024 B   | 1,024 B  |


### Test-ActiveMQ-5.15.7-standalone-xa-20181114-090010

 **Scenario 1** - Producer and then consumer

| [Statistic](results/Test-ActiveMQ-5.15.7-standalone-xa-20181114-090010/Reports)              | [Test 1](results/Test-ActiveMQ-5.15.7-standalone-xa-20181114-090010/Reports/Report-20181114-090010-1.html)   | [Test 2](results/Test-ActiveMQ-5.15.7-standalone-xa-20181114-090010/Reports/Report-20181114-090010-2.html)   | [Test 3](results/Test-ActiveMQ-5.15.7-standalone-xa-20181114-090010/Reports/Report-20181114-090010-3.html)   | [Test 4](results/Test-ActiveMQ-5.15.7-standalone-xa-20181114-090010/Reports/Report-20181114-090010-4.html)   | [Test 5](results/Test-ActiveMQ-5.15.7-standalone-xa-20181114-090010/Reports/Report-20181114-090010-5.html)   |
| ----------------------------- | -------- | --------- | --------- | --------- | -------- |
| Test duration                 | 01:45:07 | 00:43:46  | 00:25:06  | 00:23:03  | 01:02:26 |
| Producing duration            | 00:05:00 | 00:05:00  | 00:05:00  | 00:05:00  | 00:05:00 |
| Produced with roll-back       | 249,259  | 221,684   | 313,271   | 263,019   | 206,451  |
| Consumed with roll-back       | 249,471  | 221,750   | 313,278   | 263,028   | 206,546  |
| Rolled-back produced          | 0        | 0         | 0         | 0         | 0        |
| Rolled-back consumed          | 0        | 0         | 0         | 0         | 0        |
| Messages produced             | 249,259  | 221,684   | 313,271   | 263,019   | 206,451  |
| Messages consumed             | 249,471  | 221,750   | 313,278   | 263,028   | 206,546  |
| Difference                    | -212     | -66       | -7        | -9        | -95      |
| Lost messages                 | 671      | 222       | 92        | 87        | 378      |
| Duplicate messages            | 0        | 0         | 0         | 0         | 0        |
| Ghost messages                | 0        | 0         | 0         | 0         | 0        |
| Alien messages                | 0        | 0         | 0         | 0         | 0        |
| Undead messages               | 0        | 0         | 0         | 0         | 0        |
| Messages remained             | 0        | 0         | 0         | 0         | 0        |
| Messages in DLQ               | 0        | 0         | 0         | 0         | 0        |
| Produced messages size        | 1,13 GB  | 1,01 GB   | 1,42 GB   | 1,20 GB   | 0,94 GB  |
| Max Produced Message Size     | 8,053 B  | 8,053 B   | 8,053 B   | 8,053 B   | 8,053 B  |
| Average Produced Message Size | 4,539 B  | 4,545 B   | 4,537 B   | 4,539 B   | 4,541 B  |
| Min Produced Message Size     | 1,024 B  | 1,024 B   | 1,024 B   | 1,024 B   | 1,024 B  |


## Artemis

 1. [Test-Artemis-2.6.3-standalone-20181110-160908](#test-artemis-263-standalone-20181110-160908)
 2. [Test-Artemis-2.6.3-standalone-local-20181112-172958](#test-artemis-263-standalone-local-20181112-172958)


### Test-Artemis-2.6.3-standalone-20181110-160908

 **Scenario 1** - Producer and then consumer

| [Statistic](results/Test-Artemis-2.6.3-standalone-20181110-160908/Reports)              | [Test 1](results/Test-Artemis-2.6.3-standalone-20181110-160908/Reports/Report-20181110-160908-1.html)   | [Test 2](results/Test-Artemis-2.6.3-standalone-20181110-160908/Reports/Report-20181110-160908-2.html)   | [Test 3](results/Test-Artemis-2.6.3-standalone-20181110-160908/Reports/Report-20181110-160908-3.html)   | [Test 4](results/Test-Artemis-2.6.3-standalone-20181110-160908/Reports/Report-20181110-160908-4.html)   | [Test 5](results/Test-Artemis-2.6.3-standalone-20181110-160908/Reports/Report-20181110-160908-5.html)   |
| ----------------------------- | -------- | -------- | -------- | -------- | -------- |
| Test duration                 | 00:10:51 | 00:10:30 | 00:09:40 | 00:11:31 | 00:10:19 |
| Producing duration            | 00:05:00 | 00:05:00 | 00:05:00 | 00:05:00 | 00:05:00 |
| Produced with roll-back       | 379,414  | 392,794  | 369,466  | 394,289  | 374,353  |
| Consumed with roll-back       | 379,399  | 392,827  | 369,481  | 394,296  | 374,340  |
| Rolled-back produced          | 50       | 50       | 49       | 40       | 50       |
| Rolled-back consumed          | 30       | 30       | 30       | 40       | 30       |
| Messages produced             | 379,364  | 392,744  | 369,417  | 394,249  | 374,303  |
| Messages consumed             | 379,369  | 392,797  | 369,451  | 394,256  | 374,310  |
| Difference                    | -5       | -53      | -34      | -7       | -7       |
| Lost messages                 | 0        | 0        | 3        | 9        | 17       |
| Duplicate messages            | 2        | 41       | 28       | 2        | 11       |
| Ghost messages                | 3        | 12       | 9        | 14       | 13       |
| Alien messages                | 0        | 0        | 0        | 0        | 0        |
| Undead messages               | 0        | 0        | 0        | 0        | 0        |
| Messages remained             | 0        | 0        | 0        | 0        | 0        |
| Messages in DLQ               | 0        | 0        | 0        | 0        | 0        |
| Produced messages size        | 1,72 GB  | 1,78 GB  | 1,68 GB  | 1,79 GB  | 1,70 GB  |
| Max Produced Message Size     | 8,053 B  | 8,053 B  | 8,053 B  | 8,053 B  | 8,053 B  |
| Average Produced Message Size | 4,539 B  | 4,535 B  | 4,542 B  | 4,534 B  | 4,536 B  |
| Min Produced Message Size     | 1,024 B  | 1,024 B  | 1,024 B  | 1,024 B  | 1,024 B  |


### Test-Artemis-2.6.3-standalone-local-20181112-172958

 **Scenario 1** - Producer and then consumer

| [Statistic](results/Test-Artemis-2.6.3-standalone-local-20181112-172958/Reports)              | [Test 1](results/Test-Artemis-2.6.3-standalone-local-20181112-172958/Reports/Report-20181112-172958-1.html)   | [Test 2](results/Test-Artemis-2.6.3-standalone-local-20181112-172958/Reports/Report-20181112-172958-2.html)   | [Test 3](results/Test-Artemis-2.6.3-standalone-local-20181112-172958/Reports/Report-20181112-172958-3.html)   | [Test 4](results/Test-Artemis-2.6.3-standalone-local-20181112-172958/Reports/Report-20181112-172958-4.html)   | [Test 5](results/Test-Artemis-2.6.3-standalone-local-20181112-172958/Reports/Report-20181112-172958-5.html)   |
| ----------------------------- | -------- | -------- | -------- | -------- | -------- |
| Test duration                 | 00:11:45 | 00:11:11 | 00:12:43 | 00:11:51 | 00:11:39 |
| Producing duration            | 00:05:00 | 00:05:00 | 00:05:00 | 00:05:00 | 00:05:00 |
| Produced with roll-back       | 484,479  | 538,971  | 580,061  | 568,133  | 530,461  |
| Consumed with roll-back       | 484,516  | 538,952  | 580,477  | 568,370  | 530,760  |
| Rolled-back produced          | 40       | 50       | 40       | 49       | 50       |
| Rolled-back consumed          | 40       | 30       | 49       | 30       | 40       |
| Messages produced             | 484,439  | 538,921  | 580,021  | 568,084  | 530,411  |
| Messages consumed             | 484,476  | 538,922  | 580,428  | 568,340  | 530,720  |
| Difference                    | -37      | -1       | -407     | -256     | -309     |
| Lost messages                 | 8        | 0        | 5        | 0        | 2        |
| Duplicate messages            | 44       | 0        | 411      | 255      | 310      |
| Ghost messages                | 1        | 1        | 1        | 0        | 1        |
| Alien messages                | 0        | 0        | 0        | 1        | 0        |
| Undead messages               | 0        | 0        | 0        | 0        | 0        |
| Messages remained             | 0        | 0        | 0        | 0        | 0        |
| Messages in DLQ               | 0        | 0        | 0        | 0        | 0        |
| Produced messages size        | 2,20 GB  | 2,44 GB  | 2,63 GB  | 2,58 GB  | 2,41 GB  |
| Max Produced Message Size     | 8,053 B  | 8,053 B  | 8,053 B  | 8,053 B  | 8,053 B  |
| Average Produced Message Size | 4,541 B  | 4,536 B  | 4,540 B  | 4,535 B  | 4,540 B  |
| Min Produced Message Size     | 1,024 B  | 1,024 B  | 1,024 B  | 1,024 B  | 1,024 B  |

 > Note: For this test a single instance for broker and producer/consumer was used. All communications were done using localhost.


## RabbitMQ

 1. [Test-RabbitMQ-3.7.8-standalone-20181110-173120](#test-rabbitmq-378-standalone-20181110-173120)
 2. [Test-RabbitMQ-3.7.8-standalone-20181117-173201](#test-rabbitmq-378-standalone-20181117-173201)


### Test-RabbitMQ-3.7.8-standalone-20181110-173120

 **Scenario 1** - Producer and then consumer

| [Statistic](results/Test-RabbitMQ-3.7.8-standalone-20181110-173120/Reports)              | [Test 1](results/Test-RabbitMQ-3.7.8-standalone-20181110-173120/Reports/Report-20181110-173120-1.html)   | [Test 2](results/Test-RabbitMQ-3.7.8-standalone-20181110-173120/Reports/Report-20181110-173120-2.html)   | [Test 3](results/Test-RabbitMQ-3.7.8-standalone-20181110-173120/Reports/Report-20181110-173120-3.html)   | [Test 4](results/Test-RabbitMQ-3.7.8-standalone-20181110-173120/Reports/Report-20181110-173120-4.html)   | [Test 5](results/Test-RabbitMQ-3.7.8-standalone-20181110-173120/Reports/Report-20181110-173120-5.html)   |
| ----------------------------- | -------- | -------- | -------- | -------- | -------- |
| Test duration                 | 00:10:01 | 00:09:33 | 00:09:57 | 00:09:43 | 00:10:02 |
| Producing duration            | 00:05:00 | 00:05:00 | 00:05:00 | 00:05:00 | 00:05:00 |
| Produced with roll-back       | 552,462  | 522,309  | 551,249  | 542,305  | 556,213  |
| Consumed with roll-back       | 552,469  | 522,292  | 551,252  | 542,288  | 556,212  |
| Rolled-back produced          | 40       | 50       | 40       | 50       | 40       |
| Rolled-back consumed          | 20       | 9        | 13       | 10       | 18       |
| Messages produced             | 552,422  | 522,259  | 551,209  | 542,255  | 556,173  |
| Messages consumed             | 552,449  | 522,283  | 551,239  | 542,278  | 556,194  |
| Difference                    | -27      | -24      | -30      | -23      | -21      |
| Lost messages                 | 0        | 0        | 0        | 0        | 0        |
| Duplicate messages            | 0        | 0        | 0        | 0        | 0        |
| Ghost messages                | 27       | 24       | 30       | 23       | 21       |
| Alien messages                | 0        | 0        | 0        | 0        | 0        |
| Undead messages               | 0        | 0        | 0        | 0        | 0        |
| Messages remained             | 0        | 0        | 0        | 0        | 0        |
| Messages in DLQ               | 0        | 0        | 0        | 0        | 0        |
| Produced messages size        | 2,51 GB  | 2,37 GB  | 2,50 GB  | 2,46 GB  | 2,52 GB  |
| Max Produced Message Size     | 8,053 B  | 8,053 B  | 8,053 B  | 8,053 B  | 8,053 B  |
| Average Produced Message Size | 4,536 B  | 4,538 B  | 4,538 B  | 4,538 B  | 4,537 B  |
| Min Produced Message Size     | 1,024 B  | 1,024 B  | 1,024 B  | 1,024 B  | 1,024 B  |


### Test-RabbitMQ-3.7.8-standalone-20181117-173201

 **Scenario 1** - Producer and then consumer

| [Statistic](results/Test-RabbitMQ-3.7.8-standalone-20181117-173201/Reports)              | [Test 1](results/Test-RabbitMQ-3.7.8-standalone-20181117-173201/Reports/Report-20181117-173201-1.html)   | [Test 2](results/Test-RabbitMQ-3.7.8-standalone-20181117-173201/Reports/Report-20181117-173201-2.html)   | [Test 3](results/Test-RabbitMQ-3.7.8-standalone-20181117-173201/Reports/Report-20181117-173201-3.html)   | [Test 4](results/Test-RabbitMQ-3.7.8-standalone-20181117-173201/Reports/Report-20181117-173201-4.html)   | [Test 5](results/Test-RabbitMQ-3.7.8-standalone-20181117-173201/Reports/Report-20181117-173201-5.html)   |
| ----------------------------- | -------- | -------- | -------- | -------- | -------- |
| Test duration                 | 00:08:58 | 00:09:39 | 00:09:04 | 00:09:20 | 00:09:40 |
| Producing duration            | 00:05:00 | 00:05:00 | 00:05:00 | 00:05:00 | 00:05:00 |
| Produced with roll-back       | 497,619  | 522,818  | 522,206  | 535,349  | 539,047  |
| Consumed with roll-back       | 497,617  | 522,826  | 522,196  | 535,355  | 539,046  |
| Rolled-back produced          | 0        | 0        | 0        | 0        | 0        |
| Rolled-back consumed          | 0        | 0        | 0        | 0        | 0        |
| In doubt produced             | 40       | 40       | 50       | 40       | 40       |
| In doubt consumed             | 19       | 15       | 10       | 18       | 20       |
| Messages produced             | 497,579  | 522,778  | 522,156  | 535,309  | 539,007  |
| Messages consumed             | 497,598  | 522,811  | 522,186  | 535,337  | 539,026  |
| Difference                    | -19      | -33      | -30      | -28      | -19      |
| Lost messages                 | 0        | 0        | 0        | 0        | 0        |
| Duplicate messages            | 0        | 0        | 0        | 0        | 0        |
| Ghost messages                | 0        | 0        | 0        | 0        | 0        |
| Alien messages                | 0        | 0        | 0        | 0        | 0        |
| Undead messages               | 0        | 0        | 0        | 0        | 0        |
| Messages remained             | 0        | 0        | 0        | 0        | 0        |
| Messages in DLQ               | 0        | 0        | 0        | 0        | 0        |
| Produced messages size        | 2,26 GB  | 2,37 GB  | 2,37 GB  | 2,43 GB  | 2,44 GB  |
| Max Produced Message Size     | 8,053 B  | 8,053 B  | 8,053 B  | 8,053 B  | 8,053 B  |
| Average Produced Message Size | 4,536 B  | 4,539 B  | 4,539 B  | 4,538 B  | 4,536 B  |
| Min Produced Message Size     | 1,024 B  | 1,024 B  | 1,024 B  | 1,024 B  | 1,024 B  |
| Produced average TPS          | 1,658    | 1,742    | 1,770    | 1,784    | 1,796    |
| Consumed average TPS          | 4,364    | 4,116    | 4,835    | 4,248    | 4,382    |


## Amazon MQ

 1. [Test-Amazon-MQ-5.15.6-standalone-20181110-185232](#test-amazon-mq-5156-standalone-20181110-185232)


### Test-Amazon-MQ-5.15.6-standalone-20181110-185232

 **Scenario 1** - Producer and then consumer

| [Statistics](results/Test-Amazon-MQ-5.15.6-standalone-20181110-185232/Reports)              | [Test 1](results/Test-Amazon-MQ-5.15.6-standalone-20181110-185232/Reports/Report-20181110-185232-1.html)   | [Test 2](results/Test-Amazon-MQ-5.15.6-standalone-20181110-185232/Reports/Report-20181110-185232-2.html)   | [Test 3](results/Test-Amazon-MQ-5.15.6-standalone-20181110-185232/Reports/Report-20181110-185232-3.html)   | [Test 4](results/Test-Amazon-MQ-5.15.6-standalone-20181110-185232/Reports/Report-20181110-185232-4.html)   | [Test 5](results/Test-Amazon-MQ-5.15.6-standalone-20181110-185232/Reports/Report-20181110-185232-5.html)   |
| ----------------------------- | -------- | -------- | -------- | -------- | -------- |
| Test duration                 | 00:11:09 | 00:11:16 | 00:10:40 | 00:09:39 | 00:10:20 |
| Producing duration            | 00:05:00 | 00:05:00 | 00:05:00 | 00:05:00 | 00:05:00 |
| Produced with roll-back       | 68,703   | 59,283   | 52,382   | 55,671   | 53,224   |
| Consumed with roll-back       | 68,703   | 59,283   | 52,382   | 55,671   | 53,224   |
| Rolled-back produced          | 10       | 10       | 20       | 20       | 10       |
| Rolled-back consumed          | 20       | 20       | 10       | 10       | 10       |
| Messages produced             | 68,693   | 59,273   | 52,362   | 55,651   | 53,214   |
| Messages consumed             | 68,683   | 59,263   | 52,372   | 55,661   | 53,214   |
| Difference                    | 10       | 10       | -10      | -10      | 0        |
| Lost messages                 | 20       | 20       | 10       | 10       | 10       |
| Duplicate messages            | 0        | 0        | 0        | 0        | 0        |
| Ghost messages                | 10       | 10       | 20       | 20       | 10       |
| Alien messages                | 0        | 0        | 0        | 0        | 0        |
| Undead messages               | 0        | 0        | 0        | 0        | 0        |
| Messages remained             | 0        | 0        | 0        | 0        | 0        |
| Messages in DLQ               | 0        | 0        | 0        | 0        | 0        |
| Produced messages size        | 0,31 GB  | 0,27 GB  | 0,24 GB  | 0,25 GB  | 0,24 GB  |
| Max Produced Message Size     | 8,053 B  | 8,053 B  | 8,053 B  | 8,053 B  | 8,053 B  |
| Average Produced Message Size | 4,538 B  | 4,533 B  | 4,539 B  | 4,550 B  | 4,521 B  |
| Min Produced Message Size     | 1,024 B  | 1,024 B  | 1,024 B  | 1,024 B  | 1,024 B  |
