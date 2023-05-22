# @see https://github.com/dpc-sdp/bay/blob/master/bay/images/Dockerfile.php
ARG BAY_IMAGE_VERSION
ARG CLI_IMAGE
FROM ${CLI_IMAGE:-cli} as cli

FROM ghcr.io/dpc-sdp/bay/php-fpm:${BAY_IMAGE_VERSION}

COPY --from=cli /app /app
