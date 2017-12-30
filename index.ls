require! <[livescript fs formidable http util]>
runtime =  livescript.compile ""+ fs.read-file-sync "./translate.ls"
#
(req,res) <- -> http.create-server it .listen 1234
switch req.url
| '/upload' =>
  if req.method isnt /post/i
    throw Error "upload over POST"
  form = new formidable.IncomingForm
  form.keepExtensions = yes
  form.on 'fileBegin' (name,f)-> f.path = "./uploads/#{f.name}"
  (err,fields,files) <- form.parse req
  res.write-head 200 "content-type": \text/plain
  res.end """
  recieved upload:
  
  #{util.inspect {fields,files}}
  """
| '/transcribed.json' =>
  if req.method isnt /post/i
    throw Error "upload over POST"
  jsonString = ''
  req.on 'data' (jsonString +=)
  req.on 'end' ->
    str = JSON.parse jsonString
    name = str.slice 0,100 .replace /[ ]/g '_' .replace /[^a-zA-Z_]/g ''
    fs.write-file-sync "./uploads/#name.lrc", str
    res.end 'Succeess!'
| _ =>
  res.write-head 200 "content-type": \text/html
  res.end """
  <form action="/upload" enctype="multipart/form-data" method="post">
    .ogg audio: <input type="file" name=upload/> <input type="submit"/>
  </form>
  Transcribed text:
  <input type="file" onchange="addedGrid(this)"/><br>
  <textarea id="lyrics" placeholder="Optional canonical lyrics..."></textarea>
  <pre id="preview">Add a .TextGrid transcription</pre>
  <input hidden id=lrcSubmit type=submit onclick="submitLrc()"/>
  <script>#runtime</script>
  """
