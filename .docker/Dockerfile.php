# @see https://github.com/dpc-sdp/bay/blob/master/bay/images/Dockerfile.php
ARG CLI_IMAGE
ARG BAY_IMAGE_VERSION=latest

FROM ${CLI_IMAGE:-cli} as cli

FROM singledigital/bay-php:${BAY_IMAGE_VERSION}

# Antivirus update returns non-zero codes.
# @see https://github.com/clamwin/clamav/blob/0.100.1/freshclam/freshclamcodes.h#L23
RUN apk --update add clamav clamav-libunrar \
&& freshclam --no-warnings || true

COPY --from=cli /app /app
