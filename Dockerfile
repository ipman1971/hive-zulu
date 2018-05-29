FROM ipman1971/hadoop-zulu

MAINTAINER Ipman1971 <ipman1971@gmail.com>

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="hadoop-zulu" \
      org.label-schema.description="Apache Hive" \
      org.label-schema.vcs-url="https://github.com/ipman1971/hive-zulu" \
      org.label-schema.vendor="Ipman1971" \
      org.label-schema.version="1.0.0" \
      com.ipman1971.baseimage-contents='{"contents": [{"name": "hive", "version": "2.3.2"}]}'

ENV HIVE_VERSION 2.3.2
ENV HIVE_HOME /opt/hive
ENV PATH $HIVE_HOME/bin:$PATH

WORKDIR /opt

#Install Hive and PostgreSQL JDBC
RUN set -x && \
    wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    tar xzvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
    mv apache-hive-$HIVE_VERSION-bin hive && \
#    wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar && \
    rm apache-hive-$HIVE_VERSION-bin.tar.gz && \
  	apt-get clean && \
  	rm -rf /var/lib/apt/lists/*

#Custom configuration goes here
ADD config/hive-site.xml $HIVE_HOME/conf
ADD config/hive-env.sh $HIVE_HOME/conf
ADD config/beeline-log4j2.properties $HIVE_HOME/conf
ADD config/hive-exec-log4j2.properties $HIVE_HOME/conf
ADD config/hive-log4j2.properties $HIVE_HOME/conf

EXPOSE 10000
EXPOSE 10002

RUN set -x && \
    $HADOOP_HOME/hadoop-services.sh && \
    hdfs dfs -mkdir /tmp && \
    hdfs dfs -chmod 777 /tmp && \
    hdfs dfs -mkdir -p /user/hive/warehouse && \
    hdfs dfs -chmod g+w /tmp && \
    hdfs dfs -chmod g+w /user/hive/warehouse && \
    schematool -initSchema -dbType derby

#ADD config/beeline-log4j2.properties $HIVE_HOME/conf
#ADD config/hive-exec-log4j2.properties $HIVE_HOME/conf
#ADD config/hive-log4j2.properties $HIVE_HOME/conf
#ADD config/ivysettings.xml $HIVE_HOME/conf
#ADD config/llap-daemon-log4j2.properties $HIVE_HOME/conf

#COPY startup.sh /usr/local/bin/
#RUN chmod +x /usr/local/bin/startup.sh

#COPY entrypoint.sh /usr/local/bin/
#RUN chmod +x /usr/local/bin/entrypoint.sh


#ENTRYPOINT ["entrypoint.sh"]
#CMD /bin/bash
