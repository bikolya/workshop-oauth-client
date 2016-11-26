# OAuth client demo

## Setup

You need [docker](https://docs.docker.com/engine/installation/) to be installed.

1. Get the code.

        % git clone git@github.com:bikolya/workshop-oauth-client.git

2. Build image.

        % docker-compose build

3. Boot the app.

        % docker-compose up

4. Create OAuth client application on [OAuth server](https://github.com/bikolya/workshop-oauth-server) with Redirect URL `http://localhost:9292/callback`.

        % open http://localhost:3000/oauth/applications/

5. Fill in `CLIENT_ID` and `CLIENT_SECRET` in `app.rb` with given data.

6. Verify that the app is up and running.

        % open http://localhost:9292

