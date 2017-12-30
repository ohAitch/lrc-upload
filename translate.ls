to-time = ->
  ("00#{it/60 .|.0}"slice -2) + ":" +
  (100 + it%60)to-fixed 2 .slice 1

asText = ->
  (*"") <| for {text,xmax} in it when text?
    if !text => "\n#{to-time xmax}: "
    else  => "#text"

asLRC = ->
  (*"") <| for {text,xmax} in it when text?
    if !text => "\n[#{to-time xmax}]"
    else  => "#text <#{to-time xmax}>"

parse = (text-grid)->
  for section in text-grid / "]:"
    kv = /([^\s]*) = ([^\s]*)/g
    {[that[1], JSON.parse that[2]] while kv.exec section}

window.addedGrid = ({files:[file]})->
  new FileReader
    ..readAsText file
    ..onload = (target:result:text-grid)->
      preview.innerText = asLRC parse text-grid

@module? && module.exports = {translate,parse,to-time}

# out.innerHTML = parsed.filter(({text})=>text != undefined).map(({text,xmin})=> text).map((s)=> s ? s : "\n").join(" ")
# out.innerHTML = parsed.filter(({text})=>text != undefined).map(({text,xmin})=> !text ? `\n${xmin.toFixed(3)}: ` : `<span title=${xmin.toFixed(3)}>${text}</span>`).join(" "); 0
# out.innerHTML = parsed.filter(({text})=>text != undefined).map(({text,xmin})=> !text ? `\n${fromMin(xmin)}: ` : `<span title=${fromMin(xmin)}>${text}</span>`).join(" "); 0
# out.innerText = parsed.filter(({text})=>text != undefined).map(({text,xmax})=> !text ? `\n[${fromMin(xmax)}]` : `${text} <${fromMin(xmax)}>`).join(""); 0

