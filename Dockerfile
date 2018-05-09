FROM centos:6

ENV DISTR_DIR /distr
WORKDIR $DISTR_DIR

COPY OCPlatform11_2.rsp $DISTR_DIR/


# Update the image with the latest packages, install unzip and wget packages
RUN yum update -y && \
	yum install -y unzip wget && \
	yum clean all && \
# Download ATG Commerce 11.2 + patch 11.2.0.2 + fixpack 1 + response file
	wget https://getfile.dokpub.com/yandex/get/https://yadi.sk/d/eN3iXXEh3VaE3i -O jdk-7u181-linux-x64.rpm && \
	wget https://getfile.dokpub.com/yandex/get/https://yadi.sk/d/d-InUBZT3VaDu2 -O V78217-01.zip && \
	wget https://getfile.dokpub.com/yandex/get/https://yadi.sk/d/BfHLB0Y63VZVJa -O p24950065_112000_Generic.zip && \
	wget https://getfile.dokpub.com/yandex/get/https://yadi.sk/d/8_tVHQSw3VaE9R -O p25404313_112020_Generic.zip && \
# Install JDK & Unpack ATG Platform & Install ATG Platform & Install patch 11.2.0.2 & Install 11.2.0.2 fixpack 1
	rpm -ihv jdk-7u181-linux-x64.rpm && \
    unzip V78217-01.zip && \
	chmod +x OCPlatform11_2.bin && ./OCPlatform11_2.bin -f ./OCPlatform11_2.rsp -i silent && \
	cd /atg/patch/ && unzip /distr/p24950065_112000_Generic.zip && cd OCPlatform11.2_p2/ && chmod +x bin/*.sh && echo Y | bin/install.sh && cd .. && rm -rf OCPlatform11.2_p2 && \
	cd /atg/patch/ && unzip /distr/p25404313_112020_Generic.zip && cd OCPlatform11.2_p2.1/ && chmod +x bin/*.sh && echo Y | bin/install.sh && cd .. && rm -rf OCPlatform11.2_p2.1 && \
	rm -f $DISTR_DIR/*

CMD ["/bin/bash"]