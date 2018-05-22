FROM centos:6

ENV DISTR_DIR /distr
WORKDIR $DISTR_DIR

COPY OCPlatform11_2.rsp $DISTR_DIR/


RUN echo Update the image with the latest packages && \
	yum update -y -q && \
	echo Install unzip and wget packages && \
	yum install -y -q unzip wget && \
	yum clean -q all && \
	echo Download Oracle JDK 7u181 and ATG Commerce 11.2 with patch 11.2.0.2 with fixpack 1 && \
    wget -q https://getfile.dokpub.com/yandex/get/https://yadi.sk/d/eN3iXXEh3VaE3i -O jdk-7u181-linux-x64.rpm && \
    wget -q https://getfile.dokpub.com/yandex/get/https://yadi.sk/d/d-InUBZT3VaDu2 -O V78217-01.zip && \
    wget -q https://getfile.dokpub.com/yandex/get/https://yadi.sk/d/BfHLB0Y63VZVJa -O p24950065_112000_Generic.zip && \
    wget -q https://getfile.dokpub.com/yandex/get/https://yadi.sk/d/8_tVHQSw3VaE9R -O p25404313_112020_Generic.zip && \
	echo Install Oracle JDK 7u181, Install ATG Platform with patch 11.2.0.2 with fixpack 1 && \
    rpm -i jdk-7u181-linux-x64.rpm && \
    unzip -q V78217-01.zip && \
    chmod +x OCPlatform11_2.bin && ./OCPlatform11_2.bin -f ./OCPlatform11_2.rsp -i silent && \
    cd /atg/patch/ && unzip -q /distr/p24950065_112000_Generic.zip && cd OCPlatform11.2_p2/ && chmod +x bin/*.sh && echo Y | bin/install.sh && cd .. && rm -rf OCPlatform11.2_p2 && \
    cd /atg/patch/ && unzip -q /distr/p25404313_112020_Generic.zip && cd OCPlatform11.2_p2.1/ && chmod +x bin/*.sh && echo Y | bin/install.sh && cd .. && rm -rf OCPlatform11.2_p2.1 && \
    rm -f $DISTR_DIR/* && \
	echo export DYNAMO_ROOT=/atg >> /etc/profile && \
	echo export JAVA_HOME=/usr/java/latest >> /etc/profile && \
	echo export PATH=\$PATH:\$JAVA_HOME/bin >> /etc/profile

RUN echo Install NodeJS Git Ant SonarQube Scanner and OWASP Dependency Check && \
	curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - && \
    yum install -y -q http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm && \
    yum install -y -q nodejs git && \
    yum clean all && \
    echo NodeJS version $(node -v) && \
    echo Git version $(git --version) && \
    npm i npm@latest -g && \
    echo npm version $(npm -v) && \
    wget -q http://ftp.byfly.by/pub/apache.org//ant/binaries/apache-ant-1.9.11-bin.zip && \
    unzip -q apache-ant-1.9.11-bin.zip && \
	rm -f apache-ant-1.9.11-bin.zip && \
    mv apache-ant-1.9.11 /usr/local/ant && \
	echo export ANT_HOME=/usr/local/ant >> /etc/profile && \
	echo export PATH=\$PATH:\$ANT_HOME/bin >> /etc/profile && \
	wget -q https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.1.0.1141-linux.zip && \
	unzip -q sonar-scanner-cli-3.1.0.1141-linux.zip && \
	rm -f sonar-scanner-cli-3.1.0.1141-linux.zip && \
	mv sonar-scanner-3.1.0.1141-linux /usr/local/sonar-scanner && \
	echo export PATH=\$PATH:/usr/local/sonar-scanner/bin >> /etc/profile && \
    wget -q http://dl.bintray.com/jeremy-long/owasp/dependency-check-3.2.0-release.zip && \
	unzip -q dependency-check-3.2.0-release.zip && \
	rm -f dependency-check-3.2.0-release.zip && \
	mv dependency-check /usr/local/ && \
	echo export PATH=\$PATH:/usr/local/dependency-check/bin >> /etc/profile && \
	source /etc/profile && \
	ant -version && \
	echo $(sonar-scanner -v|grep 'SonarQube Scanner') && \
	dependency-check.sh -v

CMD ["/bin/bash"]