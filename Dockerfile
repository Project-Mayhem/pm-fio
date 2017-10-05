#FROM ubuntu:vivid
FROM arwineap/docker-ubuntu-python3.6:latest

MAINTAINER falenn
# Thanks to Chakravarthy Nelluri <chakri@datawise.io>

RUN apt-get update -yq \
 && apt-get install -yq fio \
 && apt-get install -yq gnuplot \
 && apt-get install -yq curl \
 && apt-get install -yq wget \
 && apt-get install -yq openssh-client \
 && apt-get install -yq sudo \
 && apt-get install -yq iputils-ping \
 && apt-get install -yq dnsutils \
 && apt-get install -yq vim \
 && apt-get install -yq s3cmd \
 && apt-get install -yq sshpass;
 


RUN mkdir -p /mongo \
 && curl https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-3.4.9.tgz | tar xz -C /mongo \
 && ln -s /mongo/mongodb-linux-x86_64-ubuntu1604-3.4.9/bin/mongo /bin/mongo \
 && chmod ugoa+rx /mongo/mongodb-linux-x86_64-ubuntu1604-3.4.9/bin/*;

RUN mkdir /data \
 && mkdir /scripts \
 && mkdir /config;
# && adduser -home /home/fio/ fio;
 
#RUN adduser --disabled-password --gecos '' -m -d /home/fio fio
#adduser fio sudo
#echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD config/job.fio /config/job.fio
ADD entry.sh /entry.sh
ADD script.sh /scripts/script.sh

#RUN chown fio:fio /home/fio/script.sh \
# && chmod u+rx /home/fio/script.sh \
# && chown fio:fio -R /config \
# && chown fio:fio -R /data \

RUN chmod u+x /scripts/script.sh \
 && chmod u+x /entry.sh;

ENTRYPOINT ["/entry.sh"]
