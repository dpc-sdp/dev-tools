# @see https://github.com/dpc-sdp/bay/blob/master/bay/images/Dockerfile.php
ARG CLI_IMAGE
ARG BAY_IMAGE_VERSION=4.x

FROM ${CLI_IMAGE:-cli} as cli

FROM singledigital/bay-php:${BAY_IMAGE_VERSION}

COPY --from=cli /app /app
