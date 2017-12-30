require! <[livescript fs formidable http util]>
runtime =  livescript.compile ""+ fs.read-file-sync "./translate.ls"
#
(req,res) <- -> http.create-server it .listen 1234
if req.url is '/upload' and req.method is /post/i
  form = new formidable.IncomingForm
  form.keepExtensions = yes
  form.on 'fileBegin' (name,f)-> f.path = "./uploads/#{f.name}"
  (err,fields,files) <- form.parse req
  res.write-head 200 "content-type": \text/plain
  res.end """
  recieved upload:
  
  #{util.inspect {fields,files}}
  """
else
  res.write-head 200 "content-type": \text/html
  res.end """
  <input type="file" onchange="addedGrid(this)"/>
  <pre id="preview">Add a .TextGrid transcription</h1>
  <script>#runtime</script>
  """
