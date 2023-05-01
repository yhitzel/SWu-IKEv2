FROM python:3.11.3-slim-buster

RUN apt update
RUN apt install -y swig gcc musl-dev git pcsc-tools pcscd libpcsclite-dev net-tools iproute2 tcpdump coreutils iputils-ping dnsutils

RUN python3 -m venv /venv
ENV PATH=/venv/bin:$PATH
WORKDIR /app

RUN pip3 install --upgrade pip

COPY requirements.txt .
RUN pip3 install -r requirements.txt --use-pep517

WORKDIR /tmp
RUN git clone https://github.com/mitshell/CryptoMobile.git
WORKDIR /tmp/CryptoMobile
RUN python3 setup.py install

WORKDIR /tmp
RUN git clone https://github.com/mitshell/card.git
WORKDIR /tmp/card
RUN python3 setup.py install

WORKDIR /app
COPY swu_emulator.py .

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]


# Usage: -a ims -M MCC -N MNC -d epdg.epc.mncMNC.mccMCC.pub.3gppnetwork.org -m 0
# --device-cgroup-rule='c 189:* rmw'