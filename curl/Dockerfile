FROM debian:wheezy

RUN apt-get update \
	&& apt-get install -y curl \
	&& rm -rf /var/lib/apt/lists/*

ADD kibana-dashboard /kibana-dashboard

WORKDIR kibana-dashboard

RUN chmod +x create_dashboard.sh

CMD ./create_dashboard.sh
