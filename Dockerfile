FROM apphub20/apphost-base:1.0 as builder

WORKDIR /app
COPY . /app

ARG CONFIGURATION="release"
RUN git config --global http.proxy http://docker.for.mac.localhost:1236
RUN git config --global https.proxy http://docker.for.mac.localhost:1236

RUN swift build --configuration ${CONFIGURATION} --product AppHost

# ------------------------------------------------------------------------------

FROM apphub20/apphost-base:1.0

ARG CONFIGURATION="release"

WORKDIR /app
COPY --from=builder /app/.build/${CONFIGURATION}/AppHost /app

ENTRYPOINT ["/app/AppHost"]
CMD ["serve", "--hostname", "0.0.0.0", "--port", "8080"]
