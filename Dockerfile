FROM centos:6 AS gradle
ARG GRADLE_VER="6.1.1"
RUN yum install --color=never -y zip unzip java-1.8.0-openjdk && \
    curl -s "https://get.sdkman.io" | bash && \
    source /root/.sdkman/bin/sdkman-init.sh && \
    sdk install gradle ${GRADLE_VER} > /dev/null && \
    gradle -v

FROM centos:6
ARG DISTR_DIR="/distr"
WORKDIR $DISTR_DIR
COPY OCPlatform11_2.rsp $DISTR_DIR/
ARG JDK_VER="7u251"
ARG JDK8_VER="8u241"
ENV JAVA_HOME /usr/java/latest
ENV DYNAMO_ROOT /atg
ENV PES_JAVA_HOME /usr/java/jdk1.7.0_251-amd64

RUN echo Install unzip package && \
    yum install -y -q unzip && \
    yum clean -q all && \
    echo Download Oracle JDK ${JDK_VER} and ATG Commerce 11.2 with patch 11.2.0.2 with fixpack 1 && \
    curl -sSk -O -L https://touch.epm-esp.projects.epam.com/static-files/oracle-java/jdk-${JDK_VER}-linux-x64.rpm && \
    curl -sSk -O -L https://touch.epm-esp.projects.epam.com/static-files/oracle-commerce-suite/commerce/ATG11.2/ATG11.2/V78217-01.zip && \
    curl -sSk -O -L https://touch.epm-esp.projects.epam.com/static-files/oracle-commerce-suite/commerce/ATG11.2/ATG11.2_patch/p24950065_112000_Generic.zip && \
    curl -sSk -O -L https://touch.epm-esp.projects.epam.com/static-files/oracle-commerce-suite/commerce/ATG11.2/ATG11.2_patch/p25404313_112020_Generic.zip && \
    echo Install Oracle JDK ${JDK_VER} and ATG Platform with patch 11.2.0.2 with fixpack 1 && \
    rpm -i jdk-${JDK_VER}-linux-x64.rpm && \
    java -version && \
    unzip -q V78217-01.zip && \
    chmod +x OCPlatform11_2.bin && ./OCPlatform11_2.bin -f ./OCPlatform11_2.rsp -i silent && \
    cd ${DYNAMO_ROOT}/patch/ && unzip -q $DISTR_DIR/p24950065_112000_Generic.zip && cd OCPlatform11.2_p2/ && chmod +x bin/*.sh && echo Y | bin/install.sh && cd .. && rm -rf OCPlatform11.2_p2 && \
    cd ${DYNAMO_ROOT}/patch/ && unzip -q $DISTR_DIR/p25404313_112020_Generic.zip && cd OCPlatform11.2_p2.1/ && chmod +x bin/*.sh && echo Y | bin/install.sh && cd .. && rm -rf OCPlatform11.2_p2.1 && \
    cd $DISTR_DIR && \
    echo Install Oracle JDK $JDK8_VER && \
    curl -sSk -O -L https://touch.epm-esp.projects.epam.com/static-files/oracle-java/jdk-${JDK8_VER}-linux-x64.rpm && \
    rpm -i jdk-${JDK8_VER}-linux-x64.rpm && \
    java -version && \
    rm -f $DISTR_DIR/* && \
    echo export JAVA_HOME=${JAVA_HOME} >> /etc/profile && \
    echo export PATH=\$PATH:\$JAVA_HOME/bin >> /etc/profile

ARG ANT_VER="1.9.14"
ENV ANT_HOME /usr/local/ant
ARG SONAR_SCANNER_VER="4.2.0.1873"
ARG GRADLE_VER="6.1.1"
ENV GRADLE_HOME /opt/gradle

COPY --from=gradle /root/.sdkman/candidates/gradle/${GRADLE_VER} /opt/gradle
RUN echo Install NodeJS, Git, Ant, Gradle, SonarQube Scanner and OWASP Dependency Check && \
    curl -sS -L https://rpm.nodesource.com/setup_10.x | bash - && \
    yum install -y -q http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm && \
    yum install -y -q nodejs git zip && \
    yum clean all && \
    echo NodeJS version $(node -v) && \
    echo Git version $(git --version) && \
    npm i npm@latest -g && \
    echo npm version $(npm -v) && \
    curl -sS -O -L http://ftp.byfly.by/pub/apache.org/ant/binaries/apache-ant-${ANT_VER}-bin.zip && \
    unzip -q apache-ant-${ANT_VER}-bin.zip && \
    rm -f apache-ant-${ANT_VER}-bin.zip && \
    mv apache-ant-${ANT_VER} ${ANT_HOME} && \
    echo export ANT_HOME=${ANT_HOME} >> /etc/profile && \
    echo export PATH=\$PATH:\$ANT_HOME/bin >> /etc/profile && \
    curl -sSk -O -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VER}-linux.zip && \
    unzip -q sonar-scanner-cli-${SONAR_SCANNER_VER}-linux.zip && \
    rm -f sonar-scanner-cli-${SONAR_SCANNER_VER}-linux.zip && \
    mv sonar-scanner-${SONAR_SCANNER_VER}-linux /usr/local/sonar-scanner && \
    echo export PATH=\$PATH:/usr/local/sonar-scanner/bin >> /etc/profile && \
    echo setup gradle && \
    echo export GRADLE_HOME=${GRADLE_HOME} >> /etc/profile && \
    echo export PATH=\$PATH:\$GRADLE_HOME/bin >> /etc/profile && \
    source /etc/profile && \
    ant -version && \
    gradle -v && \
    echo $(sonar-scanner -v|grep 'SonarQube Scanner') && \
    rm -rf $DISTR_DIR/*

CMD ["/bin/bash"]
