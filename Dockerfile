FROM centos:6

# Update the image with the latest packages and install unzip package
RUN yum update -y && yum install -y unzip && yum clean all

ENV DISTR_DIR /distr

WORKDIR $DISTR_DIR
# Copy ATG Commerce 11.2 + patch 11.2.0.2 + fixpack 1 + response file
COPY *.zip OCPlatform11_2.rsp jdk-7u181-linux-x64.rpm $DISTR_DIR/

# Install JDK & Unpack ATG Platform & Install ATG Platform & Install patch 11.2.0.2 & Install 11.2.0.2 fixpack 1
RUN rpm -ihv jdk-7u181-linux-x64.rpm && \
    unzip V78217-01.zip && \
	chmod +x OCPlatform11_2.bin && ./OCPlatform11_2.bin -f ./OCPlatform11_2.rsp -i silent && \
	cd /atg/patch/ && unzip /distr/p24950065_112000_Generic.zip && cd OCPlatform11.2_p2/ && chmod +x bin/*.sh && echo Y | bin/install.sh && cd .. && rm -rf OCPlatform11.2_p2 && \
	cd /atg/patch/ && unzip /distr/p25404313_112020_Generic.zip && cd OCPlatform11.2_p2.1/ && chmod +x bin/*.sh && echo Y | bin/install.sh && cd .. && rm -rf OCPlatform11.2_p2.1 && \
	rm -f $DISTR_DIR/*

CMD ["/bin/bash"]