TEMP="temp.zip"

curl -o jquery-1.8.3.js http://code.jquery.com/jquery-1.8.3.js
curl -o require-2.1.2.js http://requirejs.org/docs/release/2.1.2/comments/require.js

git clone https://github.com/requirejs/text.git require-text
git clone https://github.com/guybedford/require-css.git
git clone https://github.com/guybedford/require-less.git
git clone https://github.com/SlexAxton/require-handlebars-plugin.git
git clone https://github.com/millermedeiros/requirejs-plugins.git

echo "Downloading backbone.marionette"
##git clone https://github.com/marionettejs/backbone.marionette.git
curl -o backbone.marionette.js http://marionettejs.com/downloads/backbone.marionette.js

echo "Downloading Twitter Bootstrap"
##git clone https://github.com/twitter/bootstrap.git
curl -o ${TEMP} http://twitter.github.com/bootstrap/assets/bootstrap.zip && unzip ${TEMP}

echo "Downloading Font-Awesome"
##git clone https://github.com/FortAwesome/Font-Awesome.git
curl -o ${TEMP} https://nodeload.github.com/FortAwesome/Font-Awesome/zip/master && unzip ${TEMP} && mv Font-Awesome-master Font-Awesome

git clone https://github.com/ivaynberg/select2.git
git clone https://github.com/pivotal/jasmine.git
git clone https://github.com/appendto/jquery-mockjax.git

git clone https://github.com/wysiwhat/Aloha-Editor.git

# For github-hosted ebooks
git clone https://github.com/michael/github.git

rm ${TEMP}
