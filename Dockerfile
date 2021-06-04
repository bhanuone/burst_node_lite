MAINTAINER Bhanu Prakash

FROM alpine:3.13.5 AS build

RUN apk add curl && apk add wget && apk add p7zip

WORKDIR /brs

RUN curl -s https://api.github.com/repos/burst-apps-team/burstcoin/releases/latest \
| grep "browser_download_url.*zip" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -q -O brs.zip -i -

RUN 7z x -y brs.zip -o./extracted

FROM openjdk:16-ea-alpine

COPY --from=build /brs/extracted /brs

WORKDIR /brs

ENTRYPOINT [ "java", "-jar", "burst.jar", "--headless" ]
