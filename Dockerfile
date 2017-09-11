FROM composer:1.5

# node-sass gets built from source (??) so we need the build-base package
RUN composer global require tightenco/jigsaw:v1.0.6 && \
	composer clear-cache && \
	apk --no-cache add nodejs build-base

ENV PATH="/tmp/vendor/bin:${PATH}"

CMD ["jigsaw"]