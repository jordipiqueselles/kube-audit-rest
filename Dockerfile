# golang:1.19.3-alpine3.16
FROM golang@sha256:d171aa333fb386089206252503bc6ab545072670e0286e3d1bbc644362825c6e as builder

# Can be removed once testing done from go rather than bash
RUN apk add --no-cache bash diffutils git openssl

WORKDIR /src/github.com/RichardoC/kube-audit-rest

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY . .

RUN go build .

RUN CGO_ENABLED=0 GOOS=linux go build .

# Do simple local testing
RUN ./testing/locally/local-testing.sh

# TODO offer scratch as an option

# alpine:3.16
FROM alpine@sha256:b95359c2505145f16c6aa384f9cc74eeff78eb36d308ca4fd902eeeb0a0b161b

EXPOSE 9090

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=builder /src/github.com/RichardoC/kube-audit-rest/kube-audit-rest /src/github.com/RichardoC/kube-audit-rest/kube-audit-rest

USER 255999

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["/src/github.com/RichardoC/kube-audit-rest/kube-audit-rest"]