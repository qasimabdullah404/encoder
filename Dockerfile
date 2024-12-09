FROM ruby:3.2.4-alpine
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN gem install bundler:2.5.21 && \
    apk add --no-cache build-base && \
    bundle install
COPY lib /app/lib/
COPY config.ru /app/

EXPOSE 1111
ENV RACK_ENV=production
CMD [ "bundle", "exec", "rackup", "-p", "1111" ]