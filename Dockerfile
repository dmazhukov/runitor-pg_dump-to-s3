FROM postgres

ENV USER "root"
ENV DB_HOST ""
ENV DB_PORT "5432"
ENV DB_NAME ""
ENV DB_USER "postgres"
ENV DB_PASSWORD ""
ENV S3_HOST ""
ENV S3_HOST_BUCKET ""
ENV S3_REGION "ru-central1"
ENV BUCKET_NAME ""
ENV ACCESS_KEY ""
ENV SECRET_KEY ""
ENV CHECK_UUID ""
ENV CHECK_SLUG ""
RUN apt update -y && apt install -y s3cmd ca-certificates curl bash
COPY backup.sh .
RUN curl -SsL -O https://github.com/bdd/runitor/releases/download/v0.9.2/runitor-v0.9.2-linux-amd64 && \
    mv runitor-v0.9.2-linux-amd64 runitor && chmod +x runitor
ENTRYPOINT [ "./runitor", "./backup.sh" ]
