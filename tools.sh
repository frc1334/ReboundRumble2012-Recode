#!/bin/bash
# FRC 1334 General repo tools

touch .result
PATH=$PATH:./ucpp-master/ucpp

function show-menu
{
  dialog --backtitle "FRC 1334 Repository Tools"\
    --menu "Choose a function" 20 70 14\
      setup     "Setup"\
      configure "Configure Environment"\
      build     "Build"\
      deploy    "Deploy"\
      gource    "Gource Render" 2> .result
  $0 `cat .result`
}

function setup
{
  curl -L -o ./master.zip  https://github.com/nikitakit/ucpp/archive/master.zip
  unzip -o ./master.zip
  rm master.zip
  yes | ucpp setup -t 1334
}

function configure
{
  ucpp init
  yes | ucpp configure py
}

function build
{
  make
}

function deploy
{
  make deploy
}

function do-gource
{
  mkdir -p ./.git/avatar
  for LINE in `git log --pretty=format:"%ae|%an" | sort | uniq` ; do curl -o ./.git/avatar/`echo $LINE | cut -d \| -f 2`.png http://www.gravatar.com/avatar/`echo $LINE | cut -d \| -f 1 | tr -d '\n' | md5sum | cut -d " " -f 1`?d=404&size=90 ; done;
  gource --seconds-per-day 10 --file-idle-time 0 --key --bloom-multiplier 1.0 --bloom-intensity 1.5 --background 000000 --title "FRC 1334 ROBOT CODE" --auto-skip-seconds 2.5 --camera-mode overview -r 60 -1280x720 --user-image-dir ./.git/avatar --disable-progress --stop-at-end --highlight-all-users --output-ppm-stream - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 gource.mp4
}

case "$1" in
'')
  show-menu;;
'setup')
  clear
  setup;;
'configure')
  clear
  configure;;
'build')
  clear
  build;;
'deploy')
  clear
  deploy;;
'gource')
  clear
  do-gource;;
*)
  echo "Invalid option $1"
  exit 1;;
esac

rm .result &> /dev/null
