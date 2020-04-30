FROM ubuntu:18.04
RUN apt-get update && apt-get install wget gnupg -y && \
    printf "deb http://packages.icinga.com/ubuntu icinga-bionic main\ndeb-src http://packages.icinga.com/ubuntu icinga-bionic main" > /etc/apt/sources.list.d/icinga2.list && \
    wget -O - https://packages.icinga.com/icinga.key | apt-key add - && \
    apt-get update && apt-get --no-install-recommends install icinga2 monitoring-plugins tzdata -y && \
    mkdir /run/icinga2 && chown nagios:nagios /run/icinga2 && \
    mkdir -p /var/lib/icinga2/certs && \
    chown -R nagios:nagios /var/lib/icinga2/certs && \
    apt-get remove -y wget gnupg && \
    apt-get autoremove -y && \
    apt-get clean 

COPY create-satellite.sh /create-satellite.sh
COPY run-icinga.sh /run-icinga.sh
RUN chmod +x /create-satellite.sh ; chmod +x /run-icinga.sh
EXPOSE 5665
ENTRYPOINT ["/run-icinga.sh"]
