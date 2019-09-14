import karax / karax
import karax / karaxdsl
import karax / vdom
import karax / vstyles
import json
import strformat
import sequtils
import strutils

#
# Data
#

let jsonFile = """
{
    "videos":[
      {
        "id":"Ra-NXgoMZc8",
        "title":"Campeonato nihon 2011",
        "description":"Furusatou no Hibiki"
      },
      {
        "id":"oRZp1R0zV18",
        "title":"Campeonato brasileiro 2019",
        "description":"Wadatsumi"
      },
      {
        "id":"GQujenMmpPU",
        "title":"2º Japan Matsuri 2010",
        "description":"Fuuga tenshou"
      },
      {
        "id":"OO9j7rWNk9Y",
        "title":"10º Japan Matsuri 2019",
        "description":"Kenka Yatai, Pikachu, Goen, Iroha, Shabondama, Irodori, Gekiryu, Jyuugosou monogatari"
      },
      {
        "id":"-X7mBGFsWNU",
        "title":"Campos do Jordão 2017 Asilo Sakura Home",
        "description":"Shabondama, Irodori, Fuuga tenshou"
      },
      {
        "id":"8SWoSqLODV4",
        "title":"Todoroki fest 2016",
        "description":"Irodori new, solo TAO, Shunka, Yamato gokoro, Iroha, Kenka yatai, Shabondama, Natsukashiki satou, Notodaiko, Omoide"
      },
      {
        "id":"DyCbSHwaNHQ",
        "title":"3º Japan Matsuri 2012",
        "description":"Fuuga tenshou"
      },
      {
        "id":"IztKDK5iiDw",
        "title":"VI Campeonato brasileiro 2009",
        "description":"Go-en"
      },
      {
        "id":"7nBf_6lGyXk",
        "title":"V Campeonato brasileiro 2008",
        "description":"Wadatsumi"
      },
      {
        "id":"5dg42GOmZvs",
        "title":"Campos do Jordão 2017",
        "description":"Kenka yatai, Ryoma no tikara, Shabondama, Notodaiko, Fuuga tenshou, Irodori new"
      },
      {
        "id":"yHO-FqF0UtA",
        "title":"Campeonato UCES 2013",
        "description":"Kizuki"
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

var list = newSeq[Video]()

proc filterVideoList(list : seq[Video], search : string) : seq[Video] =
  return list.filter(
    proc (item : Video) : bool =
      result = item.title.toLower.contains(search.toLower) or item.description.toLower.contains(search.toLower)
    )

proc createDom(): VNode =
  result = buildHtml(tdiv):
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

list = filterVideoList(data.videos, "")