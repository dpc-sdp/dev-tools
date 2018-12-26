# @see https://github.com/amazeeio/lagoon/tree/master/images/php/fpm
ARG CLI_IMAGE
FROM ${CLI_IMAGE:-cli} as cli

RUN apk --update add clamav clamav-libunrar \
    # Antivirus update returns non-zero codes.
    # @see https://github.com/clamwin/clamav/blob/0.100.1/freshclam/freshclamcodes.h#L23
    && freshclam || freshclam_exit=$? && [ "$freshclam_exit" == "1" ]

FROM amazeeio/php:7.1-fpm

COPY --from=cli /app /app
