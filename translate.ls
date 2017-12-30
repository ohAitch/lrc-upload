to-time = ->
  ("00#{it/60 .|.0}"slice -2) + ":" +
  (100 + it%60)to-fixed 2 .slice 1

asText = ->
  (*"") <| for {text,xmax} in it when text?
    if !text => "\n#{to-time xmax}: "
    else  => "#text"

asLRC = ->
  (*"") <| for {text,xmax,name}, i in it
    switch
    | name? => "[length: #{to-time xmax}]\n" 
    | text => "#text <#{to-time xmax}>"
    | !text? => ""
    | it[i+1]?.text => "\n[#{to-time xmax}]"
    | _ => "\n"

parse = (text-grid)->
  for section in text-grid / "]:"
    kv = /([^\s]*) = ([^\s]*)/g
    {[that[1], JSON.parse that[2]] while kv.exec section}

@addedGrid = ({files:[file]})->
  new FileReader
    ..readAsText file
    ..onload = (target:result:text-grid)->
      preview.innerText = asLRC parse text-grid
      lrcSubmit.hidden = no

@submitLrc = ->
  fetch("/transcribed.json", method: 'post' body: JSON.stringify preview.innerText)

try
  module.exports = {asLRC, asText,parse,to-time}

# out.innerHTML = parsed.filter(({text})=>text != undefined).map(({text,xmin})=> text).map((s)=> s ? s : "\n").join(" ")
# out.innerHTML = parsed.filter(({text})=>text != undefined).map(({text,xmin})=> !text ? `\n${xmin.toFixed(3)}: ` : `<span title=${xmin.toFixed(3)}>${text}</span>`).join(" "); 0
# out.innerHTML = parsed.filter(({text})=>text != undefined).map(({text,xmin})=> !text ? `\n${fromMin(xmin)}: ` : `<span title=${fromMin(xmin)}>${text}</span>`).join(" "); 0
# out.innerText = parsed.filter(({text})=>text != undefined).map(({text,xmax})=> !text ? `\n[${fromMin(xmax)}]` : `${text} <${fromMin(xmax)}>`).join(""); 0

