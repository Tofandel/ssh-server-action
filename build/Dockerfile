FROM alpine:latest

RUN apk add --no-cache --update sudo openssh bash openssh-keygen

COPY setup.sh /setup.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /setup.sh
RUN chmod +x /entrypoint.sh
RUN ./setup.sh

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]