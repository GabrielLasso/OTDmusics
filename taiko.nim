import karax / karax
import karax / karaxdsl
import karax / vdom
import karax / vstyles
import json
import strformat
import sequtils
import strutils
import videosJson

#
# Data
#

type
  Video = object
    id : string
    title : string
    description : string

  Data = object
    videos : seq[Video]

let jsonObject = parseJson(videosJsonStr)
let data : Data = to(jsonObject, Data)

#
# Youtube methods
#

proc youtubeUrl(id : string) : string =
  result = fmt "https://www.youtube.com/watch?v={id}"

proc youtubeThumbnail(id : string) : string =
  result = fmt "https://img.youtube.com/vi/{id}/default.jpg"

#
# Search methods
#

proc filterVideoList(list : seq[Video], search : string) : seq[Video] =
  return list.filter(
    proc (item : Video) : bool =
      result = item.title.toLower.contains(search.toLower) or item.description.toLower.contains(search.toLower)
    )

#
# Create DOM
#

var list = filterVideoList(data.videos, "")

proc createDom(): VNode =
  result = buildHtml(tdiv):
    text("Pesquisar:")
    input():
      proc oninput(ev : Event, node : VNode) =
        list = filterVideoList(data.videos, $node.value)
    for item in list:
      a(href = youtubeUrl(item.id), target="_blank", class = "item"):
        img(src = youtubeThumbnail(item.id))
        tdiv:
          text item.title
          br()
          text item.description


setRenderer createDom