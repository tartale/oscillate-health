FROM quay.io/aspenmesh/releases:kubectl-1.5.2

ENV INTERVAL 1200
COPY . /opt/oscillate-health

WORKDIR /opt/oscillate-health
USER root
CMD /opt/oscillate-health/oscillate-health.sh
