#!/usr/bin/env bash

# Start test time tracking
TEST_START_TIME=$SECONDS

# Define variables
NOW="$(date +%Y%m%d-%H%M%S)"
TEST_NAME="Test-ActiveMQ-5.15.7-standalone"
ITERATIONS=5
THREADS=10
DURATION=5
BROKER_URL="tcp://10.0.30.28:61616"
CONSUMER_TIMEOUT=30000
QUEUE="Test-$NOW"

TEST_FOLDER="$TEST_NAME-$NOW"
LOGS_FOLDER="Logs"
REPORTS_FOLDER="Reports"
REPORT_PREFIX="Report"
LOGS_PATH="$TEST_FOLDER/$LOGS_FOLDER"
REPORTS_PATH="$TEST_FOLDER/$REPORTS_FOLDER"
TEST_LOG="$REPORTS_PATH/Test-$NOW.log"

PRODUCER="AmqJmsProducer.jar"
CONSUMER="AmqJmsConsumer.jar"
LOGANALYZER="LogAnalyzer.jar"
LOGANALYZER_TEMPLATE="correctness_test_report_summary_table.html"

export PATH="/opt/java/bin:$PATH"
export JAVA_OPT="-Xms7G -Xmx7G"


# Create folders
mkdir -p "$LOGS_PATH"
mkdir -p "$REPORTS_PATH"

# Log test start into the test log
echo "Test started - $(date +%Y-%m-%d' - '%H-%M-%S)" > "$TEST_LOG"

# Run tests in an loop
for i in $(seq $ITERATIONS)
do
  # Start iteration time tracking
  iteration_start_time=$SECONDS

  # Create log folder for iteration
  mkdir "$LOGS_PATH"/"$i"

  # Run Producer
  echo "Start Producer ..."
  java $JAVA_OPT -jar "$PRODUCER" \
  -url "$BROKER_URL" \
  -log "$LOGS_PATH"/"$i" \
  -t "$THREADS" \
  -duration "$DURATION" \
  -id \
  -type TEXT \
  -queue "$QUEUE"-"$i"

  # Run Consumer
  echo "Start Consumer..."
  java $JAVA_OPT -jar "$CONSUMER" \
  -url "$BROKER_URL" \
  -log "$LOGS_PATH"/"$i" \
  -timeout "$CONSUMER_TIMEOUT" \
  -t "$THREADS" \
  -verify \
  -drain \
  -queue "$QUEUE"-"$i"

  # Create report
  echo "Run LogAnalyzer..."
  java $JAVA_OPT -jar "$LOGANALYZER" -o "$REPORTS_PATH"/"$REPORT_PREFIX"-"$NOW"-"$i".html -t "$LOGANALYZER_TEMPLATE" "$LOGS_PATH"/"$i"

  # Finish iteration time tracking
  iteration_elapsed_time="$(($SECONDS - $iteration_start_time))"
  iteration_duration="$(date -d@$iteration_elapsed_time -u +%H:%M:%S)"

  # Log iteration duration into the test log
  echo "  Iteration $i duration: $iteration_duration" >> "$TEST_LOG"
done

# Copy debug ans stats to the test folder
mv debug.log "$TEST_FOLDER"
mv stats.log "$TEST_FOLDER"

# Finish test time tracking
TEST_ELAPSED_TIME="$(($SECONDS - $TEST_START_TIME))"
test_duration="$(date -d@$TEST_ELAPSED_TIME -u +%H:%M:%S)"

# Log test finish and duration into the test log
echo "Test finished - $(date +%Y-%m-%d' - '%H-%M-%S)" >> "$TEST_LOG"
echo "  $test_duration" >> "$TEST_LOG"

# Create logs and reports archives
# tar -zcvf "$TEST_FOLDER"-"$LOGS_FOLDER".tar.gz "$LOGS_PATH"
tar -zcvf "$TEST_FOLDER"-"$REPORTS_FOLDER".tar.gz "$REPORTS_PATH"
tar -zcvf "$TEST_FOLDER".tar.gz "$TEST_FOLDER"
