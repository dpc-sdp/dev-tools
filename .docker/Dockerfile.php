# @see https://github.com/dpc-sdp/bay/blob/master/bay/images/Dockerfile.php
ARG CLI_IMAGE
FROM ${CLI_IMAGE:-cli} as cli

FROM singledigital/bay-php:latest

# Antivirus update returns non-zero codes.
# @see https://github.com/clamwin/clamav/blob/0.100.1/freshclam/freshclamcodes.h#L23
RUN apk --update add clamav clamav-libunrar \
    && freshclam --no-warnings || true

COPY --from=cli /app /app
