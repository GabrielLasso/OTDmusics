import karax / karax
import karax / karaxdsl
import karax / vdom
import karax / vstyles
import json
import strformat

#
# Data
#

let jsonFile = """
{
    "videos":[
      {
        "id":"Ra-NXgoMZc8",
        "title":"Furusatou no Hibiki",
        "description":"Testando123"
      },
      {
        "id":"Ra-NXgoMZc8",
        "title":"Furusatou no Hibiki",
        "description":"Testando123"
      }
    ]
}
"""

type
  Video = object
    id : string
    title : string
    description : string

  Data = object
    videos : seq[Video]

let jsonObject = parseJson(jsonFile)
let data : Data = to(jsonObject, Data)
let videos = data.videos

#
# Youtube methods
#

proc youtubeUrl(id : string) : string =
  result = fmt "https://www.youtube.com/watch?v={id}"

proc youtubeThumbnail(id : string) : string =
  result = fmt "https://img.youtube.com/vi/{id}/default.jpg"

#
# Create DOM
#

proc createDom(): VNode =
  result = buildHtml(tdiv):
    echo(jsonObject)
    for video in videos:
      a(href = youtubeUrl(video.id), target="_blank", class = "item"):
        img(src = youtubeThumbnail(video.id))
        tdiv:
          text video.title
          br()
          text video.description


setRenderer createDom
