FROM alpine:latest
WORKDIR /app
RUN apk add --no-cache bash
COPY . .
RUN chmod +x {{ENTRYPOINT}}
CMD ["./{{ENTRYPOINT}}"]
