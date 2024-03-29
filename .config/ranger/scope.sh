#!/usr/bin/env zsh
set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'
# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | Display stdout as preview
# 1    | no preview | Display no preview at all
# 2    | plain text | Display the plain content of the file
# 3    | fix width  | Don't reload when width changes
# 4    | fix height | Don't reload when height changes
# 5    | fix both   | Don't ever reload
# 6    | image      | Display the image `$IMAGE_CACHE_PATH` points to as an image preview
# 7    | image      | Display the file directly as an image

# Script arguments
FILE_PATH="${1}"         # Full path of the highlighted file
PV_WIDTH="${2}"          # Width of the preview pane (number of fitting characters)
PV_HEIGHT="${3}"         # Height of the preview pane (number of fitting characters)
IMAGE_CACHE_PATH="${4}"  # Full path that should be used to cache image preview
PV_IMAGE_ENABLED="${5}"  # 'True' if image previews are enabled, 'False' otherwise.

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER=$(echo ${FILE_EXTENSION} | tr '[:upper:]' '[:lower:]')

# Settings
HIGHLIGHT_SIZE_MAX=262143  # 256KiB
HIGHLIGHT_TABWIDTH=2
HIGHLIGHT_STYLE='zenburn'

handle_extension() {
  case "${FILE_EXTENSION_LOWER}" in
    # Archive
    a|ace|alz|arc|arj|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
    rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
        atool --list -- "${FILE_PATH}" && exit 5
        bsdtar --list --file "${FILE_PATH}" && exit 5
        exit 1;;
    rar)
        # Avoid password prompt by providing empty password
        unrar lt -p- -- "${FILE_PATH}" && exit 5
        exit 1;;
    7z)
        # Avoid password prompt by providing empty password
        7z l -p -- "${FILE_PATH}" && exit 5
        exit 1;;
    # PDF
    pdf)
        chafa --size="${PV_WIDTH}x$((PV_HEIGHT-10))" --animate=off --bg="#ffffff" -t 1 -c 16 "${FILE_PATH}" && exit 5
        exiftool "${FILE_PATH}" && exit 5
        exit 1;;
    # BitTorrent
    torrent)
        transmission-show -- "${FILE_PATH}" && exit 5
        exit 1;;
    # OpenDocument
    odt|ods|odp|sxw)
        # Preview as text conversion
        odt2txt "${FILE_PATH}" && exit 5
        exit 1;;
    # HTML
    htm|html|xhtml)
        # Preview as text conversion
        w3m -dump "${FILE_PATH}" && exit 5
        lynx -dump -- "${FILE_PATH}" && exit 5
        elinks -dump "${FILE_PATH}" && exit 5
        ;; # Continue with next handler on failure
  esac
}
handle_image() {
  local mimetype="${1}"
  case "${mimetype}" in
    # SVG
     image/svg+xml)
       convert "${FILE_PATH}" "${IMAGE_CACHE_PATH}" && exit 6
       exit 1;;
    # Image
    image/*)
      local orientation
      orientation="$(identify -format '%[EXIF:Orientation]\n' -- "${FILE_PATH}" )"
      # If orientation data is present and the image actually
      # needs rotating ("1" means no rotation)...
      if [[ -n "$orientation" && "$orientation" != 1 ]]; then
        convert -- "${FILE_PATH}" -auto-orient "${IMAGE_CACHE_PATH}" && exit 6
      fi
      exit 7;;
    # Video
     video/*)
         # Thumbnail
         ffmpegthumbnailer -i "${FILE_PATH}" -o "${IMAGE_CACHE_PATH}" -s 0 && exit 6
         exit 1;;
    # PDF
     application/pdf)
       pdftoppm -f 1 -l 1 \
                -scale-to-x 1920 \
                -scale-to-y -1 \
                -singlefile \
                -jpeg -tiffcompression jpeg \
                -- "${FILE_PATH}" "${IMAGE_CACHE_PATH%.*}" \
       && exit 6 || exit 1;;
  esac
}

handle_mime() {
  local mimetype="${1}"
  case "${mimetype}" in
    # Text
    text/* | */xml | */json)
      # Syntax highlight
      if [[ "$( stat --printf='%s' -- "${FILE_PATH}" )" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
        exit 2
      fi
      if [[ "$( tput colors )" -ge 256 ]]; then
        local highlight_format='xterm256'
      else
        local highlight_format='ansi'
      fi
      highlight --replace-tabs="${HIGHLIGHT_TABWIDTH}" --out-format="${highlight_format}" \
        --style="${HIGHLIGHT_STYLE}" --force -- "${FILE_PATH}" && exit 5
      exit 2;;
    # Image
    image/*)
      chafa --size="${PV_WIDTH}x$((PV_HEIGHT-10))" -O 9 -c 16 "${FILE_PATH}" &&
      # since sometimes somethings gets messed
      # up here remove all the colors
      # also break some lines in order exiftool to work
      tput init&&
      echo "~~If u can read this then this line is not needed :) ~~"&&
      exiftool -S -ImageSize -FileType -ColorType -ColorSpace -ColorSpaceData -ProfileDescription "${FILE_PATH}" &&
      exit 4
      exit 1;;
    # Video and audio
    video/* | audio/*)
      exiftool "${FILE_PATH}" && exit 5
      exit 1;;
  esac
}
handle_fallback() {
  exiftool "${FILE_PATH}"&&
  exit 5
}
MIMETYPE="$( file --dereference --brief --mime-type -- "${FILE_PATH}" )"
if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
  handle_image "${MIMETYPE}"
fi
handle_extension
handle_mime "${MIMETYPE}"
handle_fallback
exit 1
