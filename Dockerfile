FROM centos:6

# Update the image with the latest packages and install unzip package
RUN yum update -y && yum install -y unzip && yum clean all

ENV DISTR_DIR /distr

WORKDIR $DISTR_DIR
# Add ATG Commerce 11.2 + patch 11.2.0.2 + fixpack 1 + response file
ADD *.zip ./
ADD OCPlatform11_2.rsp ./
ADD jdk-7u181-linux-x64.rpm ./

# Install JDK
RUN rpm -ihv jdk-7u181-linux-x64.rpm

# Unpack ATG Platform
RUN unzip V78217-01.zip

# Install ATG Platform
RUN chmod +x OCPlatform11_2.bin && ./OCPlatform11_2.bin -f ./OCPlatform11_2.rsp -i silent

# Install patch 11.2.0.2
RUN cd /atg/patch/ && unzip /distr/p24950065_112000_Generic.zip && cd OCPlatform11.2_p2/ && chmod +x bin/*.sh && echo Y | bin/install.sh

# Install 11.2.0.2 fixpack 1
RUN cd /atg/patch/ && unzip /distr/p25404313_112020_Generic.zip && cd OCPlatform11.2_p2.1/ && chmod +x bin/*.sh && echo Y | bin/install.sh

CMD ["/bin/bash"]