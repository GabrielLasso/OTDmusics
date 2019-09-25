import karax / karax
import karax / karaxdsl
import karax / vdom
import karax / vstyles
import json
import strformat
import sugar
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
    tags : seq[string]

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

proc someItemContains(list : seq[string], str: string) : bool =
  for item in list:
    if item.contains str:
      return true
  return false

proc searchFilter(search : string) : proc (video : Video) : bool =
  return proc(video : Video) : bool =
    return video.title.toLower.contains(search.toLower) or 
      video.tags.map(a => a.toLower).someItemContains(search.toLower)

proc filterVideoList(list : seq[Video], search : string) : seq[Video] =
  return list.filter(searchFilter search)

#
# Create DOM
#

var list = filterVideoList(data.videos, "")

proc createDom(): VNode =
  result = buildHtml(tdiv):
    tdiv(class = "header"):
      img(src = "resources/logo.png"):
        proc onclick(ev : Event, node : VNode) =
            list = filterVideoList(data.videos, "")
      tdiv(class = "search"):
        text("Pesquisar:")
        input(class = "searchBar"):
          proc oninput(ev : Event, node : VNode) =
            list = filterVideoList(data.videos, $node.value)
    for item in list:
      tdiv(class = "item"):
        a(href = youtubeUrl(item.id), target="_blank"):
          img(src = youtubeThumbnail(item.id))
        tdiv:
          a(href = youtubeUrl(item.id), target="_blank"):
            text item.title
          br()
          for tag in item.tags:
            tdiv(class = fmt"tag", id = tag):
              text tag

              proc onclick(ev : Event, node : VNode) =
                list = filterVideoList(data.videos, $node.id)

setRenderer createDom