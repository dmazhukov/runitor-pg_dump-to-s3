FROM postgres

RUN apt update -y
RUN apt install -y s3cmd ca-certificates

COPY backup.sh .

CMD ./backup.sh
