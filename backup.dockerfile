FROM ubuntu

RUN apt update -y
RUN apt install -y postgresql-client s3cmd ca-certificates

COPY backup.sh .

CMD ./backup.sh
