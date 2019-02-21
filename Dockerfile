FROM arm64v8/ruby:2.6.1-stretch

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --system

ADD . /app
RUN bundle install --system

EXPOSE 8091

CMD ["ruby", "app.rb", "-s", "Puma"]
