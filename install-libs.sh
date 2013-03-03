
# Downloads a single file (like jQuery) from a remote URL
function singleFile () {
  URL=$1
  DESTINATION_NAME=$2

  if [ -s ${DESTINATION_NAME} ]; then
    echo "---- Skipping ${DESTINATION_NAME}"
  else
    echo "---- Downloading ${URL} into ${DESTINATION_NAME}"
    curl --location -o ${DESTINATION_NAME} ${URL}
  fi
}

# Downloads and unzips a snapshot of a github repo into DESTINATION_NAME
function fromGithub () {
  PROJECT_ROOT_URL=$1
  PROJECT_BRANCH=$2
  DESTINATION_NAME=$3

  PROJECT_NAME=${PROJECT_ROOT_URL##*/}

  [ -z ${PROJECT_BRANCH} ] && PROJECT_BRANCH="master"
  [ -z ${DESTINATION_NAME} ] && DESTINATION_NAME=${PROJECT_NAME}

  if [ -d ${DESTINATION_NAME} ]; then
    echo "---- Skipping ${DESTINATION_NAME} because it already exists"
  else
    echo "---- Downloading a copy of ${DESTINATION_NAME} from ${PROJECT_ROOT_URL}#${PROJECT_BRANCH}"
    curl --location "${PROJECT_ROOT_URL}/archive/${PROJECT_BRANCH}.tar.gz" | tar -xzf -
    mv "${PROJECT_NAME}-${PROJECT_BRANCH}" ${DESTINATION_NAME}
  fi
}


fromGithub "https://github.com/requirejs/text" "" "require-text"

fromGithub "https://github.com/guybedford/require-css"
fromGithub "https://github.com/guybedford/require-less"
fromGithub "https://github.com/SlexAxton/require-handlebars-plugin"
fromGithub "https://github.com/millermedeiros/requirejs-plugins"

fromGithub "https://github.com/FortAwesome/Font-Awesome"

fromGithub "https://github.com/ivaynberg/select2"
fromGithub "https://github.com/pivotal/jasmine"
fromGithub "https://github.com/appendto/jquery-mockjax"

fromGithub "https://github.com/wysiwhat/Aloha-Editor" "dev"

# For github-hosted ebooks
fromGithub "https://github.com/michael/github"


singleFile "http://code.jquery.com/jquery-1.8.3.js" "jquery-1.8.3.js"
singleFile "http://requirejs.org/docs/release/2.1.2/comments/require.js" "require-2.1.2.js"
singleFile "http://marionettejs.com/downloads/backbone.marionette.js" "backbone.marionette.js"
singleFile "https://ajax.googleapis.com/ajax/libs/angularjs/1.0.1/angular.js" "angular.js"

##fromGithub "https://github.com/twitter/bootstrap"
TEMP="bootstrap.zip"
if [ -d "bootstrap" ]; then
  echo "---- Skipping bootstrap"
else
  echo "---- Downloading bootstrap"
  curl --location -o ${TEMP} http://twitter.github.com/bootstrap/assets/bootstrap.zip && unzip ${TEMP} && rm ${TEMP}
fi

